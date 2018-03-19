require "common/define"
require "base/functions"
--Event = require("base.events")

---@type fun(key:string):void @是一个函数用于打印table,云风大神提供
--local print_r = require "3rd/sproto/print_r"

require("logic.net.rpc")
local CProtocol = require "logic/net/protocol_base"

--Import各个模块的协议接口--BEGIN
require "common/net_cmd/protocol_login"

--require "common/net_cmd/protocol_test"

--Import各个模块的协议接口--END

---@class Network @管理所有的协议，同时负责更新协议
---@field _protocol CProtocol @所有下行协议的处理函数
---@field _rpc CRpc  @分析rpc_lua_table，处理协议调用，提供检测输出。
Network = {};
local this = Network;

---Start 初始化处理网络，不过协议应该可以在连上服务器之后再次更新
function Network.Start()
    --logWarn("Network.Start!!");
    this._protocol = CProtocol.new()
    this._rpc = CRpc.new(this)
end

--卸载网络监听--
function Network.Unload()
    logWarn('Unload Network...');
end

---OnSocket 解析并执行下行协议（将二进制流转换为vo)
---@param key number @协议号 pid (int)
---@param data LuaFramework.ByteBuffer @已经处理头部12个字节固定内容size,pid,ctxId
function Network.OnSocket(key, data)
    this._rpc:OnPacket(key, data)
end

---@param pid number @协议号 pid (int)
---@param vo any @解析vo为二进制流，发送到服务器
function Network.SendMessage(vo)
    this._rpc:OnSendVO(vo) --仅仅用于检测，可注释掉
    --print_r(vo)
    -- networkMgr:SendMessage(vo:toByteBuffer(),vo.socketType)
    networkMgr:SendMessage(vo:toByteBuffer(), vo.socket_type)
end


---askRpc 上行协议,只被CRpc调用，暂时废弃
---@private
--function Network.askRpc(self, upRpcName, ...)
--	local up_func = self._protocol[upRpcName]
--	if not up_func then
--		print("up rpc func not implemented:", upRpcName)
--		return
--	end
--	local buffer= up_func(...)
--    networkMgr:SendMessage(buffer)
--end

---receiveRpc 下行协议,只被CRpc调用
---@private
function Network.receiveRpc(self, downRpcName, buffer)
    downRpcArgs = downRpcArgs or {}
    local down_func = self._protocol[downRpcName]
    if not down_func then
        print("down rpc func not implemented:", downRpcName)
    else
        down_func(self._protocol, buffer)
    end
end

return Network
