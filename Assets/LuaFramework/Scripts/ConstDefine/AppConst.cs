using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
#if UNITY_EDITOR	
using UnityEditor;
#endif

public class AppConst
{
    #region lua热更所需Add by Lorry
    /// 如果想删掉框架自带的例子，那这个例子模式必须要
    /// 关闭，否则会出现一些错误。
    public static bool ExampleMode = false;                       //例子模式 

    /// <summary>
    /// 如果开启更新模式，需要自己将StreamingAssets里面的所有内容复制到自己的Webserver上面，并修改下面的WebUrl。
    /// 下面是打包配置
    /// </summary>

    public const bool UpdateMode = true;                      //更新模式-默认关闭 
    public const bool LuaByteMode = false;                    //Lua字节码模式-默认关闭 
    public const bool LuaBundleMode = true;                   //Lua代码AssetBundle模式，注意：在开发模式中为true,也不会读取assetbundle中的lua哦！

    public const int TimerInterval = 1;
    public const int GameFrameRate = 40;                        //游戏帧频

    public const string AppName = "LuaFramework";//"LuaRaz";    //应用程序名称
    public const string LuaTempDir = "LuaTemp/";                //临时目录
    public const string AppPrefix = AppName + "_";              //应用程序前缀
    public const string ExtName = ".unity3d";                   //素材扩展名
    public const string AssetDir = "StreamingAssets";           //素材目录 

    //public const string WebUrl = "https://www.dsz0.com/cnt/StreamingAssets/";      //测试更新地址
    public const string WebUrl = "https://www.dsz0.com/and/";      //测试更新地址
    public static string UserId = string.Empty;                 //用户ID
    public static int SocketPort = 0;                           //Socket服务器端口
    public static string SocketAddress = string.Empty;          //Socket服务器地址

    public static string FrameworkRoot
    {
        get
        {
            return Application.dataPath + "/" + AppName;
        }
    }
    #endregion
    //---------------------------------------------------------------------------------------------
    /// 以下部分为Raz专用
    //播放CG动画
    public static bool PlayCG = true;

    public const string FilesInfoName = "FilesInfo.md5";

    public static string Version = "1.5";
    public static string IsForceVersion = "yes";//yes.no.force.auto

    public static string getBaseWebUrl()
    {
        switch (GameLoginController.Instance.ChanelType)
        {
            case GameLoginManager.ChanelEnum.Dark:
                return "http://120.24.231.66:889/Dark/";
            case GameLoginManager.ChanelEnum.Dark2:
                return "http://120.24.231.66:889/Dark2/";
            case GameLoginManager.ChanelEnum.Issue:
                return "http://120.24.231.66:889/Issue/";
            case GameLoginManager.ChanelEnum.YH_Indra:
                return "http://120.24.231.66:889/YH/";
            case GameLoginManager.ChanelEnum.YH_Inner_Test:
                return "https://ios-version.ljr.yhres.cn/inner_test/";
            case GameLoginManager.ChanelEnum.YH_Logagent_Test:
                return "http://123.59.146.79:8088/logagent_test/";
            case GameLoginManager.ChanelEnum.YH_Pro_test:
                return "http://123.59.146.68:8088/pro_test/";
            case GameLoginManager.ChanelEnum.YH_Public:
                return "http://123.59.146.79:8088/jingying_test/";
            case GameLoginManager.ChanelEnum.YH_China:
                return "http://106.75.14.214:8088/version/";
            case GameLoginManager.ChanelEnum.Testin:
                return "http://120.24.231.66:889/Testin/";
            case GameLoginManager.ChanelEnum.Taste:
                return "http://120.24.231.66:889/Taste/";
            case GameLoginManager.ChanelEnum.YH_PC_Test:
                return "http://123.59.146.68:8088/experience/";
            case GameLoginManager.ChanelEnum.Business:
                return "http://120.24.231.66:889/Business/";
            case GameLoginManager.ChanelEnum.Hydra_Indra:
                return "http://120.24.231.66:889/Hydra/";
            case GameLoginManager.ChanelEnum.Hydra_Test:
                return "http://164.52.11.210:8088/test/";
            case GameLoginManager.ChanelEnum.Wonder_Test:
                return "http://120.24.231.66:889/Wonder/";
            case GameLoginManager.ChanelEnum.WonderCheck:
                return "http://wonder.indra-soft.com:8088/WonderCheck/";
            case GameLoginManager.ChanelEnum.AUS_Chanel:
                return "https://aus.indra-soft.com/AUS/";
            case GameLoginManager.ChanelEnum.OutSide_Channel:
                return "https://aus.indra-soft.com/AUSTest/";
            case GameLoginManager.ChanelEnum.Tencent_Channel:
                return "https://aus.indra-soft.com/Tencent/";
            case GameLoginManager.ChanelEnum.TXTest_Channel:
                return "http://120.24.231.66:889/TXTest/";
            case GameLoginManager.ChanelEnum.Tencent_Light:
                return "http://tencent.raziel.net/TencentLight/";
            case GameLoginManager.ChanelEnum.TencentCE:
                return "http://120.24.231.66:889/TencentCE/";
        }
        return "";
    }

    #region Add by CY 
    public static IPStruct LoginServerAddr = new IPStruct();
    public static IPStruct LogServerAddr = new IPStruct();
    #endregion

    public static string PackageURL = string.Empty;
}
#region Add by CY
[Serializable]
public class IPStruct
{
    public string DomainAddr;
    public string IPAddr;
    public string Port;
    public IPStruct(string domain, string ip, string port)
    {
        this.DomainAddr = domain;
        this.IPAddr = ip;
        this.Port = port;
    }
    public IPStruct() { }

    public void Set(string AddrLine)
    {
        if (string.IsNullOrEmpty(AddrLine)) return;
        StringBuilder sb = new StringBuilder(AddrLine);
        sb.Replace("\r", "");
        string[] ipstr = sb.ToString().Split('|');
        DomainAddr = ipstr[0];
        IPAddr = ipstr[1];
        Port = ipstr[2];
    }
}
#endregion