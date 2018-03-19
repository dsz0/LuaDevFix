using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using LuaFramework;
using LuaInterface;
using System.Text;
using System.Linq;

public enum RazDisType {
    Exception,
    Disconnect,
}

public class RazSocketClient {
    private TcpClient client = null;
    private NetworkStream outStream = null;
    private MemoryStream memStream;
    private BinaryReader reader;

    private const int MAX_READ = 8192;
    private byte[] byteBuffer = new byte[MAX_READ];
    public static bool loggedIn = false;

    // Use this for initialization
    public RazSocketClient() {
    }

    /// <summary>
    /// 注册代理
    /// </summary>
    public void OnRegister() {
        memStream = new MemoryStream();
        reader = new BinaryReader(memStream);
    }

    /// <summary>
    /// 移除代理
    /// </summary>
    public void OnRemove() {
        this.Close();
        reader.Close();
        memStream.Close();
    }

    /// <summary>
    /// 连接服务器
    /// </summary>
    void ConnectServer(string host, int port) {
        client = null;
        try {
            IPAddress[] address = Dns.GetHostAddresses(host);
            if (address.Length == 0) {
                Debug.LogError("host invalid");
                return;
            }
            if (address[0].AddressFamily == AddressFamily.InterNetworkV6) {
                client = new TcpClient(AddressFamily.InterNetworkV6);
            }
            else {
                client = new TcpClient(AddressFamily.InterNetwork);
            }
            client.SendTimeout = 1000;
            client.ReceiveTimeout = 1000;
            client.NoDelay = true;
            client.BeginConnect(host, port, new AsyncCallback(OnConnect), null);
        } catch (Exception e) {
            Close(); Debug.LogError(e.Message);
        }
    }

    /// <summary>
    /// 连接上服务器
    /// </summary>
    void OnConnect(IAsyncResult asr) {
        outStream = client.GetStream();
        client.GetStream().BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
        RazNetworkManager.AddEvent(LuaProtocal.Connect, new RazByteBuffer());
    }

    /// <summary>
    /// 写数据
    /// </summary>
    void WriteMessage(byte[] message) {
        MemoryStream ms = null;
        using (ms = new MemoryStream()) {
           ms.Position = 0;
           BinaryWriter writer = new BinaryWriter(ms);
           ushort msglen = (ushort)message.Length;
           // writer.Write(msglen);
           writer.Write(message);
           writer.Flush();
           if (client != null && client.Connected) {
               //NetworkStream stream = client.GetStream();
               byte[] payload = ms.ToArray();
               outStream.BeginWrite(payload, 0, payload.Length, new AsyncCallback(OnWrite), null);
           } else {
               Debug.LogError("client.connected----->>false");
           }
        }
    }

    /// <summary>
    /// 读取消息
    /// </summary>
    void OnRead(IAsyncResult asr) {
        int bytesRead = 0;
        try {
            lock (client.GetStream()) {         //读取字节流到缓冲区
                bytesRead = client.GetStream().EndRead(asr);
            }
            if (bytesRead < 1) {                //包尺寸有问题，断线处理
                OnDisconnected(RazDisType.Disconnect, "bytesRead < 1");
                return;
            }
            OnReceive(byteBuffer, bytesRead);   //分析数据包内容，抛给逻辑层
            lock (client.GetStream()) {         //分析完，再次监听服务器发过来的新消息
                Array.Clear(byteBuffer, 0, byteBuffer.Length);   //清空数组
                client.GetStream().BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
            }
        } catch (Exception ex) {
            //PrintBytes();
            OnDisconnected(RazDisType.Exception, ex.Message);
        }
    }

    /// <summary>
    /// 丢失链接
    /// </summary>
    void OnDisconnected(RazDisType dis, string msg) {
        Close();   //关掉客户端链接
        int protocal = dis == RazDisType.Exception ?
        LuaProtocal.Exception : LuaProtocal.Disconnect;

        RazByteBuffer buffer = new RazByteBuffer();
        buffer.WriteShort((ushort)protocal);
        RazNetworkManager.AddEvent(protocal, buffer);
        Debug.LogError("Connection was closed by the server:>" + msg + " Distype:>" + dis);
    }

    /// <summary>
    /// 打印字节
    /// </summary>
    /// <param name="bytes"></param>
    void PrintBytes() {
        string returnStr = string.Empty;
        for (int i = 0; i < byteBuffer.Length; i++) {
            returnStr += byteBuffer[i].ToString("X2");
        }
        Debug.LogError(returnStr);
    }

    /// <summary>
    /// 向链接写入数据流
    /// </summary>
    void OnWrite(IAsyncResult r) {
        try {
            outStream.EndWrite(r);
        } catch (Exception ex) {
            Debug.LogError("OnWrite--->>>" + ex.Message);
        }
    }

    /// <summary>
    /// 接收到消息
    /// </summary>
    void OnReceive(byte[] bytes, int length) {
        int IntSize = 4;
        memStream.Seek(0, SeekOrigin.End);
        memStream.Write(bytes, 0, length);
        //Reset to beginning
        memStream.Seek(0, SeekOrigin.Begin);

        while (RemainingBytes() > IntSize) {
            
            int messageLen = reader.ReadInt32();
            messageLen = RazConverter.GetBigEndian_Int32(messageLen) & 0xffffff;

            if (0 == messageLen)
            {
                memStream.Position = memStream.Position + RemainingBytes();
            }

            // Debug.LogWarning("粘包处理查看log:RemainingBytes():" + RemainingBytes() + ", messageLen:" + messageLen);

            if (messageLen > 0 && RemainingBytes() + IntSize >= messageLen) {
                MemoryStream ms = new MemoryStream();
                BinaryWriter writer = new BinaryWriter(ms);
                writer.Write(reader.ReadBytes(messageLen - IntSize));
                ms.Seek(0, SeekOrigin.Begin);
                OnReceivedMessage(messageLen, ms);
            } else {
                //Back up the position four bytes
                memStream.Position = memStream.Position - IntSize;
                break;
            }
        }
        //Create a new stream with any leftover bytes
        byte[] leftover = reader.ReadBytes((int)RemainingBytes());
        memStream.SetLength(0);     //Clear
        memStream.Write(leftover, 0, leftover.Length);
    }

    /// <summary>
    /// 剩余的字节
    /// </summary>
    private long RemainingBytes() {
        return memStream.Length - memStream.Position;
    }

    /// <summary>
    /// 接收到消息
    /// </summary>
    /// <param name="ms"></param>
    void OnReceivedMessage(int size, MemoryStream ms)
    {
        BinaryReader r = new BinaryReader(ms);
        byte[] message = r.ReadBytes((int)(ms.Length));
        RazByteBuffer buffer = new RazByteBuffer(message);
        int pid = RazConverter.GetBigEndian_Int32(buffer.ReadInt());
        int ctxId = RazConverter.GetBigEndian_Int32(buffer.ReadInt());
        buffer.SetSize(size);
        buffer.SetPid(pid);
        buffer.SetCtxId(ctxId);
        RazNetworkManager.AddEvent(pid, buffer);
    }


    /// <summary>
    /// 会话发送
    /// </summary>
    void RazSessionSend(byte[] b)
    {
        b[0] = (byte)((~b[3]) ^ (b[2]) ^ (b[1]));//协议头特殊处理
        WriteMessage(b);
    }

    /// <summary>
    /// 关闭链接
    /// </summary>
    public void Close() {
        if (client != null) {
            if (client.Connected) client.Close();
            client = null;
        }
        loggedIn = false;
    }

    /// <summary>
    /// 发送连接请求
    /// </summary>
    public void SendConnect() {
        ConnectServer(AppConst.SocketAddress, AppConst.SocketPort);
    }

    /// <summary>
    /// 发送消息
    /// </summary>
    public void SendMessage(RazByteBuffer buffer)
    {
        RazSessionSend(buffer.ToBytes());
        buffer.Close();
    }

    
}
