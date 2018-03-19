---@class MSceneTypeEnum @记得与SceneDefine.cs中的定义保持一致。
MSceneTypeEnum = {
    NOT_AVAILABLE = -1;
    NEGATIVE = 0; --默认
    CITY = 1; --主城
    PUB = 2; --酒馆
    ARENA = 3; --竞技场
    SINGLE_FIGHT = 4; --单人副本
    TEAM_FIGHT = 5; --组队副本
    CHALLENGE_FIGHT = 6; --PK
    WorldMap_Trans = 7; --世界地图
    LOGIN = 11;
    LOADING = 12; --loading
    TASTE_FIGHT = 13; --体验战斗
    UNDER_CITY = 14; --//地下城
    DIABLO = 15; --		//秘境
    BOSS = 16; --//BOSS
    GUILD_MISSION = 17; --//公会任务
    ORACLE = 18; --//神谕
    INTRODUCTION = 19; --//序章
    SKILL_TEACHING = 20; --		//技能教学
    INTRODUCTION_CHOOSE_HERO = 21; --		//三选一
}

Util = LuaFramework.Util;
--AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;
RazByteBuffer = LuaFramework.RazByteBuffer;
RazConverter = LuaFramework.RazConverter;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
-- networkMgr = LuaHelper.GetNetManager();
networkMgr = LuaHelper.GetRazNetManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;

local print_r = require "3rd/sproto/print_r"
---lxt @[罗翔天]方便的个人输出与屏蔽，每个进行lua代码调试的人员都在这里添加一个自己的专用输出函数
---@param ... any
function lxt(...)
    local args = { select(1, ...) }
    table.insert(args, 1, "[Lxt >>>")
    local temp = debug.traceback("", 2)
    --string.gsub(temp,'\r','',1)
    temp = string.sub(temp, 2, -1)
    table.insert(args, temp)
    --print(unpack(arg)) --此方式可以输出nil,下面输出nil会出错，还需进一步修改。
    Util.LogWarning(table.concat(args, '#'))
end

function xrb(...)
    local args = { select(1, ...) }
    table.insert(args, 1, "[Xrb >>>")
    local temp = debug.traceback("", 2)
    temp = string.sub(temp, 2, -1)
    table.insert(args, temp)
    Util.LogWarning(table.concat(args, '#'))
end

function xrbPrint_r(tips, tab)
    local temp = {}
    table.insert(temp, "[Xrb] >>> ============= ")
    table.insert(temp, tips)
    table.insert(temp, " begin ===========")

    Util.LogWarning(table.concat(temp))
    print_r(tab)
    temp[3] = " end   ==========="
    Util.LogWarning(table.concat(temp))
end
