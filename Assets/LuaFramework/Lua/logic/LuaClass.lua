--Author : Administrator
--Date   : 2014/11/25
-- TODO:这是luaframework推荐的类写法，但是比较简单，可以看下进行参考，
-- 我们可能不用这种方式。而是按照每种对象的特点进行修改。请勿载入此文件 Lorry

---@class LuaClass
LuaClass = { x = 0, y = 0 }

--这句是重定义元表的索引，就是说有了这句，这个才是一个类。
LuaClass.__index = LuaClass

--构造函数，名字随便起，但new()在EmmyLua中有只能提示
function LuaClass:new(x, y)
    local self = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(self, LuaClass);  --将self的元表设定为Class
    self.x = x;
    self.y = y;
    return self;    --返回自身
end

--测试打印方法--
function LuaClass:test()
    logWarn("x:>" .. self.x .. " y:>" .. self.y);
end

--endregion
--云风提供的Lua OO方案
local _class = {}

function class(super)
    local class_type = {}
    class_type.ctor = false
    class_type.super = super
    class_type.new = function(...)
        local obj = {}
        do
            local create
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(obj, ...)
                end
            end

            create(class_type, ...)
        end
        setmetatable(obj, { __index = _class[class_type] })
        return obj
    end
    local vtbl = {}
    _class[class_type] = vtbl

    setmetatable(class_type, { __newindex = function(t, k, v)
        vtbl[k] = v
    end
    })

    if super then
        setmetatable(vtbl, { __index = function(t, k)
            local ret = _class[super][k]
            vtbl[k] = ret
            return ret
        end
        })
    end
    return class_type
end
------下面开始使用：

base_type=class()		-- 定义一个基类 base_type
function base_type:ctor(x)	-- 定义 base_type 的构造函数
    print("base_type ctor")
    self.x=x
end

function base_type:print_x()	-- 定义一个成员函数 base_type:print_x
    print(self.x)
end

function base_type:hello()	-- 定义另一个成员函数 base_type:hello
    print("hello base_type")
end

------以上是基本的 class 定义的语法，完全兼容 lua 的编程习惯。
------云风增加了一个叫做 ctor 的词，作为构造函数的名字。下面看看怎样继承：

test=class(base_type)	-- 定义一个类 test 继承于 base_type

function test:ctor()	-- 定义 test 的构造函数
    print("test ctor")
end

function test:hello()	-- 重载 base_type:hello 为 test:hello
    print("hello test")
end

------现在可以试一下了：
a=test.new(1)	-- 输出两行，base_type ctor 和 test ctor 。这个对象被正确的构造了。
a:print_x()	-- 输出 1 ，这个是基类 base_type 中的成员函数。
a:hello()	-- 输出 hello test ，这个函数被重载了。