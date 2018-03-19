--======================================================================
--（c）copyright 2018 dsz0.com All Rights Reserved
--======================================================================
-- Filename: test_mediator.lua
-- Author: lxt  created: 2018/2/27
-- Description:专门用于配合test.lua进行类继承测试
--======================================================================

---@class MyClass
class "MyClass" (function(_ENV)
    -- Property Definition
    property "Name" { Type = System.String }
    -- Method Definition
    __DebugArguments__{ String }
    function Greet(self, name)
        print("Hello " .. name .. ", My name is " .. self.Name)
    end
    -- End the class's definition
end)

---@class CTestBase
---@field public _name string @测试使用
class "CTestBase"(function(_ENV)
    -- Method Definition
    __DebugArguments__{ String }
    ---CTestBase
    ---@param self CTestBase
    ---@param name string
    function CTestBase(self, name)
        self._name = name;
    end
    -- End the class's definition
end)

---@class CTestMediator :CTestBase
class "CTestMediator"(function(_ENV)
    inherit(CTestBase)
    -- 构造函数
    __DebugArguments__{ Number }
    ---@param id number
    function CTestMediator(self, id)
        print("Hello-> CTestMediator ctor ")
        self._name = id;
    end
    -- End the class's definition
end)

---@class CTest :CTestMediator
class "CTest"(function(_ENV)
    inherit(CTestMediator)
    -- 构造函数
    __DebugArguments__{ String }
    ---@param self CTest
    ---@param name string
    function CTest(self, name)
        print("Hello -> CTest ctor ")
        self._name = name;
    end
    -- End the class's definition
end)
