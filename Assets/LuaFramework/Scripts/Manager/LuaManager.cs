/**
 * 文件名称：LuaManager.cs
 * 简    述：这里其实是以前ulua时代的LuaScriptMgr类。对luaState进行了包装管理。
 * 0.在Awake中将Wrap注册进Lua虚拟机，载入第三方库。
 * 1.initStart函数，直接初始化Lua文件的加载路径(可以多个)、初始化LuaBundle（启用的话），启动StartLooper，启动Lua里面的Main.lua脚本，。
 * 2.LuaLooper是C#驱动lua协同而实现的功能类，如果不启动，那lua种的扩展功能，coroutine.www类，coroutine.wait都无法实现。
 * 3.OpenLibs方法，为了打开众多第三方库，比如pbc、cjson等，tolua#包装了LuaState.OpenLibs函数，里面的参数是LuaCSFunction类型，也就是被设置了标记的C#访问Native函数：
 *  [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
 *  public static extern int luaopen_pb(IntPtr L);
 *  也就是说，如果用户需要增加新的第三方原生库，需要添加类似打开库的LuaCSFunction函数，并在LuaManager.OpenLibs方法里面打开它磁能生效。
 * 4.InitLuaPath函数，主要就是可以通过AddSearchPath添加对于lua代码的搜索路径。我将加载打包好的lua代码也放在这个函数中，反正搜索文件都是这个函数决定的。
 * 5.DoFile函数。就是将一个lua代码文件（字符串string）加载到lua虚拟机中，运行起来。
 * 6.CallFunction函数。就是让执行一个lua函数，执行的参数格式为：（“table.function”,参数1,参数2,...）但是这个会造成GC,尽量不用；替换为Invoke或luaFunc.ToDelegate调用模式。
 * 7.LuaGC函数。让lua虚拟机回收内存空间。
 * 8.Close等其他函数都是跟ulua一样，关闭luastate，清理操作等。
 * 使用方法：在HotFixManager的OnInitialize进行调用InitStart()。
 * 创建标识：Lorry 2018/1/26
 * 修改标识：修改InitLuaPath，使用遍历lua目录下所有.unity3d文件并加载的方式加载打包后的lua脚本。Lorry 2018-2-20
 * 修改标识：添加新的函数调用接口CallLuaFunction，及获取LuaFunction的函数GetLuaFunction。Lorry 2018-2-20
 **/
using UnityEngine;
using System;
using System.IO;
using LuaInterface;

namespace LuaFramework
{
    public class LuaManager : Manager
    {
        private LuaState lua;
        private LuaLoader loader;
        private LuaLooper loop = null;

        // Use this for initialization
        void Awake()
        {
            //AwakeInit();
        }
        //本来是在Awake中初始化
        void AwakeInit()
        {
            loader = new LuaLoader();
            lua = new LuaState();
            this.OpenLibs();
            lua.LuaSetTop(0);

            LuaBinder.Bind(lua);
            DelegateFactory.Init();
            LuaCoroutine.Register(lua, this);
        }

        public void InitStart()
        {
            AwakeInit();
            //根据LuaClient的编写方式在LuaState的Start之前，OpenLibs之后，开始进行调试设置
            if (LuaConst.openLuaSocket)
            {
                OpenLuaSocket();
            }

            if (LuaConst.openLuaDebugger)
            {
                OpenZbsDebugger();
            }

            InitLuaPath();
            this.lua.Start();    //启动LUAVM
            this.StartLooper();  
            this.StartMain();   //原来都是StartLooper在StartMain前面，这样在Main中编写代码岂不是不能用Looper支持的特性？
        }

        void StartLooper()
        {
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;
        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
        protected void OpenCJson()
        {
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");

            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain()
        {
            lua.DoFile("Main.lua");

            LuaFunction main = lua.GetFunction("Main");
            main.Call();
            main.Dispose();
            main = null;
        }

        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs()
        {
            lua.OpenLibs(LuaDLL.luaopen_pb);
            lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
            lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();
        }
        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath()
        {
#if UNITY_EDITOR
            if (EditorUtil.DevelopMode)
            {
                string rootPath = AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "/Lua");
                lua.AddSearchPath(rootPath + "/ToLua/Lua");
                return;
            }
#endif
            if (loader.beZip)
            {
                //在lua目录中添加新文件夹必须在这里添加对应的assetbundle，但这样每次改代码不人性化。
                //1.可以优化为在打包是就生成所有lua脚本打包文件的列表（.unity3d列表），在这里依次Addbundle。
                //2.遍历lua目录下所有的.unity3d文件并加载。现在选择了第二种方法。Lorry 2018-2-20
                string[] names = Directory.GetFiles(Util.DataPath + "lua", "*.unity3d");
                for (int i = 0; i < names.Length; i++)
                {
                    names[i] = names[i].Replace('\\', '/').Replace(Util.DataPath, "");
                    loader.AddBundle(names[i]);
                }

                //loader.AddBundle("lua/lua.unity3d");
                ////loader.AddBundle("lua/lua_math.unity3d");
                //loader.AddBundle("lua/lua_common.unity3d");
                //loader.AddBundle("lua/lua_controller.unity3d");
                //loader.AddBundle("lua/lua_logic.unity3d");
                //loader.AddBundle("lua/lua_misc.unity3d");
                //loader.AddBundle("lua/lua_protobuf.unity3d");

                //loader.AddBundle("lua/lua_system.unity3d");
                //loader.AddBundle("lua/lua_system_reflection.unity3d");
                //loader.AddBundle("lua/lua_unityengine.unity3d");
                //loader.AddBundle("lua/lua_view.unity3d");

                //loader.AddBundle("lua/lua_3rd_cjson.unity3d");
                //loader.AddBundle("lua/lua_3rd_luabitop.unity3d");
                //loader.AddBundle("lua/lua_3rd_pbc.unity3d");
                //loader.AddBundle("lua/lua_3rd_pblua.unity3d");
                //loader.AddBundle("lua/lua_3rd_sproto.unity3d");
            }
            else
            {
                lua.AddSearchPath(Util.DataPath + "lua");
            }
        }

        public void DoFile(string filename)
        {
            lua.DoFile(filename);
        }
#pragma warning disable 0618
        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                return func.LazyCall(args);
            }
            return null;
        }
#pragma warning restore 0618
        /// <summary>
        /// 实现对void函数的调用
        /// </summary>
        public void CallLuaFunction(string funcName)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call();
                func.Dispose();
            }
            else
            {
                //Debugger.Log("Lua function %s not exist!", funcName);
            }
        }
        /// <summary>
        /// 传入一个参数进行luaFunction的调用
        /// </summary>
        public void CallLuaFunction<T>(string funcName, T arg)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call<T>(arg);
                func.Dispose();
            }
        }
        /// <summary>
        /// 传入两个参数进行luaFunction的调用
        /// </summary>
        public void CallLuaFunction<T1,T2>(string funcName, T1 arg1, T2 arg2)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                func.Call<T1,T2>(arg1, arg2);
                func.Dispose();
            }
        }


        /// <summary>
        /// 获取唯一luaState中的函数进行调用。注意用完后要Dispose()，不然LuaFunction中一直保持引用无法GC回收。
        /// </summary>
        /// <param name="funcName">函数全名</param>
        /// <returns>LuaFunction类对象，方便进行lua函数调用</returns>
        public LuaFunction GetLuaFunction(string funcName)
        {
            return lua.GetFunction(funcName);
        }

        public void LuaGC()
        {
            lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void Close()
        {//这里添加判断，主要是有可能没有调用InitStart，就关闭了
            if (loop != null)
            {
                loop.Destroy();
                loop = null;
            }

            if (lua != null)
            {
                lua.Dispose();
                lua = null;
                loader = null;
            }
        }

        #region 为了进行lua调试添加的代码Lorry 2018-2-19
        public void OpenZbsDebugger(string ip = "localhost")
        {
            if (!Directory.Exists(LuaConst.zbsDir))
            {
                Debugger.LogWarning("ZeroBraneStudio not install or LuaConst.zbsDir not right");
                return;
            }

            if (!LuaConst.openLuaSocket)
            {
                OpenLuaSocket();
            }

            if (!string.IsNullOrEmpty(LuaConst.zbsDir))
            {
                lua.AddSearchPath(LuaConst.zbsDir);
            }

            lua.LuaDoString(string.Format("DebugServerIp = '{0}'", ip), "@LuaClient.cs");
        }

        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int LuaOpen_Socket_Core(IntPtr L)
        {
            return LuaDLL.luaopen_socket_core(L);
        }

        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int LuaOpen_Mime_Core(IntPtr L)
        {
            return LuaDLL.luaopen_mime_core(L);
        }

        protected void OpenLuaSocket()
        {
            LuaConst.openLuaSocket = true;

            lua.BeginPreLoad();
            lua.RegFunction("socket.core", LuaOpen_Socket_Core);
            lua.RegFunction("mime.core", LuaOpen_Mime_Core);
            lua.EndPreLoad();
        }
        #endregion 
    }
}