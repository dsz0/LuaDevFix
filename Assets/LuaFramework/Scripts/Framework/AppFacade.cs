using UnityEngine;
using System;
using LuaFramework;
using Consolation;

public class AppFacade : Facade
{
    private static AppFacade _instance;

    public AppFacade() : base()
    {
    }

    public static AppFacade Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new AppFacade();
            }
            return _instance;
        }
    }

    override protected void InitFramework()
    {
        base.InitFramework();
    }

    /// <summary>
    /// 启动框架
    /// </summary>
    public void StartUp()
    {
        RegisterCommand(NotiConst.START_UP, typeof(StartUpCommand));

        SendMessageCommand(NotiConst.START_UP);
        RemoveMultiCommand(NotiConst.START_UP);
    }

    public void StartInRac(Action fun)
    {
        if (!Util.CheckEnvironment()) return;

        GameObject gameMgr = GameObject.Find("GameManager");
        if (gameMgr != null)
        {
            //AppView appView = 
            gameMgr.AddComponent<AppView>();
            //TestConsole console = 
            gameMgr.AddComponent<TestConsole>();
        }
        //-----------------关联命令-----------------------
        AppFacade.Instance.RegisterCommand(NotiConst.DISPATCH_MESSAGE, typeof(SocketCommand));

        //-----------------初始化管理器-----------------------
        AppFacade.Instance.AddManager<LuaManager>(ManagerName.Lua);
        AppFacade.Instance.AddManager<PanelManager>(ManagerName.Panel);
        AppFacade.Instance.AddManager<SoundManager>(ManagerName.Sound);
        AppFacade.Instance.AddManager<TimerManager>(ManagerName.Timer);
        AppFacade.Instance.AddManager<NetworkManager>(ManagerName.Network);
        AppFacade.Instance.AddManager<RazNetworkManager>(ManagerName.RazNetwork);
        AppFacade.Instance.AddManager<LuaResourceManager>(ManagerName.Resource);
        AppFacade.Instance.AddManager<ThreadManager>(ManagerName.Thread);
        AppFacade.Instance.AddManager<ObjectPoolManager>(ManagerName.ObjectPool);
        AppFacade.Instance.AddManager<HotFixManager>(ManagerName.MainLua);

        HotFixManager hotfix = AppFacade.Instance.GetManager<HotFixManager>(ManagerName.MainLua);
        hotfix.AddCallBack(fun);
    }

    private LuaGameEnter tempGame = null;
    /// <summary>
    /// 卸载luaState，lua运行环境。TODO:这处理方式还可以优化，先这样运行。
    /// </summary>
    public void UnloadLuaState()
    {
        if (tempGame)
        {
            tempGame.DestroyGame();
            GameObject.Destroy(tempGame);
            tempGame = null;
        }
    }
    /// <summary>
    /// 这个函数加载lua主代码后可以在UnloadLuaState中方便的重新加载。
    /// 不过问题在Reload后，lua中全部的数据也被销毁了，要重新向服务器请求。
    /// </summary>
    /// <param name="add2Go"></param>
    public void EnterLua(GameObject add2Go = null)
    {
        if (add2Go == null)
            add2Go = GameObject.Find("GameManager"); 
        tempGame = add2Go.AddComponent<LuaGameEnter>();
    }
}