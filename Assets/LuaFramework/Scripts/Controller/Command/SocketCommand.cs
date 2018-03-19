using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaFramework;

public class SocketCommand : ControllerCommand {

    static LuaManager luaMgr = null;
    public override void Execute(IMessage message) {
        object data = message.Body;
        if (data == null) return;

        if(luaMgr == null)
                luaMgr = AppFacade.Instance.GetManager<LuaManager>(ManagerName.Lua);

        if (data is KeyValuePair<int, ByteBuffer>)
        {
            KeyValuePair<int, ByteBuffer> buffer = (KeyValuePair<int, ByteBuffer>)data;
            luaMgr.CallLuaFunction<int, ByteBuffer>("Network.OnSocket", buffer.Key, buffer.Value);
            //switch (buffer.Key) {
            //    default: Util.CallMethod("Network", "OnSocket", buffer.Key, buffer.Value); break;
            //}
        }
        else if (data is KeyValuePair<int, RazByteBuffer>)
        {
            KeyValuePair<int, RazByteBuffer> buffer = (KeyValuePair<int, RazByteBuffer>)data;
            luaMgr.CallLuaFunction<int, RazByteBuffer>("Network.OnSocket", buffer.Key, buffer.Value);
        }
        
	}
}
