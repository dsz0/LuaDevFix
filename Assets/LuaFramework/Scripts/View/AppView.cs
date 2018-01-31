
/**
 * 文件名称：AppView.cs
 * 简    述：继承View，是一个范例：注册View 感兴趣的信息，处理信息
 * [使用方法]：将其添加到一个GameObject上即可，在StartUpCommand.cs中有范例
 * AppView appView = gameMgr.AddComponent<AppView>();
 * 创建标识：Lorry 2018/1/27
 **/
using UnityEngine;
using LuaFramework;
using System.Collections.Generic;

public class AppView : View {
    private string message;
    private string messageName;

    ///<summary>
    /// 监听的消息
    ///</summary>
    List<string> MessageList {
        get {
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

    void Awake() {
        RemoveMessage(this, MessageList);//防止重复注册，收到两次消息。
        RegisterMessage(this, MessageList);
    }

    /// <summary>
    /// 处理View消息
    /// </summary>
    /// <param name="message"></param>
    public override void OnMessage(IMessage message) {
        string name = message.Name;
        object body = message.Body;

        this.messageName = message.Name;
        switch (name) {
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

    public void UpdateMessage(string data) {
        this.message = data;
    }

    public void UpdateExtract(string data) {
        this.message = data;
    }

    public void UpdateDownload(string data) {
        this.message = data;
    }

    public void UpdateProgress(string data) {
        this.message = data;
    }

    string extractFileName;
    int extractNowCount = 0;
    int extractAllCount = 0;

    string updateFileName;
    int updateNowCount = 0;
    int updateAllCount = 0;
    string updateSpeed;

    float progress = 0.0f;
    void OnGUI() {
        //GUI.Label(new Rect(10, 0, 500, 50), "(1) 单击 \"Lua/Gen Lua Wrap Files\"。(2) 运行Unity游戏");
        //GUI.Label(new Rect(10, 20, 500, 50), "PS: 清除缓存，单击\"Lua/Clear LuaBinder File + Wrap Files\"。");
        //GUI.Label(new Rect(10, 40, 500, 50), "PS: 若运行到真机，请设置Const.DebugMode=false，本地调试=true");
        //GUI.Label(new Rect(10, 60, 900, 50), message);
        GUILayout.Label("Message:"+ message);
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
            GUILayout.Label("下载状态数：" + updateNowCount +"/" + updateAllCount);
            GUILayout.Label("下载速度：" + updateSpeed);
        }
    }
}
