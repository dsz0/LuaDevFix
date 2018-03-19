
--TODO:此文件已经废弃，待删除。要新写正式的 LoginMediator.lua
local CBaseMediator = Import("framework/core/base_mediator").CBaseMediator
local NotiConst = Import("Common/global_enum").ENUM_Noti

CLoginMediator = class(CBaseMediator)

--构造函数,初始化Proxy,绑定事件等
CLoginMediator.Init = function(self)
	self._prefabPath = "HotRes/Builds/ActivityDaily/ActivityDaily.prefab";
	self._view = nil; --CUILoginView:New(self._prefabPath)
	CBaseMediator.Init(self)
	--self:_RegisterNotifications();
	--这里需要保存一份this给 HandleNotification相关函数使用，因为事件处理的缘故。
	self._basePercent = 100;
	this = self;
end

--[[用于注册感兴趣的监听事件
--]]
CLoginMediator.NotificationInterests = function(self)
	return {
		NotiConst.UPDATE_MESSAGE,
		NotiConst.UPDATE_PROGRESS
	}
end


--事件处理
CLoginMediator.HandleNotification = function(event,...)
	if event== NotiConst.UPDATE_MESSAGE then
		this.HandleUpdateMessage(...);
	elseif event == NotiConst.UPDATE_PROGRESS	then
		this.HandleUpdateProgress(...);
	else
	 	logError("events.lua文件代码问题，不可能接收到"..event);
	end
end

CLoginMediator.HandleUpdateMessage = function(message)
	if(message ~= nil) then
		logWarn("UPDATE_MESSAGE-----:"..message)
	else
		logError("UPDATE_MESSAGE不能接受空消息！")
	end
end

CLoginMediator.HandleUpdateProgress = function(percent)
	local x = this._basePercent + percent;
	logWarn("UPDATE_PROGRESS-----:"..x)
end

--mediator销毁处理
CLoginMediator.Destory = function(self)
	--先调用父类的Destroy
	CBaseMediator.Destory(self)
end
