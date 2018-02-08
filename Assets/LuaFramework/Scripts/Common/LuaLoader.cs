using UnityEngine;
using System.Collections;
using System.IO;
using LuaInterface;

namespace LuaFramework {
    /// <summary>
    /// 集成自LuaFileUtils，重写里面的ReadFile，
    /// </summary>
    public class LuaLoader : LuaFileUtils {
        private LuaResourceManager m_resMgr;

        LuaResourceManager resMgr {
            get { 
                if (m_resMgr == null)
                    m_resMgr = AppFacade.Instance.GetManager<LuaResourceManager>(ManagerName.Resource);
                return m_resMgr;
            }
        }

        // Use this for initialization
        public LuaLoader() {
            instance = this;
            beZip = AppConst.LuaBundleMode;
#if UNITY_EDITOR
            if (EditorUtil.DevelopMode)
            {//如果是在开发模式,肯定是读取真实文件，不会再打包文件中读代码。
                beZip = false;
            }
#endif
        }

        /// <summary>
        /// 添加打入Lua代码的AssetBundle
        /// </summary>
        /// <param name="bundle"></param>
        public void AddBundle(string bundleName) {
            string url = Util.DataPath + bundleName.ToLower();
            if (File.Exists(url)) {
                var bytes = File.ReadAllBytes(url);
                AssetBundle bundle = AssetBundle.LoadFromMemory(bytes);
                if (bundle != null)
                {
                    //Debugger.Log("AddLuaBundle：" + url + "["+ bytes.Length +"]");
                    bundleName = bundleName.Replace("lua/", "").Replace(".unity3d", "");
                    base.AddSearchBundle(bundleName.ToLower(), bundle);
                }
            }
            else
            {
                //Debugger.LogWarning("LuaBundle不存在：" + url);
            }
        }

        /// <summary>
        /// 当LuaVM加载Lua文件的时候，这里就会被调用，
        /// 用户可以自定义加载行为，只要返回byte[]即可。
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public override byte[] ReadFile(string fileName) {
            return base.ReadFile(fileName);     
        }
    }
}