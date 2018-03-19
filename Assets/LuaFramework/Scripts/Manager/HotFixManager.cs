/**
 * 文件名称：HotFixManager.cs
 * 简    述：这里最重要的功能其实是解包，进行资源更新，然后在OnInitialize中执行.lua文件。
 * 当然因为函数中调用了LuaManager.InitStart()，所以在Main.lua中执行我们需要的逻辑也是可行的。
 * 如果更新界面也要热更得话。解包过程要分两次。第一次解包后执行lua逻辑，第二次解包后才更新（这时才能用进度条表现热更新进度）(暂时不做）。
 * 使用方法：这里会持续的发出当前正在解压的文件及更新信息，只需要对应的类中监听NotiConst.UPDATE_MESSAGE即可进行显示。
 * 创建标识：Lorry 2018/1/26
 **/

using UnityEngine;
using UnityEngine.Networking;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using System.Threading;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace LuaFramework
{
    /// <summary>
    /// 解包，及下载管理，在这个类中进入游戏。
    /// </summary>
    public class HotFixManager : Manager
    {
        //bool firstExtractResource = true;
        /// <summary>
        /// 包内资源的版本
        /// </summary>
        string m_InVersion = "0.0.0";
        /// <summary>
        /// 数据目录资源版本(更新到的)
        /// </summary>
        string m_DataVersion = "0.0.0";
        /// <summary>
        /// 异步加载对象
        /// </summary>
        //WWW downloadOperation;
        private int num = 0;//计数器，更新完一个文件加1
        private int len = 100;//需要更新文件的数量
        bool needHotFix = true;//判断是否需要热更
        bool beginInit = true;//判断资源是否已经加载
        object objLock = new object();//加个锁，防止线程同时读取
        List<string> HadDownLoadDestination = new List<string>();//已经进入下载的进行标记

        /// <summary>
        /// 用于lua热更完成后的回调。
        /// </summary>
        Action m_callbackfunc;
        public void AddCallBack(Action callback)
        {
            m_callbackfunc = callback;
        }

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
            //if (downloadOperation != null && !downloadOperation.isDone)
            //{
            //string message = string.Format("下载进度:{0:F}%", downloadOperation.progress * 100.0);
            //Debugger.Log(message); 
            //facade.SendMessageCommand(NotiConst.UPDATE_SPEED, message);
            //}
            if (beginInit == true)//判断资源是否已经加载
            {
                if (needHotFix)
                {
                    if (num == len)
                    {
                        string message = "资源更新完成!!";
                        facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                        beginInit = false;
                        int len = HadDownLoadDestination.Count;
                        for (int i = 0; i < len; i++)
                        {
                            Debug.Log(HadDownLoadDestination[i]);
                            PlayerPrefs.DeleteKey(HadDownLoadDestination[i]);
                        }
                        OnResourceInited();

                    }
                }
                else
                {
                    string message = "资源更新完成!!";
                    facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                    beginInit = false;
                    OnResourceInited();
                }
            }


        }

        /// <summary>
        /// 初始化
        /// </summary>
        void Init()
        {
            DontDestroyOnLoad(gameObject);  //防止销毁自己

            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = AppConst.GameFrameRate;
#if UNITY_EDITOR
            if (EditorUtil.DevelopMode)
            {
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "DevelopMode");
                //OnResourceInited(); 如果是模拟调试，不需要载入Manifest
                StartCoroutine(OnReadyCallBack());
                return;
            }
#endif
            CheckExtractResource(); //释放资源
        }


        /// <summary>
        /// 释放资源
        /// </summary>
        public void CheckExtractResource()
        {
            if (UtilEx.IsFirstOpen())
            {
                StartCoroutine(OnExtractResource());    //启动释放协成 
            }
            else
            {//不是第一次打开，文件已经解压过了，这里还可以添加检查文件列表逻辑
                StartCoroutine(OnUpdateResource());
            }
        }

        IEnumerator OnExtractResource()
        {
            string resPath = Util.AppContentPath(); //程序包中的资源目录(不可修改)
            string dataPath = Util.DataPath;  //数据目录

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
            facade.SendMessageCommand(NotiConst.EXTRACT_ALL_COUNT, files.Length - 1);
            //foreach (var file in files)
            m_InVersion = files[0];
            for (int i = 1; i < files.Length; i++)
            {
                string[] fs = files[i].Split('|');
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
#pragma warning disable 0162
            if (!AppConst.UpdateMode)
            {
                OnResourceInited();
                yield break;
            }
            string dataPath = Util.DataPath;  //数据目录
            string url = AppConst.WebUrl;
            //string message = string.Empty;
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
#pragma warning restore 0162
            #region lorry2-9，获取服务器版本，更新对应版本的资源
            //TODO:这个version也可以向Server服务器请求获得
            string versionUrl = url + "server_version.txt?v=" + random;
            UnityWebRequest verDownload = UnityWebRequest.Get(versionUrl);
            yield return verDownload.Send();
            if(verDownload.isError) {
                Debug.Log(verDownload.error);
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "获得server_version.txt失败！热更中断：" + verDownload.error);
                yield break;
            }
            string version = verDownload.downloadHandler.text;
            url = AppConst.WebUrl + version + "/" + Util.GetPlatformName() + "/";
            #endregion
            string listUrl = url + "files.txt?v=" + random;
            Debug.LogWarning("Down files.txt -->>" + listUrl);

            UnityWebRequest www = UnityWebRequest.Get(listUrl); 
            yield return www.Send();
            if (www.isError)
            {
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "更新files.txt失败！热更中断：" + www.error);
                yield break;
            }
            if (!Directory.Exists(dataPath))
            {
                Directory.CreateDirectory(dataPath);
            }
            //首先把files.txt写到数据目录。
            File.WriteAllBytes(dataPath + "files.txt", www.downloadHandler.data);
            string filesText = www.downloadHandler.text;
            string[] files = filesText.Split('\n');
            Debug.LogWarning("Write files.txt To-->>" + dataPath);
            m_DataVersion = files[0];
            //这里修改了luaFramework的原始流程，先把所有的操作动作存下来。
            List<string> willDownLoadUrl = new List<string>();//from  
            List<string> willDownLoadFileName = new List<string>();
            List<string> willDownLoadDestination = new List<string>();//to  
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "分析需要更新的文件");
            Debug.LogWarning("分析需要更新的文件:" + files.Length);
            int totalSize = 0;
            for (int i = 1; i < files.Length; i++)
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
                    if (PlayerPrefs.GetString(localfile) == version)//判断本地是否有已经下载的信息
                    {
                        canUpdate = false;
                        willDownLoadDestination.Add(localfile);//有下载信息也要下载
                    }
                    if (canUpdate) File.Delete(localfile); //md5码不同，把本地文件删除，接下来会下载这个文件。
                }
                if (canUpdate)
                {
                    int fileSize = int.Parse(keyValue[2]);
                    totalSize += fileSize;
                    willDownLoadUrl.Add(fileUrl);//下载地址  
                    willDownLoadFileName.Add(f);
                    willDownLoadDestination.Add(localfile);//目标文件路径  
                    //这里本来是使用了线程下载，但是我测试中总是卡在第一个下载，暂时换www来进行下载。
                    //等到需要在游戏中边运行边下载，再考虑线程下载。ThreadManager不成功，总是在OnDownloadFile中WebClient.DownloadFileAsync后就没有反应了
                    //添加的DownloadProgressChangedEventHandler(ProgressChanged)无法进入，而且异常也没捕获。
                }
            }

            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "开始下载更新文件" + Util.FormatFileSize(totalSize));
            if (willDownLoadUrl.Count > 0)
            {
                facade.SendMessageCommand(NotiConst.UPDATE_ALL_COUNT, willDownLoadUrl.Count);
            }
            else
            {
                Debug.LogWarning("分析完毕，没有文件需要更新！");
                needHotFix = false;
            }
            //这里是对比后需要更新的资源文件，TODO:用线程下载
            len = willDownLoadUrl.Count;
            num = 0;
            for (int i = 0; i < willDownLoadUrl.Count; i++)
            {
                Debug.Log("下载：" + willDownLoadUrl[i]);
                facade.SendMessageCommand(NotiConst.UPDATE_FILE_NAME, willDownLoadFileName[i]);
                PlayerPrefs.SetString(willDownLoadDestination[i], version);//如果已经下载设置值为版本号
                HadDownLoadDestination.Add(willDownLoadDestination[i]);
                Thread thread = new Thread(new ParameterizedThreadStart(Down));
                thread.Start(willDownLoadUrl[i] + "|" + willDownLoadDestination[i] + "|" + willDownLoadFileName[i]);
            }
            yield return new WaitForEndOfFrame();
        }

        /// <summary>
        /// 线程下载
        /// </summary>
        /// <param name="file"></param>
        private void Down(System.Object file)
        {
            string[] fileName = file.ToString().Split('|');
            string willDownLoadUrl = fileName[0];
            string willDownLoadDestination = fileName[1];
            //string willDownLoadFileName = fileName[2];

            long DownloadByte = 0;//用于显示当前的进度
            long lStartPos = 0; //打开上次下载的文件或新建文件 
            FileStream fileStream;

            if (File.Exists(willDownLoadDestination))//接着断点下载
            {
                fileStream = File.OpenWrite(willDownLoadDestination);//打开流
                lStartPos = fileStream.Length;//通过字节流的长度确定当前的下载位置
                fileStream.Seek(lStartPos, SeekOrigin.Current); //移动文件流中的当前指针 
            }
            else
            {
                fileStream = new FileStream(willDownLoadDestination, FileMode.Create);
                lStartPos = 0;
            }
            try
            {
                HttpWebRequest request = WebRequest.Create(willDownLoadUrl) as HttpWebRequest;
                if (lStartPos > 0)
                    request.AddRange((int)lStartPos); //设置Range值,向服务器请求，获得服务器回应数据流 
                //try
                //{
                //    HttpWebResponse reponse = (HttpWebResponse)request.GetResponse();
                //}
                //catch (WebException webEx)
                //{
                //    Debug.Log(webEx.ToString());
                //}
                Stream responseStream = request.GetResponse().GetResponseStream();
                byte[] nbytes = new byte[1024];
                int nReadSize = 0;
                nReadSize = responseStream.Read(nbytes, 0, 1024);
                while (nReadSize > 0)
                {
                    fileStream.Write(nbytes, 0, nReadSize);
                    nReadSize = responseStream.Read(nbytes, 0, 1024);
                    DownloadByte = DownloadByte + nReadSize;
                }
                fileStream.Close();
                responseStream.Close();
                Debug.Log("Loading complete");
                facade.SendMessageCommand(NotiConst.UPDATE_FINISH_ONE, 0);
                lock (objLock)
                {
                    num++;
                }
            }
            catch (Exception ex)
            {
                fileStream.Close();
                Debug.Log(ex.ToString());
            }
        }


        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited()
        {
            //TODO：显示In Version[1.5.3] Update Version[1.5.7]
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, "In[" + m_InVersion + "]Update[" + m_DataVersion + "]");
            //#if ASYNC_MODE 本来这里有两种模式，我现在放弃非ASYNC模式
            //ResManager.Initialize(AppConst.AssetDir, delegate ()
            ResManager.Initialize(Util.GetPlatformName(), delegate ()
            {
                StartCoroutine(OnReadyCallBack());
            });
        }
        //准备好进行
        IEnumerator OnReadyCallBack()
        {
            yield return new WaitForEndOfFrame();// WaitForSeconds(0.1f);
            m_callbackfunc();
            //Debug.LogError("OnReadyCallback");
            //gameObject.AddComponent<LuaGameEnter>();
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy()
        {
        }



    }
}