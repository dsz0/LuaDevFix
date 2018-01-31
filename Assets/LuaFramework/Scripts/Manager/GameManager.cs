/**
 * 文件名称：GameManager.cs
 * 简    述：这里最重要的功能其实是解包，进行资源更新，然后在OnInitialize中执行.lua文件，当然因为函数中调用了LuaManager.InitStart()，所以在Main.lua中执行我们需要的逻辑也是可行的。
 * 如果更新界面也要热更得话。解包过程要分两次。第一次解包后执行lua逻辑，第二次解包后才更新（这时才能用进度条表现热更新进度）。
 * 为什么要解包两次呢？因为进度界面的lua代码需要依赖一些核心的lua文件，所以干脆先把lua文件全都解包。
 * 使用方法：这里会持续的发出当前正在解压的文件及更新信息，只需要对应的类中监听NotiConst.UPDATE_MESSAGE即可进行显示。
 * 创建标识：Lorry 2018/1/26
 **/

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;


namespace LuaFramework
{
    public class GameManager : Manager
    {
        protected static bool initialize = false;
        bool hadExtractResource;
        //bool firstExtractResource = true;
        /// <summary>
        /// 异步加载对象
        /// </summary>
        WWW downloadOperation;
        /// <summary>
        /// 初始化游戏管理器
        /// </summary>
        void Awake()
        {
            Init();
        }

        void Update()
        {
            //判断异步对象并且异步对象没有加载完毕，显示进度    
            if (downloadOperation != null && !downloadOperation.isDone)
            {
                string message = string.Format("下载进度:{0:F}%", downloadOperation.progress * 100.0);
                Debugger.Log(downloadOperation.url + message); 
                facade.SendMessageCommand(NotiConst.UPDATE_SPEED, message);
            }
        }
        /// <summary>
        /// 初始化
        /// </summary>
        void Init()
        {
            DontDestroyOnLoad(gameObject);  //防止销毁自己
            CheckExtractResource(); //释放资源
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = AppConst.GameFrameRate;
        }


        /// <summary>
        /// 释放资源
        /// </summary>
        public void CheckExtractResource()
        {
            hadExtractResource = Directory.Exists(Util.DataPath) &&
              Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
            if (hadExtractResource || AppConst.DebugMode)
            { //文件已经解压过了，这里还可以添加检查文件列表逻辑
                StartCoroutine(OnUpdateResource());
                return;
            }
            StartCoroutine(OnExtractResource());    //启动释放协成 
        }

        IEnumerator OnExtractResource()
        {
            string dataPath = Util.DataPath;  //数据目录
            string resPath = Util.AppContentPath(); //程序包中的资源目录(不可修改)

            if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
            Directory.CreateDirectory(dataPath);

            string infile = resPath + "files.txt";
            string outfile = dataPath + "files.txt";
            if (File.Exists(outfile)) File.Delete(outfile);

            //string message = "正在解包文件:>files.txt";
            Debug.Log(infile);
            Debug.Log(outfile);
            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;

                if (www.isDone)
                {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            }
            else File.Copy(infile, outfile, true);
            yield return new WaitForEndOfFrame();

            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "开始内部文件解包");
            //释放所有文件到数据目录
            string[] files = File.ReadAllLines(outfile);
            facade.SendMessageCommand(NotiConst.EXTRACT_ALL_COUNT, files.Length);
            foreach (var file in files)
            {
                string[] fs = file.Split('|');
                infile = resPath + fs[0];  //
                outfile = dataPath + fs[0];

                //message = "正在解包文件:>" + fs[0];
                Debug.Log("正在解包文件:>" + infile);
                //facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                string dir = Path.GetDirectoryName(outfile);
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

                facade.SendMessageCommand(NotiConst.EXTRACT_FILE_NAME, infile);
                if (Application.platform == RuntimePlatform.Android)
                {
                    WWW www = new WWW(infile);
                    yield return www;

                    if (www.isDone)
                    {
                        File.WriteAllBytes(outfile, www.bytes);
                        facade.SendMessageCommand(NotiConst.EXTRACT_FINISH_ONE, 0);
                    }
                    yield return 0;
                }
                else
                {
                    if (File.Exists(outfile))
                    {
                        File.Delete(outfile);
                    }
                    File.Copy(infile, outfile, true);
                    facade.SendMessageCommand(NotiConst.EXTRACT_FINISH_ONE, 0);
                }
                yield return new WaitForEndOfFrame();
            }
            //message = "解包完成!!!";
            //facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            yield return new WaitForSeconds(0.1f);

            //message = string.Empty;
            //释放完成，开始启动更新资源
            StartCoroutine(OnUpdateResource());
        }

        /// <summary>
        /// 启动更新下载，这里只是个思路演示，此处可启动线程下载更新
        /// </summary>
        IEnumerator OnUpdateResource()
        {
            if (!AppConst.UpdateMode)
            {
                OnResourceInited();
                yield break;
            }
            string dataPath = Util.DataPath;  //数据目录
            string url = AppConst.WebUrl;
            string message = string.Empty;
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string listUrl = url + "files.txt?v=" + random;
            Debug.LogWarning("LoadUpdate---->>>" + listUrl);

            WWW www = new WWW(listUrl); yield return www;
            if (www.error != null)
            {
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "更新files.txt文件失败！热更无法继续");
                yield break;
            }
            if (!Directory.Exists(dataPath))
            {
                Directory.CreateDirectory(dataPath);
            }
            //首先把files.txt写到数据目录。
            File.WriteAllBytes(dataPath + "files.txt", www.bytes);
            string filesText = www.text;
            string[] files = filesText.Split('\n');

            //这里修改了luaFramework的原始流程，先把所有的操作动作存下来。
            List<string> willDownLoadUrl = new List<string>();//from  
            List<string> willDownLoadFileName = new List<string>();
            List<string> willDownLoadDestination = new List<string>();//to  
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "分析需要更新的文件");
            for (int i = 0; i < files.Length; i++)
            {//分析每一个文件是否需要更新
                if (string.IsNullOrEmpty(files[i])) continue;
                string[] keyValue = files[i].Split('|');
                string f = keyValue[0];
                string localfile = (dataPath + f).Trim();
                string path = Path.GetDirectoryName(localfile);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                string fileUrl = url + f + "?v=" + random;
                bool canUpdate = !File.Exists(localfile);//本地文件不存在，肯定要更新。
                if (!canUpdate)
                {//本地存在fileUrl的这个文件，这里进行md5的对比，如果相同就不更新了。
                    string remoteMd5 = keyValue[1].Trim();
                    string localMd5 = Util.md5file(localfile);
                    canUpdate = !remoteMd5.Equals(localMd5);
                    if (canUpdate) File.Delete(localfile); //md5码不同，把本地文件删除，接下来会更新这个文件。
                }
                if (canUpdate)
                {
                    willDownLoadUrl.Add(fileUrl);//下载地址  
                    willDownLoadFileName.Add(f);
                    willDownLoadDestination.Add(localfile);//目标文件路径  
                    //这里本来是使用了线程下载，但是我测试中总是卡在第一个下载，暂时换www来进行下载。
                    //等到需要在游戏中边运行边下载，再考虑线程下载。ThreadManager不成功，总是在OnDownloadFile中WebClient.DownloadFileAsync后就没有反应了
                    //添加的DownloadProgressChangedEventHandler(ProgressChanged)无法进入，而且异常也没捕获。
                }
            }

            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "开始下载更新文件");
            if (willDownLoadUrl.Count > 0)
            {
                facade.SendMessageCommand(NotiConst.UPDATE_ALL_COUNT, willDownLoadUrl.Count);
            }
            //这里是对比后需要更新的资源文件，TODO:用线程下载
            for (int i = 0; i < willDownLoadUrl.Count; i++)
            {
                Debug.Log("要下载的文件：" + willDownLoadUrl[i]);
                facade.SendMessageCommand(NotiConst.UPDATE_FILE_NAME, willDownLoadFileName[i]);
                downloadOperation = new WWW(willDownLoadUrl[i]);
                yield return downloadOperation;
                if (downloadOperation.error != null)
                {//指明更新失败的文件。退出循环！
                    facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "更新失败!>" + willDownLoadFileName[i]);
                    yield break;
                }
                File.WriteAllBytes(willDownLoadDestination[i], downloadOperation.bytes);
                downloadOperation = null;//避免update循环中判断过多
                facade.SendMessageCommand(NotiConst.UPDATE_FINISH_ONE, 0);
            }
            yield return new WaitForEndOfFrame();

            message = "更新完成!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            OnResourceInited();
        }

        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited()
        {
#if ASYNC_MODE
            ResManager.Initialize(AppConst.AssetDir, delegate ()
            {
                Debug.Log("Initialize OK!!!");
                this.OnInitialize();
            });
#else
            ResManager.Initialize();
            this.OnInitialize();
#endif
        }

        void OnInitialize()
        {
            LuaManager.InitStart();
            //LuaManager.DoFile("Logic/Game");         //加载游戏
            //LuaManager.DoFile("Logic/Network");      //加载网络
            //NetManager.OnInit();                     //初始化网络
            //Util.CallMethod("Game", "OnInitOK");     //初始化完成

            initialize = true;
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy()
        {
            if (NetManager != null)
            {
                NetManager.Unload();
            }
            if (LuaManager != null)
            {
                LuaManager.Close();
            }
            Debug.Log("~GameManager was destroyed");
        }
    }
}