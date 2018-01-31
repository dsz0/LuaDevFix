/**
 * 文件名称：HttpDownLoad.cs
 * 简    述：主要为了实现断点续传功能编写这个HttpDownLoad类。怀疑https会造成异常！！
 * 不过现在的GameManager的逻辑其实不会让断点续传这个功能起效果，会删除md5码不一致的文件，需要进一步编码实现。 
 * 使用方法：在更新类中（本工程为GameManager）添加成员变量
 * private HttpDownLoad mDownload; //断点续传，线程下载对象。
 * private List<string> downloadFiles = new List<string>();
 * 添加下面三个函数
 *      bool IsDownOK(string file) { return downloadFiles.Contains(file); }
        void BeginHttpDownLoad(string url, string localfile) {
            mDownload = gameObject.AddComponent<HttpDownLoad>();
            mDownload.DownLoad(url, localfile, OnDownLoadCompleted);
        }

        void OnDownLoadCompleted(string file) {
            downloadFiles.Add(file);
            Destroy(mDownload);
            mDownload = null;
        }
 * 在对比后需要更新的资源文件，for循环中添加两句代码即可：
 * BeginHttpDownLoad(willDownLoadUrl[i], willDownLoadDestination[i]);
 * while (!(IsDownOK(willDownLoadDestination[i]))) { yield return new WaitForEndOfFrame(); }
 * 创建标识：Lorry 2018/1/26
 **/
using UnityEngine;
using System.Collections;
using System.Threading;
using System.IO;
using System.Net;
using System;


/// <summary>
/// 通过http下载资源，主要是为了实现断点续传功能。
/// </summary>
public class HttpDownLoad : MonoBehaviour
{

    //下载进度
    public float progress { get; private set; }
    //涉及子线程要注意,Unity关闭的时候子线程不会关闭，所以要有一个标识
    private bool isStop;
    //子线程负责下载，否则会阻塞主线程，Unity界面会卡主
    private Thread thread;
    //表示下载是否完成
    public bool isDone { get; private set; }

    public string error { get; private set; }
    // Use this for initialization
    void Start()
    {
        progress = 0f;
        isStop = true;
        error = null;
    }

    // Update is called once per frame
    void Update()
    {
        if (!isStop && !isDone)
        {
            //string message = string.Format("下载进度:{0:F}%", progress * 100.0);
            AppFacade.Instance.SendMessageCommand(NotiConst.UPDATE_SPEED, string.Format("下载进度:{0:F}%", progress * 100.0));
        }
    }

    // 这个在behaviour被销毁时调用。
    void OnDestroy()
    {
        isStop = true;
    }

    /// <summary>
    /// 下载方法(断点续传)
    /// </summary>
    /// <param name="url">URL下载地址</param>
    /// <param name="localfile">本地保存文件名</param>
    /// <param name="callBack">Call back回调函数</param>
    public void DownLoad(string url, string localfile, Action<string> callBack)
    {
        isStop = false;
        //开启子线程下载,使用匿名方法
        thread = new Thread(delegate ()
        {
            try
            {
                //判断保存路径是否存在
                string path = Path.GetDirectoryName(localfile);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                //使用流操作文件
                FileStream fs = new FileStream(localfile, FileMode.OpenOrCreate, FileAccess.Write);
                //获取文件现在的长度
                long fileLength = fs.Length;
                //获取下载文件的总长度
                long totalLength = GetLength(url);

                //如果没下载完
                if (fileLength < totalLength)
                {
                    //断点续传核心，设置本地文件流的起始位置
                    fs.Seek(fileLength, SeekOrigin.Begin);

                    HttpWebRequest request = HttpWebRequest.Create(url) as HttpWebRequest;

                    //断点续传核心，设置远程访问文件流的起始位置
                    request.AddRange((int)fileLength);
                    Stream stream = request.GetResponse().GetResponseStream();

                    byte[] buffer = new byte[1024];
                    //使用流读取内容到buffer中
                    //注意方法返回值代表读取的实际长度,并不是buffer有多大，stream就会读进去多少
                    int length = stream.Read(buffer, 0, buffer.Length);
                    while (length > 0)
                    {
                        //如果Unity客户端关闭，停止下载
                        if (isStop)
                            break;
                        //将内容再写入本地文件中
                        fs.Write(buffer, 0, length);
                        //计算进度
                        fileLength += length;
                        progress = (float)fileLength / (float)totalLength;
                        UnityEngine.Debug.Log(progress);
                        //类似递归
                        length = stream.Read(buffer, 0, buffer.Length);
                    }
                    stream.Close();
                    stream.Dispose();

                }
                else
                {
                    progress = 1;
                }
                fs.Close();
                fs.Dispose();
                //如果下载完毕，执行回调
                if (progress == 1)
                {
                    isDone = true;
                    if (callBack != null) callBack(localfile);
                }
            }
            catch (Exception e)
            {
                Debug.LogError("出现异常：" + e.Message);
                error = e.Message;
                throw;
            }

        });
        //开启子线程
        thread.IsBackground = true;
        thread.Start();
    }

    /// <summary>
    /// 获取下载文件的大小
    /// </summary>
    /// <returns>The length.</returns>
    /// <param name="url">URL.</param>
    long GetLength(string url)
    {
        HttpWebRequest requet = HttpWebRequest.Create(url) as HttpWebRequest;
        requet.Method = "HEAD";
        HttpWebResponse response = requet.GetResponse() as HttpWebResponse;
        return response.ContentLength;
    }

    public void Close()
    {
        OnDestroy();
    }
}