require "Common/define"
require "Common/functions"

--require "View/ActivityDailyPanel"
require "Controller/ActivityDailyCtrl"
require "Logic/CtrlManager"

function InitViewPanels()
	for i = 1, #PanelNames do
		require ("View/"..tostring(PanelNames[i]))
	end
end

--主入口函数。从这里开始lua逻辑
function Main()
	print("logic start")
	--注册LuaView--
	InitViewPanels();
  logWarn('New Activity Daily 新每日活动成果上线！');
  logWarn("ActivityDailyCtrl.New--->>");
  CtrlManager.Init();
  local ctrl = CtrlManager.GetCtrl(CtrlNames.ActivityDaily);
  if ctrl ~= nil then
      ctrl:Awake();
  end
  log("恭喜成功更新！");
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end
