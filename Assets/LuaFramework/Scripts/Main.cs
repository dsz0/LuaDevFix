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
            Invoke("RealStart", 0.3f);
        }

        void RealStart()
        {
            AppFacade.Instance.StartUp();   //启动游戏
        }
    }
}