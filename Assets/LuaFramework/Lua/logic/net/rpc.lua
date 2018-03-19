--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: rpc.lua
-- Author: Lorry  created: 2018/3/5  20:01
--[[Description: RPC（Remote Procedure Call）—远程过程调用，它是一种通过网络从远程计算机程序上请求服务，
而不需要了解底层网络技术的协议。RPC协议假定某些传输协议已经存在，如TCP或UDP为通信程序之间携带信息数据。
协议中type定义：
0:int, 1:string, 2:struct, 3:double, 6:int8, 7:int16
4:float 5:byte根本用不着
这里的代码主要用来分析rpc_lua_table，本来table中分["class_cfg"] 和 ["function_cfg"]两个部分才能存储数据结构和处理函数。
现在引入方便的ide之后，class定义数据结构很方便，有成员提示，配置就不用搞得那么复杂。
暂时只记录接收服务器协议的函数名。请求服务器函数名，主要是为了check对应的上行请求协议vo。
--=====================================================================]]

local kPtoFilePath = "common/net_cmd/rpc_lua_table"

local safe_dofile = function(path)
    local func = loadfile(path)

    if type(func) ~= "function" then
        log("Error", "dofile failed:", path)
        return
    end
    return func()
end


---@class CRpc 主要用于解析rpc_lua_table,pid对应的处理函数
---@field _rpc_data table @服务器与客户端通信使用的函数表，需要的话可包括参数表。
CRpc = {}
CRpc.__index = CRpc

---new 构造函数，习惯性写为new() EmmyLua会感应。
function CRpc.new(protocolMgr)
    local this = {};    --初始化this，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(this, CRpc);  --将this的元表设定为Class
    this._protocolMgr = protocolMgr
    this._rpc_data = nil

    this._client_protocols = {}      --下行协议列表
    this._server_protocols = {}     --上行协议列表
    this:LoadConfig()
    return this                           --返回自身
end

---重新生成协议
---@return void
function CRpc.LoadConfig(self, str)
    if str ~= nil then
        local truck = loadstring(str)
        if type(truck) == "function" then
            self._rpc_data = truck()
        else
            print("update rpc error!", debug.traceback())
        end
    else
        self._rpc_data = safe_dofile(kPtoFilePath)
    end
    self:ParseStruct()				--解析结构信息
    self:ParseProtocol()			--解析协议信息
    --self:GenServerProxy() 本来需要lua根据配置生成上传函数，同样交给预生成代码。
end

---GetPtoMd5 暂时只是伪代码，因为我们现在有一个打包的过程。
---如果动态更新lua协议，可能要进行修改。
---可以先做每次连接服务器都更新协议，出了问题再说。
---@param self CRpc
---@param pto table
function CRpc.GetPtoMd5(self)
---    local ptoPath = Util.LuaPath(kPtoFilePath..".lua")
---    local content = Util.ReadAllTextFromFile(ptoPath);
---    local md5 = Util.HashToMD5Hex(content);
    return md5
end

---UpdatePto 重新生成协议。
---@param self CRpc
function CRpc.UpdatePto(self,  pto)
    self:LoadConfig(pto)
end

---@param self CRpc
CRpc.ParseStruct = function(self)
    self._struct = self._rpc_data.class_cfg
end

---ParseProtocol解析客户端协议和服务器协议。
---@param self CRpc
function CRpc.ParseProtocol(self)
    self._client_protocols = {}
    self._server_protocols = {}
    for k, v in pairs(self._rpc_data) do
        ---@class req_func_info
        local req_func_info =
        {
            id = tonumber(k),
            name = v.req_func,
            args = v.req_args,
        }
        self._server_protocols[req_func_info.id] = req_func_info

        local resp_func_info =
        {
            id = tonumber(k),
            name = v.resp_func,
            args = v.resp_args,
        }
        self._client_protocols[resp_func_info.id] = resp_func_info

        networkMgr:AddProtocol(tonumber(resp_func_info.id))
    end

    local BASE_NET_EVENT =
    {
        [101] = "OnConnect",
        [102] = "OnException",
        [103] = "OnDisconnect",
    }

    for i = 101, 103 do
        local func_info =
        {
            id  = tonumber(i),
            name = BASE_NET_EVENT[i],
            args = {},
        }
        self._client_protocols[func_info.id] = func_info
    end
end

---OnPacket 接收服务器发过来的二进制数据包
---@param self CRpc
---@param pid number
---@param data LuaFramework.ByteBuffer
function CRpc.OnPacket(self, pid, buffer)
  --local pid = key
  --local testId = data:ReadInt(); --已经处理过，这里无需验证
  local func_info = self._client_protocols[pid]
  if func_info == nil then
		print("receive unknown packet:", pid)
		return
	end
  local func_name = func_info.name
  --如果这里需要进行协议解包，实现对应函数，参数分解调用也可以在此处理
  --现在有了emmylua做代码提示，所以这里用不着分解args
  xpcall(
    function()
      self._protocolMgr:receiveRpc(func_name, buffer)
    end,

    function(e)
      print("---- call stub func failed["..func_name.."]!------\n"..e..debug.traceback())
    end
  )
end

---OnSendVO 检测输出table数据类，转换为二进制数据发给服务器
---@param self CRpc
---@param pid number
---@param vo any
function CRpc.OnSendVO(self, vo)
    local pid = vo.pid
    if pid == nil then
        error("Send Wrong protocol :" .. debug.traceback())
    end
    local func_info = self._server_protocols[pid]
    --这里考虑再做一次输入vo的类型检验
    if func_info == nil then
        print("Send unknown protocol, Pid:", pid)
		return
	end
    lxt("Send Protocol:[" .. pid .."]:" .. func_info.name)
  --local func_name = func_info.name
  --xpcall(
  --  function()
  --    self._protocolMgr:askRpc(func_name, vo)
  --  end,
  --
  --  function(e)
  --    print("---- call stub func failed["..func_name.."]!------\n"..e..debug.traceback())
  --  end
  --)
end
