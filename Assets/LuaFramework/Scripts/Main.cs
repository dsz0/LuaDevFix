using UnityEngine;
using System.Collections;

namespace LuaFramework {

    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour {

        void Start()
        {
            //强制设一次屏幕分辨率
            Screen.SetResolution(1280, 720, true);
            Invoke("RealStart", 0.1f);
        }

        void RealStart()
        {
            //gameObject.AddComponent<LocalSocketManager>();

            //LocalSocketManager.Instance.InitSocketManager("127.0.0.1", 7871);
            //LocalSocketManager.Instance.AsynConnect(this.AsynConnetHandler);

            //AppFacade.Instance.StartUp();   //启动游戏
            AppFacade.Instance.StartInRac(OnLuaStart);
        }

        
        void OnLuaStart()
        {
            AppFacade.Instance.EnterLua();
            //tempGame = gameObject.AddComponent<LuaGameEnter>();
            //Debug.LogError("OnTest");
            //GameObject.Destroy(tempGame);
        }
    }
}