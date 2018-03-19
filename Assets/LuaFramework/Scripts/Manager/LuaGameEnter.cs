/**
 * 文件名称：LuaGameEnter.cs
 * 简    述：lua游戏逻辑的入口
 * 如果需要重新加载整个lua游戏逻辑，对LuaGameEnter进行处理即可。
 * 创建标识：Lorry 2018/1/26
 **/

//using System.Collections;
//using System.Collections.Generic;
using UnityEngine;
//using UnityEngine.SceneManagement;

namespace LuaFramework
{
    /// <summary>
    /// 主要把原来HotFixManager中进入游戏的部分
    /// </summary>
    public class LuaGameEnter : Manager
    {
        protected static bool initialize = false;

        // Use this for initialization
        void Start()
        {
            LuaInit();

        }

        public void LuaInit(string enterType = "test")
        {
            LuaManager.InitStart();
            LuaManager.DoFile("start");             //加载游戏
            LuaManager.DoFile("logic/Network");     //加载网络
            NetManager.OnInit();                     //初始化网络
           //在Raz每次切换场景后，需要将之前的界面都卸载，然后根据载入场景的类型显示界面。
           //LuaManager.CallLuaFunction("GameManager.OnInitOK");
            LuaManager.CallLuaFunction<string>("GameManager.OnInitOK", enterType);
            //在Raz中已经占用了这个系统类名，在SceneManager对应的地方直接调用函数好了。
            //SceneManager.sceneLoaded += delegateOnSceneLoaded;
            initialize = true;
            test();
            //testSocket();
        }


        void test()
        {
            ByteBuffer temp = new ByteBuffer();
            temp.WriteString("UTF-8 现在是测试随便传");
            temp.WriteString("Hello world");
            temp.WriteInt(108);
            //temp.Close();

            ByteBuffer tempR = new ByteBuffer(temp.ToBytes());
            //Debug.Log(tempR.ReadInt());
            //Debug.Log(tempR.ReadString());
            LuaManager.CallLuaFunction<int, ByteBuffer>("Network.OnSocket", 19000, tempR);
            //LuaManager.DoFile("ui/test/test");
            //Util.CallMethod("Test", "FuncTest", tempR);     //初始化完成
        }

        void testSocket()
        {
            LuaManager.DoFile("ui/test/test_socket");
            Util.CallMethod("TestSocket", "FuncTest");
        }

        /// <summary>
        /// 场景和预加载资源真正加载完成后调用的函数，考虑到以后场景资源也会分块打包，所以这里先做预设。
        /// </summary>
        /// <param name="level"></param>
        //private void delegateOnSceneLoaded(Scene scene, LoadSceneMode mode)
        //{
        //    LuaManager.CallLuaFunction("GameManager.OnSceneLoaded");
        //}

        /// <summary>
        /// 在主游戏的场景加载中调用此函数。
        /// </summary>
        /// <param name="info">场景加载</param>
        public void OnSceneLoaded(string info)
        {
            LuaManager.CallLuaFunction<string>("GameManager.OnSceneLoaded", info);
        }

        public void DestroyGame()
        {
            LuaManager.CallLuaFunction("GameManager.Destroy");
        }

        // This function is called when the MonoBehaviour will be destroyed.
        void OnDestroy()
        {
            LuaManager.CallLuaFunction("GameManager.OnDestroy");
            initialize = false;
            //SceneManager.sceneLoaded -= delegateOnSceneLoaded;

            if (NetManager != null)
            {
                NetManager.Unload();
            }
            if (LuaManager != null)
            {
                LuaManager.Close();
            }
            Debug.Log("~LuaGameEnter(Manager) was destroyed");
        }

        private void OnApplicationQuit()
        {
            LuaManager.CallLuaFunction("GameManager.OnApplicationQuit");
        }
    }
}
