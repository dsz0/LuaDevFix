--[[
CREATED:     2017.06.05
PURPOSE:     运行时调试配制
AUTHOR:      QiuLei
--]]

--========================================================--
_ENV = Module     "System.PLoopDebug"    "1.0.0"
--========================================================--
namespace "System"

--调试阶段改为true，可以对参数类型等做检查。上线前改为false，可以保证运行效率
local DEBUG_MODE = _G.PLOOP_DEBUG_MODE or false

__AttributeUsage__{AttributeTarget = AttributeTargets.Method + AttributeTargets.Constructor, RunOnce = true }
__Sealed__()
class "__CheckType__" (function(_ENV)
    extend "IAttribute"

    property "Priorty" { Type = AttributePriorty, Default = AttributePriorty.Lower }
    property "SubLevel" { Type = Number, Default = -1000 }

    local _Loaded = setmetatable({}, {__mode="k"})

    function ApplyAttribute(self, target, targetType, owner, name)
        if DEBUG_MODE and targetType == System.AttributeTargets.Constructor then
            return function(self, ...)
                if not _Loaded[self] then
                    if getmetatable(self) ~= owner then
                        error(("'%s' failed to create object, please check the constructor ( spelling mistake ? or missing __DebugArguments__ ? ) "):format(tostring(getmetatable(self))), 4)
                    end
                    _Loaded[self] = true
                end

                return target(self, ...)
            end
        end
    end
end)

--用__DebugXXX__替代PLoop的__XXX__，可以控制是否检查相关属性
__AttributeUsage__{AttributeTarget = AttributeTargets.Method + AttributeTargets.Constructor, RunOnce = true }
__Sealed__()
class "__DebugArguments__" (function(_ENV)
    extend "IAttribute"

    property "Priorty" { Type = AttributePriorty, Default = AttributePriorty.Lower }
    property "SubLevel" { Type = Number, Default = 0}

    --PLoop禁止参数检查时，参数列表中，允许为nil的参数后面还有不允许为nil的参数。比如这个情况是不允许的__DebugArguments__{ Argument(UEPlayer, true), Number }
    --但实际项目里用的时候，这个限制并不合理，因此做如下修改：
    --允许中间Agument为nilable，实现方式为：先禁止nilable，PLoop检查通过之后，再允许
    --先记录下哪些自动改成了nilable，然后让PLoop重载检查通过，之后再让那些记录过nilable的重新生效
    function ApplyAttribute(self, target, targetType, owner, name)
        
        if not DEBUG_MODE then 
            return      
        end
        
        local hasSelf = nil
        local nonil     = self.NoNil
        local param     = self.Param
        
        --普通成员方法调用Super时，如果参数不对，就报错，不再自动调用父类的方法
        if targetType == System.AttributeTargets.Method then
            self.ArgsObj.DependOnSuper = false
        end
        
        return function(...)
            -- Check if not object method
            if hasSelf == nil then
                hasSelf = true
                if targetType == AttributeTargets.Method then
                    if Reflector.IsInterface(owner) and __Final__:IsInterfaceAttributeDefined(owner) then hasSelf = false end
                    if name == "__exist" or name == "__new" or __Static__:IsMethodAttributeDefined(owner, name) then hasSelf = false end
                end
            end

            local base = hasSelf and 1 or 0

            for k, v in pairs(nonil) do
                if select(k + base, ...) == nil then
                    if hasSelf then
                        error(("Usage: %s:%s(%s) - the arg [%s] can't be nil."):format(tostring(owner), name, param, k), 2)
                    else
                        error(("Usage: %s.%s(%s) - the arg [%s] can't be nil."):format(tostring(owner), name, param, k), 2)
                    end
                end
            end

            return target(...)
        end
    end

    function __DebugArguments__(self, init)
        
        --保证参数不能为空
        if init == nil then 
           return
        end
        
        if type(init) ~= "table" then
            error("__DebugArguments__{} params must be a table", 4)
        end
        
        local nonil = {}
        local isOpt = false
        local param = {}

        for i, v in ipairs(init) do
            -- Argument()创建的是一个raw table
            if getmetatable(v) ~= nil then
                if isOpt then
                    init[i] = Argument(v, true)
                    nonil[i]= true
                end
                table.insert(param, tostring(v))
            else
                if v.Nilable then
                    isOpt   = true
                elseif isOpt then
                    v.Nilable = true
                    nonil[i] = true
                end
                table.insert(param, tostring(v.Type))
            end
        end

        self.NoNil = nonil
        self.Param = table.concat(param, ", ")

        self.ArgsObj = ___DebugArguments___(init)
        
        if DEBUG_MODE then 
            __CheckType__()
        end
    end
end)


-- 内部用到的___DebugArguments___
__AttributeUsage__{AttributeTarget = AttributeTargets.Method + AttributeTargets.Constructor, RunOnce = true }
__Sealed__()
class "___DebugArguments___" (function(_ENV)
    inherit "__Arguments__"
    extend "IAttribute"

    function ApplyAttribute(self, target, targetType, owner, name)
        if DEBUG_MODE or targetType == System.AttributeTargets.Constructor then
            return Super.ApplyAttribute(self, target, targetType, owner, name)
        end
    end
end)

__AttributeUsage__{ RunOnce = true }
class "__DebugStatic__" (function(_ENV)
    extend "IAttribute"

    function __DebugStatic__(self, ...)
        -- if not DEBUG_MODE then 
        --     return       
        -- end
        return __Static__(...)
    end
end)

__AttributeUsage__{ RunOnce = true }
class "__DebugRequire__" (function(_ENV)
    extend "IAttribute"

    function __DebugRequire__(self, ...)
        -- if not DEBUG_MODE then 
        --     return       
        -- end
        return __Require__(...)
    end
end)

__AttributeUsage__{ RunOnce = true }
class "__DebugAbstract__" (function(_ENV)
    extend "IAttribute"

    function __DebugAbstract__(self, ...)
        -- if not DEBUG_MODE then 
        --     return       
        -- end
        return __Abstract__(...)
    end
end)

--在property前加上__DebugType__，可以控制property是否做类型检查
__AttributeUsage__{AttributeTarget = AttributeTargets.Property, RunOnce = true}
class "__DebugType__" (function(_ENV)
    extend "IAttribute"
    
    function ApplyAttribute(self, target, targetType, owner, name)  
        
        if DEBUG_MODE then 
            return       
        end  
              
        for k in pairs(target) do
            if k == "Type" then
                target[k] = nil
            end
        end
    end

end)

__AttributeUsage__{ RunOnce = true }
class "__Coroutine__" (function(_ENV)
    extend "IAttribute"

    function __Coroutine__(self)
        return System.Threading.__Thread__()
    end
end)