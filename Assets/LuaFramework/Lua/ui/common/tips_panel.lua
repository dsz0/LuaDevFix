--此文件由AutoGameObjectToLua.cs中的Editor类自动生成，请勿手动修改。
--函数全部由C# 中的LuaBehaviour在运行时自动调用，其实也是单体类。
-- Filename: tips_panel.lua
-- Author: Lxt  created: 2018/2/28

local transform;
local gameObject;

---@class TipsPanel
---@field  public btnClose UnityEngine.GameObject @按钮GO
---@field  public txtLabel UnityEngine.GameObject @文本GO
TipsPanel = {};
local this = TipsPanel;

--启动事件--
function TipsPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    --logWarn("Awake lua--->>" .. gameObject.name);
end

function TipsPanel.Start()

end


--初始化面板--
function TipsPanel.InitPanel()
    this.btnClose = transform:FindChild("Button").gameObject;
    this.txtLabel = transform:FindChild("Label").gameObject;

end

--单击事件--
function TipsPanel.OnDestroy()
    logWarn("Tips Panel.OnDestroy---->>>");
end
