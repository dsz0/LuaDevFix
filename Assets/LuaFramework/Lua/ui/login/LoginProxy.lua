--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: LoginProxy.lua
-- Author: Lorry  created: 2018/3/8  15:17
--[[Description: 登录数据的代理类
--=====================================================================]]

require("framework.core.base_proxy")
---@class   CLoginProxy:CBaseProxy @数据代理类
---@field _version_return resp_version_return_vo @服务器返回的版本数据
---@field _scene_load_cfg table<string, scene_load_info> @本地读取的，场景配置(xls文件生成)
class "CLoginProxy" (function(_ENV)
    inherit(CBaseProxy)
    ---CLoginProxy
    ---@param self CLoginProxy
    ---@param name string
    function CLoginProxy(self, name)
        Super(self, name);
        self._version_return = nil
        self._scene_load_cfg = nil
    end
end)

---@see CProxyManager #RegisterProxy
---@param self CLoginProxy
function CLoginProxy.OnRegister(self)
    --lxt("CLoginProxy.注册时读取所需配置")
    self._scene_load_cfg = require("model.cfg.scene_load")
end

---Destroy 在移除时调用此函数
---@see CProxyManager #RemoveProxy
---@param self CLoginProxy
function CLoginProxy.OnRemove(self)
end

--编写供protocol_xxx调用的,存储(更新)数据函数SetData_xxx_xxx--
---SetData_version_return
---@param vo resp_version_return_vo
function CLoginProxy.SetData_version_return(self, vo)
    --lxt("CLoginProxy.SetData_version_return");
    self._version_return = vo
end

--编写供Mediator和Command调用的方便的处理函数
---GetDesc
---@param self CLoginProxy
---@return string
function CLoginProxy.GetDesc(self)
    local vo = self._version_return
    local sceneInfo = self._scene_load_cfg[vo.version];

    if sceneInfo ~= nil then
        return sceneInfo.path
    end
    return vo.version .. " 取不到对应目录 " .. vo.encodeType
end

---GetBuildID
---@param self CLoginProxy
function CLoginProxy.GetBuildID(self)
    return self._version_return.buildID
end
