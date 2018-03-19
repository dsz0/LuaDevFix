--[[
Auth:Chiuan like Unity Brocast Event System in lua.
TODO:使用Event进行监听的函数中的assert无法正常报错，编码错误风险很大。
]]
--


local EventLib = require "base.eventlib"

local Event = {}
---@type EventLib[]
local events = {}

function Event.AddListener(event,handler)
	if not event or type(event) ~= "string" then
		error("event parameter in AddListener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in AddListener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect(handler)
end

function Event.Brocast(event,...)
	if not events[event] then
		lxt("Brocast [" .. event .. " ]has no event.")
	else
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if not events[event] then
		error("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler)
	end
end

return Event