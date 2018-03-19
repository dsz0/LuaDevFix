-- author: lorry  created: 2018/02/22
-- descrip: 暂时不用，主要用于全局消息通知，现在统一使用facade的函数。

local eventToFunctionTbl = {}

--注册事件
function RegTrigger(event_id, func)
	if type(func) ~= "function" then
		print("Event trigger set not a function, id : "..event_id)
		return
	end
	if not eventToFunctionTbl[event_id] then
		eventToFunctionTbl[event_id] = {}
	end
	table.insert(eventToFunctionTbl[event_id], func)
	return func
end

---UnRegTrigger
---@param event_id string | number @事件ID
---@param func fun(...):any @注册的
function UnRegTrigger(event_id, func)
	local event_to_function_tmp = eventToFunctionTbl[event_id]
	if event_to_function_tmp then
		local removeIndexs = {}
		if type(func) == "function" then
			for k,v in ipairs(event_to_function_tmp) do
				if v == func then
					table.insert(removeIndexs, k)
				end
			end
			for k,v in ipairs(removeIndexs) do
				table.remove(event_to_function_tmp, v)
			end
		else
			eventToFunctionTbl[event_id] = {}
		end
		return true
	end
	return false
end

function HasRegTrigger(event_id, func)
	local event_to_function_tmp = eventToFunctionTbl[event_id]
	if not event_to_function_tmp then return false end
	if type(func) == "function" then
		for k,v in ipairs(event_to_function_tmp) do
			if v == func then
				return true
			end
		end
	else
		return #event_to_function_tmp > 0
	end
	return false
end

function EventTrigger(event_id, ...)
	local event_to_function_tmp = eventToFunctionTbl[event_id]
	if not event_to_function_tmp then return end
	local has_func = false
	local func_return_value = nil --兼容之前的
	for k, v in ipairs(event_to_function_tmp) do
		has_func = true
		func_return_value = v(...)
	end
	if not has_func then
		print("Event trigger no such function id : "..event_id)
		return
	end
	return func_return_value
end
