--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str)
    Util.LogError(str);
end

--警告日志--
function logWarn(str)
    Util.LogWarning(str);
end

--查找对象--
function find(str)
    return GameObject.Find(str);
end

function destroy(obj)
    GameObject.Destroy(obj);
end

function newObject(prefab)
    return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
    PanelManager:CreatePanel(name);
end

function child(str)
    return transform:FindChild(str);
end

function subGet(childNode, typeName)
    return child(childNode):GetComponent(typeName);
end

function findPanel(str)
    local obj = find(str);
    if obj == nil then
        error(str .. " is null");
        return nil;
    end
    return obj:GetComponent("BaseLua");
end

--[[处理多国语言，记得在所有文字外加上这个函数]]
function TEXT(text, ...)
    return text
    --[[
      if id_string then
          return id_string[text] or text
      else
          return text
      end
    ]]
end

---tracebackEx 显示栈上所有变量
function debug.tracebackEx()
    local ret = ""
    local level = 2
    ret = ret .. "stack traceback:\n"
    while true do
        --get stack info
        local info = debug.getinfo(level, "Sln")
        if not info then
            break
        end
        if info.what == "C" then
            -- C function
            ret = ret .. tostring(level) .. "\tC function\n"
        else
            -- Lua function
            ret = ret .. string.format("\t[%s]:%d in function `%s`\n", info.short_src, info.currentline, info.name or "")
        end
        --get local vars
        local i = 1
        while true do
            local name, value = debug.getlocal(level, i)
            if not name then
                break
            end
            ret = ret .. "\t\t" .. name .. " =\t" .. tostringEx(value, 3) .. "\n"
            i = i + 1
        end
        level = level + 1
    end
    return ret
end

---tostringEx
function tostringEx(v, len)
    if len == nil then
        len = 0
    end
    local pre = string.rep('\t', len)
    local ret = ""
    if type(v) == "table" then
        if len > 5 then
            return "\t{ ... }"
        end
        local t = ""
        for k, v1 in pairs(v) do
            t = t .. "\n\t" .. pre .. tostring(k) .. ":"
            t = t .. tostringEx(v1, len + 1)
        end
        if t == "" then
            ret = ret .. pre .. "{ }\t(" .. tostring(v) .. ")"
        else
            if len > 0 then
                ret = ret .. "\t(" .. tostring(v) .. ")\n"
            end
            ret = ret .. pre .. "{" .. t .. "\n" .. pre .. "}"
        end
    else
        ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"
    end
    return ret
end