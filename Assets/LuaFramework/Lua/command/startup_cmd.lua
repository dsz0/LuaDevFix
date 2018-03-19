--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- filename: startup_cmd.lua
-- author: lorry  created: 2018/02/23
-- Description: 启动项，为符合PureMVC的启动习惯，所以写一个这样的Commond
--======================================================================
--[[首先注册所有的Command,  然后注册Mediator,
本来考虑由Mediator的构造函数注册，并持有对应的Proxy，但是如果写在startup_cmd中会更加清晰。特别是多个模块都要用的数据。
如果被某些人写到了Mediator中，就会给其他模块编写者带来不必要的麻烦。一次性看到所有数据的注册也不错。
生成全局管理器这个步骤可以放在start.lua,或游戏主体game.lua（现在暂时没有),或startup_cmd中(PureMVC标准方式)。
至于Value Object和配置，考虑通过excel或CSV文件自动生成lua代码。
--]]
---@class CommandTable
local _M = CommandTable or {}
CommandTable = _M;

---枚举及全局定义引入
---@type Notif
local Notif = require("common.notif_enum")
---@type proxy_enum
local proxy_enum = require("common.proxy_enum")

require "Common/global_enum"
---Proxy引入
require("ui.login.LoginProxy")
---Command引入
require("ui.test.test_cmd")

-----Mediator引入
require("framework.demo.InstanceMediator")
require("ui.common.TipsMediator")
--require "ui/login/login_mediator"

function _M.StartUpCmd()
    --lxt("StartUpCmd------>>")
    --按照PureMVC这里要注册所有的管理类 但管理类在game.lua中已注册，这里直接使用。
    --gCtrl = CCtrlManager.new()
    --gGame = CGame.new()
    --gGame:ChangeScene("login","loginScene")
    --gGame:ChangeScene("game", "gameScene")
    --注册所需Proxy
    gFacade.RegisterProxy(CLoginProxy(proxy_enum.LOGIN))
    --注册所需Command
    gFacade.RegisterCommand(Notif.version_return, CommandTable.test_cmd)
    --注册所有的Mediator，这些Mediator由mediator_manager持有。
    gFacade.RegisterUI(UICustomID.Test, CInstanceMediator)
    gFacade.RegisterUI(UICustomID.Tips, CTipsMediator)
    --游戏逻辑开始
    gFacade.SendMessage(Notif.UPDATE_MESSAGE, "Hello World!");
    --gFacade.SendMessage(Notif.OPEN_TEST)
    gFacade.SendMessage(Notif.OPEN_TIPS,"Test")
    --coroutine.start(test_coroutine);
end

--测试协同,
-- TODO:用来进行lua协议下载和最新配置的更新，当然是否更新也可以在此配置--
function test_coroutine()
    print("1111");
    coroutine.wait(2);
    print("2222");
    local www = WWW("https://dsz0.com/and/server_version.txt");
    coroutine.www(www);
    gFacade.SendMessage(Notif.UPDATE_PROGRESS, 10);
    gFacade.SendMessage(Notif.UPDATE_MESSAGE, www.text);
end

return _M.StartUpCmd
