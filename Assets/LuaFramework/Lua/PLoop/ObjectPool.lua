--[[
CREATED:     2018.01.23
PURPOSE:     PLoop的class或普通table的对象池(修改自PLoop提供的Recyle)
AUTHOR:      QiuLei
--]]

--========================================================--
_ENV = Module     "System.ObjectPool"                   ""
--========================================================--

namespace "System"

local DEBUG_MODE = _G.PLOOP_DEBUG_MODE or false

class "ObjectPool" (function(_ENV)

    local function parseArgs(self)
        if not self.Arguments then return end

        local index = (self.Index or 0) + 1
        self.Index = index

        self.__NowArgs = self.__NowArgs or {}

        for i, arg in ipairs(self.Arguments) do
            if type(arg) == "string" and arg:find("%%d") then
                arg = arg:format(index)
            end

            self.__NowArgs[i] = arg
        end

        return unpack(self.__NowArgs)
    end

    ------------------------------------------------------
    -- Constructor
    ------------------------------------------------------

    __DebugArguments__{ Struct + Class, { IsList = true, Nilable = true } }
    function ObjectPool(self, cls, ...)
        if cls and (Reflector.IsClass(cls) or Reflector.IsStruct(cls)) then
            self.Type = cls
            self.Arguments = select('#', ...) > 0 and {...}
        end
    end

    __DebugArguments__{ }
    function ObjectPool(self) end    
    
    ------------------------------------------------------
    -- Method
    ------------------------------------------------------

    function _NewObject(self)
        if not self.Type then
            return {}
        else
            return self.Type(parseArgs(self))
        end
    end
    
    function ReleaseObjectToPool(self, obj)
        if obj then
            -- Won't check obj because using cache means want quick-using.
            if DEBUG_MODE == true then
                for i,v in ipairs(self) do
                    if v == obj then
                        error("ReleaseObjectToPool error, obj already exist : "..tostring(obj), 2)
                    end
                end
            end
            tinsert(self, obj)
        end
    end

    function GetObjectFromPool(self)
        local ret = tremove(self)

        if not ret then
            ret = self:_NewObject()
        end

        return ret
    end

end)