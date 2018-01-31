
/**
 * 文件名称：Protocal.cs
 * 主要是为了用在大框架下
 * 创建标识：Lorry 2018/1/31
 */
namespace LuaFramework {
    /// <summary>
    /// 定义Lua框架使用的网络协议，到时候考虑做成代理类。
    /// </summary>
    public class LuaProtocal {
        ///BUILD TABLE
        public const int Connect = 101;     //连接服务器
        public const int Exception = 102;     //异常掉线
        public const int Disconnect = 103;     //正常断线   
    }
}