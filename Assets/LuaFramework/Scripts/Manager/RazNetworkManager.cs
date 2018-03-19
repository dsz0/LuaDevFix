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
        /// ִ��Lua����
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
        /// ����Command�����ﲻ����ķ���˭��
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
        /// ������������
        /// </summary>
        public void SendConnect() {
            RazSocketClient.SendConnect();
        }

        /// <summary>
        /// ����SOCKET��Ϣ
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
        /// ��������
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
        * ע��:  �˺����������̵߳���(luaMgr.CallLuaFunction)
        * ����ֵ��ʾ:lua�Ƿ�����ȫ�����Э��  
        * ����false,���������c#�����Э��.  
        * ����true,��ʾ���ٽ���c#�����Э��.  
        * �ھ�����Ŀ�д˴��ķ���ֵ��lua����.  
        */
        /// </summary>
        static internal bool handleMsg(int msgType, byte[] buff, int packetSize, int offset)
        {
            //֪ͨlua���д���
            if (IsLuaProtocol(msgType))
            {
                int headSize = 12;
                byte[] message = new byte[packetSize];
                for (int i = 0; i < packetSize - headSize; i++)
                {
                    message[i] = buff[headSize + offset + i];
                }
                //�첽֪ͨ��socketCommand�ٵ���lua����
                RazByteBuffer data = new RazByteBuffer(message);
                GetLuaManager().CallLuaFunction<int, RazByteBuffer>("Network.OnSocket", msgType, data);
                return true;
            }
            return false;
        }
    }
}