--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- filename: start.lua
-- author: lorry  created: 2018/02/20
-- Description: 游戏的入口，載入需要的文件和對象,這個lua文件沒有什麼可看的。
-- 所有接口都是通過C#調用過來，lua的框架接口是基於logic/game.lua
-- 本来的默认入口是Main.lua的main但那里现在基本用于测试。
--======================================================================
_G.PLOOP_DEBUG_MODE = true
require("PLoop.init")

--loadfile("base/io")()
--[[处理语言，相关配置用lua文件通过excel或CSV文件自动生成。
local lang = ""
local re_str = "logic/lang/id_string_"..lang
if IsFileExist(re_str..".lua") then
    loadfile(re_str)()
else
    id_string = nil
end
--]]
--local Event = require "base.events"

require "base/functions"
require "3rd/dkjson"
require "common/define"

require "framework/facade"
local Notif = require("common.notif_enum")

---@type Facade @全局外观包裹入口
gFacade = nil
---全局游戏，游戏主逻辑写在lua中的时候这个会非常有用，现在暂时不生成。
gGame = nil
---全局输入控制器，可以随时切换，不过现在的Input不在Lua中，暂时用不着添加。
--gControl = nil
GameManager = { }

GameManager.OnInitOK = function(type)
    --lxt("OnInitOK")
    UpdateBeat:Add(GameManager.Update)
    LateUpdateBeat:Add(GameManager.LateUpdate)
    FixedUpdateBeat:Add(GameManager.FixedUpdate)
    --开始构造
    gFacade = Facade.Instance();
    local cmd
    if type == MSceneTypeEnum.LOGIN then
        cmd = require "command.StartUpLoginCmd"
    elseif type == MSceneTypeEnum.CITY then
        cmd = require "command.StartUpMainCityCmd"
    elseif type == MSceneTypeEnum.SINGLE_FIGHT then
        cmd = require "command.StartUpFightCmd"
    else
      cmd = require "command/startup_cmd"
    --else
    --error("GameManager.OnInitOk Wrong--->>" .. type)
    end
    gFacade.RegisterCommand(Notif.START_UP, cmd);
    gFacade.DoCmd(Notif.START_UP);
    gFacade.RemoveCommand(Notif.START_UP);
end

-- 销毁--
GameManager.Destroy = function()
    gFacade.ClearUI()
end
--附着GO对象被销毁时调用。但因为各个对象同时销毁顺序问题。
GameManager.OnDestroy = function()
    logWarn('GameManager.OnDestroy--->>>');
end

GameManager.Update = function(deltaTime, unscaledDeltaTime)
    if gGame then
        gGame:Update()
        gControl:Update()
    end
end

GameManager.LateUpdate = function()
    if gGame then
        gGame:LateUpdate()
        gControl:LateUpdate()
    end
end

GameManager.FixedUpdate = function()
    --log(Time.timeSinceLevelLoad);
    if gGame then
        gGame:FixedUpdate()
    end
end
--場景切換通知
GameManager.OnSceneLoaded = function(type)
    collectgarbage("collect")
    lxt(type)
    GameManager.OnInitOK(type)
    if gGame then
        gGame:OnSceneLoaded()
    end
    Time.timeSinceLevelLoad = 0;
end
--[[放到Network.lua中處理。
GameManager.OnSocket = function(key, value)
    if gGame then
        gGame:OnSocket(key, value)
    end
end
]]
GameManager.OnApplicationQuit = function()
    if gGame then
        gGame:OnApplicationQuit()
    end
end

collectgarbage("setpause", 180)
collectgarbage("setstepmul", 300)
