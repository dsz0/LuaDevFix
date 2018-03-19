/**
 * 文件名称：AppView.cs
 * 简    述：继承View，是一个范例：注册View 感兴趣的信息，处理信息
 * [使用方法]：将其添加到一个GameObject上即可，在StartUpCommand.cs中有范例
 * AppView appView = gameMgr.AddComponent<AppView>();
 * 创建标识：Lorry 2018/1/27
 **/
using UnityEngine;
using LuaFramework;
using System;
using System.Collections.Generic;
using System.IO;

public class AppView : View
{
    private string message;
    private string messageName;

    private DateTime loadTime;
    ///<summary>
    /// 监听的消息
    ///</summary>
    List<string> MessageList
    {
        get
        {
            return new List<string>()
            {
                NotiConst.UPDATE_MESSAGE,
                NotiConst.UPDATE_EXTRACT,
                NotiConst.UPDATE_DOWNLOAD,
                NotiConst.UPDATE_PROGRESS,

                NotiConst.EXTRACT_FILE_NAME,
                NotiConst.EXTRACT_FINISH_ONE,
                NotiConst.EXTRACT_ALL_COUNT,

                NotiConst.UPDATE_SPEED,
                NotiConst.UPDATE_FILE_NAME,
                NotiConst.UPDATE_FINISH_ONE,
                NotiConst.UPDATE_ALL_COUNT,
            };
        }
    }

    void Awake()
    {
        RemoveMessage(this, MessageList);//防止重复注册，收到两次消息。
        RegisterMessage(this, MessageList);
        loadTime = DateTime.Now;
    }

    /// <summary>
    /// 处理View消息
    /// </summary>
    /// <param name="message"></param>
    public override void OnMessage(IMessage message)
    {
        string name = message.Name;
        object body = message.Body;

        this.messageName = message.Name;
        switch (name)
        {
            case NotiConst.UPDATE_MESSAGE:      //更新消息
                UpdateMessage(body.ToString());
                break;
            case NotiConst.UPDATE_EXTRACT:      //更新解压
                UpdateExtract(body.ToString());
                break;
            case NotiConst.UPDATE_DOWNLOAD:     //更新下载
                UpdateDownload(body.ToString());
                break;
            case NotiConst.UPDATE_PROGRESS:     //更新下载进度
                UpdateProgress(body.ToString());
                break;
            case NotiConst.EXTRACT_FILE_NAME:
                extractFileName = body.ToString();
                break;
            case NotiConst.EXTRACT_FINISH_ONE:
                extractNowCount++;
                break;
            case NotiConst.EXTRACT_ALL_COUNT:
                extractAllCount = (int)body;
                break;
            case NotiConst.UPDATE_SPEED:
                updateSpeed = body.ToString();
                break;
            case NotiConst.UPDATE_FILE_NAME:
                updateFileName = body.ToString();
                break;
            case NotiConst.UPDATE_FINISH_ONE:
                updateNowCount++;
                break;
            case NotiConst.UPDATE_ALL_COUNT:
                updateAllCount = (int)body;
                break;
        }
    }

    public void UpdateMessage(string data)
    {
        this.message = data;
    }

    public void UpdateExtract(string data)
    {
        this.message = data;
    }

    public void UpdateDownload(string data)
    {
        this.message = data;
    }

    public void UpdateProgress(string data)
    {
        this.message = data;
    }

    string extractFileName;
    int extractNowCount = 0;
    int extractAllCount = 0;

    string updateFileName;
    int updateNowCount = 0;
    int updateAllCount = 0;
    string updateSpeed;

    //用于遍历LuaDir下的文件
    List<string> paths = new List<string>();
    List<string> files = new List<string>();

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    void Recursive(string path)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".lua"))
                files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }

    List<string> luaReload = new List<string>();

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Delete))
        {//处理新修改lua文件的重载。
            paths.Clear(); files.Clear();
            string luaDataPath = LuaConst.luaDir.ToLower();
            Recursive(luaDataPath);
            luaReload.Clear();
            for (int i = 0; i < files.Count; i++)
            {
                string file = files[i];
                string value = file.Replace(luaDataPath +'/', string.Empty);
                #region 增加读取文件修改时间的代码Lorry
                FileInfo fileInfo = null;
                try
                {
                    fileInfo = new FileInfo(file);
                }
                catch (Exception e)
                {
                    Debug.LogException(e);
                    // 其他处理异常的代码
                }
                #endregion
                int t1 = fileInfo.LastWriteTime.CompareTo(this.loadTime);
                if (t1 > 0)
                    luaReload.Add(value.Replace(".lua", string.Empty));
            }

            Debug.Log("更新lua文件数量:" + luaReload.Count);
            for (int i = 0; i < luaReload.Count; i++)
            {
                Debug.Log(luaReload[i]);
                LuaManager.DoFile(luaReload[i]);
            }
            this.loadTime = DateTime.Now;
        }
    }

    static readonly GUIContent fun1btn = new GUIContent("TestOpen", "第一个功能。");
    static readonly GUIContent fun2btn = new GUIContent("TestClose", "第二个功能。");
    static readonly GUIContent fun3btn = new GUIContent("打开Tips", "第三个功能。");

    float progress = 0.0f;
    void OnGUI()
    {
        //GUI.Label(new Rect(10, 0, 500, 50), "(1) 单击 \"Lua/Gen Lua Wrap Files\"。(2) 运行Unity游戏");
        //GUI.Label(new Rect(10, 20, 500, 50), "PS: 清除缓存，单击\"Lua/Clear LuaBinder File + Wrap Files\"。");
        //GUI.Label(new Rect(10, 40, 500, 50), "PS: 若运行到真机，请设置Const.DebugMode=false，本地调试=true");
        //GUI.Label(new Rect(10, 60, 900, 50), message);
        GUILayout.BeginHorizontal();
        //string luafile = "ui/common/TipsMediator";
        //luafile = GUILayout.TextField(luafile, 30);
        if (GUILayout.Button(fun1btn))
        {
            //LuaManager.DoFile(luafile);
            LuaManager.CallLuaFunction("MainTestOpen");
        }
        if (GUILayout.Button(fun2btn))
        {//这里的问题在于全部的数据也被销毁了，要重新向服务器请求。
            //AppFacade.Instance.UnloadLuaState();
            LuaManager.CallLuaFunction("MainTestClose");
        }
        if (GUILayout.Button(fun3btn))
        {
            LuaManager.CallLuaFunction<string>("Facade.SendMessage", "OpenTips");
            //AppFacade.Instance.EnterLua();
            //"切进主城", "模拟进入主城注册Command。"
            //LuaManager.CallLuaFunction("Facade.ChangeScene");
            //LuaManager.CallLuaFunction<string>("GameManager.OnSceneLoaded", "main_city");
        }

        GUILayout.Label("Message:" + message);
        GUILayout.EndHorizontal();

        if (string.IsNullOrEmpty(messageName)) return;
        if (messageName.StartsWith("EXTRACT_"))
        {
            GUILayout.Label("正在解包的文件：" + extractFileName);
            GUILayout.Label("当前解包数/总数：" + extractNowCount + "/" + extractAllCount);
            progress = (float)extractNowCount / extractAllCount;
            GUILayout.Label(string.Format("解包进度数:{0:F}%", progress * 100.0));
        }
        else if (messageName.StartsWith("UPDATE_"))
        {
            GUILayout.Label("正在下载的文件：" + updateFileName);
            GUILayout.Label("下载状态数：" + updateNowCount + "/" + updateAllCount);
            GUILayout.Label("下载速度：" + updateSpeed);
        }
    }
}
