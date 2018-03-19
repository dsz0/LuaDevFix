--======================================================================
--（c）copyright 2018 Indra All Rights Reserved
--======================================================================
-- filename: Main.lua
-- author: lxt  created: 2014/02/20
-- description: 游戏的入口，載入需要的文件和對象,這個lua文件沒有什麼可看的。
-- 所有接口都是通過C#調用過來，现在用main进行测试。
--=====================================
--_G.PLOOP_DEBUG_MODE = true
--require("PLoop.init")
--require "base/functions"
--require "common/define"
--
--require("framework.facade")
----require("framework.core.BaseUIMediator")
--require("ui.common.TipsMediator")
--require("framework.demo.InstanceMediator")
local Notif = require("common.notif_enum")
--require "common.global_enum"

--主入口函数。从这里开始lua逻辑
function Main()
    print("Main logic start")
    --gFacade = Facade.Instance()
    -- gFacade.RegisterUI(UICustomID.Test, CInstanceMediator)
    -- gFacade.RegisterUI(UICustomID.Tips, CTipsMediator)
    -- gFacade.SendMessage(Notif.OPEN_TEST)
    --gFacade.RemoveUI(UICustomID.Test)
    --CMediatorManager.RemoveMediator(UICustomID.Test)
    --gFacade.SendMessage(Notif.OPEN_TEST)
    --gFacade.DoCmd("NoCmd")
end

---现在主工程也没啥用处，专门作为测试代码存放好了。
function MainTestClose()
    --lxt("执行了MainTest()") --热加载代码，必须通过RemoveUI和RegisterUI来重新构建对应的逻辑和
    gFacade.RemoveUI(UICustomID.Test);
end

function MainTestOpen()
    --lxt("执行了MainTest()") --热加载代码，必须通过RemoveUI和RegisterUI来重新构建对应的逻辑和
    gFacade.RegisterUI(UICustomID.Test, CInstanceMediator);
    gFacade.SendMessage(Notif.OPEN_TEST)
end

