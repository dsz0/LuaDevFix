using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

namespace LuaFramework {
    public class RazNetworkManager : Manager {
        private RazSocketClient socket;
        static readonly object m_lockObject = new object();
        static Queue<KeyValuePair<int, RazByteBuffer>> mEvents = new Queue<KeyValuePair<int, RazByteBuffer>>();
        static LuaManager luaMgr;

        RazSocketClient RazSocketClient {
            get { 
                if (socket == null)
                    socket = new RazSocketClient();
                return socket;                    
            }
        }

        void Awake() {
            Init();
        }

        void Init() {
            RazSocketClient.OnRegister();
        }

        public void OnInit() {
            CallMethod("Start");
        }

        public void Unload() {
            CallMethod("Unload");
        }

        public static LuaManager GetLuaManager()
        {
            if (luaMgr == null)
                luaMgr = AppFacade.Instance.GetManager<LuaManager>(ManagerName.Lua);

            return luaMgr;
        }

        /// <summary>
        /// 执行Lua方法
        /// </summary>
        public object[] CallMethod(string func, params object[] args) {
            return Util.CallMethod("Network", func, args);
        }

        ///------------------------------------------------------------------------------------
        public static void AddEvent(int _event, RazByteBuffer data) {
            lock (m_lockObject) {
                mEvents.Enqueue(new KeyValuePair<int, RazByteBuffer>(_event, data));
            }
        }

        /// <summary>
        /// 交给Command，这里不想关心发给谁。
        /// </summary>
        void Update() {
            if (mEvents.Count > 0) {
                while (mEvents.Count > 0) {
                    KeyValuePair<int, RazByteBuffer> _event = mEvents.Dequeue();
                    facade.SendMessageCommand(NotiConst.DISPATCH_MESSAGE, _event);
                }
            }
        }

        /// <summary>
        /// 发送链接请求
        /// </summary>
        public void SendConnect() {
            RazSocketClient.SendConnect();
        }

        /// <summary>
        /// 发送SOCKET消息
        /// </summary>
        public void SendMessage(RazByteBuffer buffer, string socket_type) {

            if(socket_type == "local")
            {
                LocalSocketManager.Instance.sendMsg(buffer.ToBytes());
            }
            else if (socket_type == "login")
            {
                LoginSocketManager.Instance.sendMsg(buffer.ToBytes());
            }
            else if (socket_type == "chat")
            {
                ChatSocketManager.Instance.sendMsg(buffer.ToBytes());
            }
            else if (socket_type == "game")
            {
                GameSocketManager.Instance.sendMsg(buffer.ToBytes());
            }
            else if (socket_type == "pvp")
            {
                PVPSocketManager.Instance.sendMsg(buffer.ToBytes());
            }
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy() {
            RazSocketClient.OnRemove();
            Debug.Log("~RazNetworkManager was destroy");
        }

        static List<int> protocolList;
        public void AddProtocol(int pid)
        {
            if (protocolList == null)
            {
                protocolList = new List<int>();
            }
            protocolList.Add(pid);
        }

        static private bool IsLuaProtocol(int pid)
        {
            if (protocolList == null)
            {
                protocolList = new List<int>();
            }
            return protocolList.Contains(pid);
        }

        
        /// <summary>
        /**  
        * 注意:  此函数需在主线程调用(luaMgr.CallLuaFunction)
        * 返回值表示:lua是否能完全处理该协议  
        * 返回false,会继续交给c#处理此协议.  
        * 返回true,表示不再交给c#处理此协议.  
        * 在具体项目中此处的返回值由lua决定.  
        */
        /// </summary>
        static internal bool handleMsg(int msgType, byte[] buff, int packetSize, int offset)
        {
            //通知lua进行处理
            if (IsLuaProtocol(msgType))
            {
                int headSize = 12;
                byte[] message = new byte[packetSize];
                for (int i = 0; i < packetSize - headSize; i++)
                {
                    message[i] = buff[headSize + offset + i];
                }
                //异步通知到socketCommand再调用lua方法
                RazByteBuffer data = new RazByteBuffer(message);
                GetLuaManager().CallLuaFunction<int, RazByteBuffer>("Network.OnSocket", msgType, data);
                return true;
            }
            return false;
        }
    }
}