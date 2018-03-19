--======================================================================
--（c）copyright 2018 All Rights Reserved
--======================================================================
-- Filename: base_cmd.lua
-- Author: lxt  created: 2018/02/22
--[[ Description: 因为lua本身语言特性，cmd类不用那么复杂，根本没有必要用类。
函数全部放在普通table下即可，一个Mediator操作本身持有的view和proxy是不调用command的。
但是如果要操作其他Mediator，就需要通过command了。好好写吧。
--==================================================================]]
--用本地_M代替Table名，当需要重命名时，只需做两处改动，
--定义时一定要local _M = StandardTable or {}，如果重新加载table，之前的table不会被重定义
--所以要在原有的table基础上做修改，而不是重新创建一个新的table
local _M = CommandTable or {}
CommandTable = _M;

_M.BaseCmd = function(notification)
  print("***Not Implement Commond*** Function execute:", notification)
end
