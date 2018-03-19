--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: rpc_lua_table.lua
-- Author: Lorry  created: 2018/3/5  20:58
--[[Description: 自动生成此lua,协议号pid对应的请求和返回函数。发送时要分socket,有四种,login，chat，game，pvp
原来还设计了函数参数的自动生成，但是EmmyLua提供了方便的提示及开发环境，用不着生成param提供可读和可编写特性。
TODO:这里重要的是下行接收函数resp_func,上行请求函数req_func只是用于check和信息提示。xxx_args暂时无用。
--=====================================================================]]

RPC_func_table = {
    ["19000"] = { --版本验证 version_return,预留协议
        ["module_name"] = "",
        ["socket_type"] = "",
        ["req_socket_size"] =  12 + 0,
        ["resp_socket_size"] =  12 + 0,
        ["req_func"] = "req_version_return", ["req_args"] = {},
        ["resp_func"] = "resp_version_return", ["resp_args"] = { { ["class_index"] = -1, ["type"] = 1, }, { ["class_index"] = -1, ["type"] = 1, }, { ["class_index"] = -1, ["type"] = 1, }, },
    },
    ["100"] = { --更新lua协议,预留协议
        ["module_name"] = "",
        ["socket_type"] = "",
        ["req_socket_size"] =  12 + 0,
        ["resp_socket_size"] =  "16 + num * 123",
        ["req_func"] = "req_update_pto", ["req_args"] = { { ["class_index"] = 0, ["type"] = 2, }, },
        ["resp_func"] = "resp_update_pto", ["resp_args"] = { { ["class_index"] = 0, ["type"] = 2, }, },
    },
    ["180003"] = { --游戏公告
        ["module_name"] = "",
        ["socket_type"] = "login",
        ["req_socket_size"] =  12,
        ["resp_socket_size"] =  4096,
        ["req_func"] = "req_public_msg",
        ["resp_func"] = "resp_public_msg",
        ["req_args"] = --此协议无请求参数
        {

        },
        ["resp_args"] = 
        { 
            {["key"]="newstitle",["type"]="UTF8String[80]",["msg"]="登录公告标题"},
            {["key"]="newspaper",["type"]="UTF8String[4000]",["msg"]="登录公告内容"},
            {["key"]="flag",["type"]="Signed32",["msg"]="1要显示公告0不用处理"},
        },
    },
    ["180002"] = { --服务器列表
        ["module_name"] = "",
        ["socket_type"] = "login",
        ["req_socket_size"] =  22,
        ["resp_socket_size"] =  "16 + num * 123",
        ["req_func"] = "req_server_list",
        ["resp_func"] = "resp_server_list",
        ["req_args"] = --请求参数描述
        {
            {["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark"},
        },
        ["resp_args"] = 
        { 
            {["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
            {
                ["key"]="ServerInfo", --填的是方括号前面的值,例子1:RequestStructData[] ~ RequestStructData, 例子2:FightDataKeyVal[] ~ FightDataKeyVal
                ["type"]="struct[$num]",-- $num代表取key为num的值,有依赖关系所以必须保证num在前面
                ["msg"]="结构列表",
                ["struct"] = --struct和struct[$num]需成对出现，如果不是结构体列表，只是结构体请用struct[1]表示
                {
                    -- 结构体里面的结构和req_args类似,这样可以解决嵌套列表的问题
                    {["key"]="zoneId",["type"]="Signed32",["msg"]="游戏区ID"},
                    {["key"]="playerLevel",["type"]="Signed32",["msg"]="角色等级若不为0，则表示此帐号在这个区有角色"},
                    {["key"]="name",["type"]="UTF8String[24]",["msg"]="游戏区名称"},
                    {["key"]="backupDomain",["type"]="UTF8String[40]",["msg"]="备用游戏PS服 ip:port"},
                    {["key"]="defaultDomain",["type"]="UTF8String[40]",["msg"]="默计游戏PS服 ip:port"},
                    {["key"]="status",["type"]="Bool",["msg"]="游戏区状态"},
                    {["key"]="newserver",["type"]="Bool",["msg"]="是否新服"},
                    {["key"]="recommed",["type"]="Bool",["msg"]="是否推荐服"},
                    {["key"]="zoneStatus",["type"]="Signed32",["msg"]="0正常1拥挤2爆满3维护"},
                    {["key"]="lastLogoutTime",["type"]="Signed32",["msg"]="上次下线时间, 0未登录过"},
                }
            },
        },

    },

    ["180008"] = { --新登录验证 (这里请填写协议号的中文名)
       ["module_name"] = "", --这个是协议号的模块名(会被用为前缀,请统一用英文):system,hero,shop,mail...(如果为null请用空字符串)
       ["socket_type"] = "login", --这个决定客户端用哪个socket,目前有四个:login,game,chat,pvp
       ["req_socket_size"] =  2310, --这个是协议请求长度,方便检查用
       ["resp_socket_size"] = 274, --这个是协议返回长度,方便检查用
       ["req_func"] = "req_login_check", --这个是协议请求用函数名,函数名是全局的请保持唯一。格式 【req】 + 【函数名】
       ["resp_func"] = "resp_login_check", --这个是协议返回用函数名,函数名是全局的请保持唯一。格式 【resp】 + 【函数名】
       ["req_args"] = --请求参数描述
        {
            --数组，需按顺序填写。否则lua解析会错误 
            {
                ["key"]="platform",          --变量名
                ["type"]="UTF8String[10]",   --数据类型
                ["msg"]="平台:YH/Dark",      --注释,会添加到客户端代码中,方便查看使用
            },
            {["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道"},
            {["key"]="userId",["type"]="UTF8String[64]",["msg"]="平台账号userid"},
            {["key"]="password",["type"]="UTF8String[64]",["msg"]="密码(游客登录时需要)"},
            {["key"]="sid",["type"]="UTF8String[64]",["msg"]="token值"},
            {["key"]="version",["type"]="UTF8String[20]",["msg"]="sdk版本"},
            {["key"]="accessToken",["type"]="UTF8String[2048]",["msg"]="token值(第三方登录时用)"},
        },
        ["resp_args"] = --解析参数描述
        {
            {["key"]="zoneId", ["type"]="Signed32", ["msg"]="默认登陆区"},
            {["key"]="time", ["type"]="Signed32", ["msg"]="登陆时间"},
            {["key"]="zoneCount", ["type"]="Signed32", ["msg"]="总服务器数量"},
            {["key"]="zoneName", ["type"]="UTF8String[24]", ["msg"]="默认登陆区名称"},
            {["key"]="backupDomain", ["type"]="UTF8String[40]", ["msg"]="备用游戏PS服 ip:port"},
            {["key"]="defaultDomain", ["type"]="UTF8String[40]", ["msg"]="默计游戏PS服 ip:port"},
            {["key"]="userId", ["type"]="UTF8String[64]", ["msg"]="UserID/错误信息"},
            {["key"]="sign", ["type"]="UTF8String[32]", ["msg"]="sign"},
            {["key"]="status", ["type"]="Bool", ["msg"]="登陆状态"},
            {["key"]="zoneStatus", ["type"]="Signed32", ["msg"]="0正常1拥挤2爆满"},
            {["key"]="newHere", ["type"]="Signed8", ["msg"]="是否是新账号，0不是，1是"},
            {["key"]="createTime", ["type"]="Signed32", ["msg"]="帐号创建时间"},
            {["key"]="preRegAward", ["type"]="Signed32", ["msg"]="预注册奖励(客户端在登录游戏服时(110011)将此数据发到ss)"},
            {["key"]="param", ["type"]="Signed32", ["msg"]="预留字段"},
        }

    },

    ["190001"] = { --测试Int
        ["module_name"] = "test",
        ["socket_type"] = "local", 
        ["req_socket_size"] = 16,
        ["resp_socket_size"] = 62,
        ["req_func"] = "req_test1", 
        ["resp_func"] = "resp_test1",
        ["req_args"] = { {["key"]="param",["type"]="Signed32",["msg"]="int"} },
        ["resp_args"] ={ {["key"]="param",["type"]="UTF8String[50]",["msg"]="长度50的字符串"} }
    },
    ["190002"] = { --测试String
        ["module_name"] = "test",
        ["socket_type"] = "local",
        ["req_socket_size"] = 62,
        ["resp_socket_size"] = 112,
        ["req_func"] = "req_test2",
        ["resp_func"] = "resp_test2",
        ["req_args"] = { {["key"]="param", ["type"]="UTF8String[50]",["msg"]="长度50的字符串"} },
        ["resp_args"] ={ {["key"]="param", ["type"]="UTF8String[100]",["msg"]="长度100的字符串"} }
    },
    ["190003"] = { --组合测试
        ["module_name"] = "test",
        ["socket_type"] = "local",
        ["req_socket_size"] = 77,
        ["resp_socket_size"] = 113,
        ["req_func"] = "req_test3", 
        ["resp_func"] = "resp_test3",
        ["req_args"] = 
        {
            --数组，需按顺序填写。否则lua解析会错误 
            {["key"]="param1",["type"]="Signed64",["msg"]="long"},
            {["key"]="param2",["type"]="Signed32",["msg"]="int"},
            {["key"]="param3",["type"]="UTF8String[50]",["msg"]="长度50的字符串"},
            {["key"]="param4",["type"]="Signed8",["msg"]="1字节"},
            {["key"]="param5",["type"]="Signed16",["msg"]="2字节"},
        },
        ["resp_args"] =
        {
            {["key"]="bool", ["type"]="Bool",["msg"]="布尔值(客户要用一个字节来接收)"},
            {["key"]="msg", ["type"]="UTF8String[100]",["msg"]="字符串，各个参数的组合"}
        }
    },
    ["190004"] = { --列表测试
        ["module_name"] = "test",
        ["socket_type"] = "local", 
        ["req_socket_size"] = "16 + num * 4", --这里由于请求协议长度不固定无法直接写死,考虑这样写或者直接填0或-1？
        ["resp_socket_size"] = 0, --这里由于返回协议长度不固定无法直接写死,考虑这样写或者直接填0或-1？
        ["req_func"] = "req_test4",
        ["resp_func"] = "resp_test4",
        ["req_args"] = 
        { 
            {["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
            {
                ["key"]="list",
                ["type"]="Signed32[$num]",-- $num代表取key为num的值,有依赖关系所以必须保证num在前面
                ["msg"]="int列表"
            },
        },
        ["resp_args"] =
        {
            {["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
            {["key"]="msg", ["type"]="UTF8String[100]",["msg"]="字符串，各个请求参数的组合"},
            {["key"]="list", ["type"]="Signed32[$num]",["msg"]="原请求的int列表"},
        }
    },
    ["190005"] = { --列表测试-结构列表
        ["module_name"] = "test",
        ["socket_type"] = "local", 
        ["req_socket_size"] = "16 + num * 2 * 4", --这里由于请求协议长度不固定无法直接写死,考虑这样写或者直接填0或-1？
        ["resp_socket_size"] = 0, --这里由于返回协议长度不固定无法直接写死,考虑这样写或者直接填0或-1？
        ["req_func"] = "req_test5",
        ["resp_func"] = "resp_test5",
        ["req_args"] = 
        { 
            {["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
            {
                ["key"]="RequestStructData", --填的是方括号前面的值,例子1:RequestStructData[] ~ RequestStructData, 例子2:FightDataKeyVal[] ~ FightDataKeyVal
                ["type"]="struct[$num]",-- $num代表取key为num的值,有依赖关系所以必须保证num在前面
                ["msg"]="结构列表",
                ["struct"] = --struct和struct[$num]需成对出现，如果不是结构体列表，只是结构体请用struct[1]表示
                {
                    -- 结构体里面的结构和req_args类似,这样可以解决嵌套列表的问题
                    {["key"]="param1",["type"]="Signed32",["msg"]="int"},
                    {["key"]="param2",["type"]="Signed32",["msg"]="int"},
                }
            },
        },
        ["resp_args"] =
        {
            {["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
            {
                ["key"]="RequestStructData",
                ["type"]="struct[$num]",
                ["msg"]="结构列表",
                ["struct"] = 
                {
                    {["key"]="param1",["type"]="Signed32",["msg"]="int"},
                    {["key"]="param2",["type"]="Signed32",["msg"]="int"},
                    {
                        -- 长度为10的int列表的写法
                        ["key"]="paramList",
                        ["type"]="Signed32[10]",
                        ["msg"]="结构内部列表，长度为10的int列表，将请求的参数1和参数2放到这个列表的0和1位置",

                        -- 一个结构体的写法
                        -- ["key"]="param2",
                        -- ["type"]="struct[1]",
                        -- ["msg"]="结构内部列表，长度为10的int列表，将请求的参数1和参数2放到这个列表的0和1位置"
                        -- ["struct"] = 
                        -- {
                        --      ...
                        -- }

                        -- 结构体列表的写法
                        -- ["key"]="param2",
                        -- ["type"]="struct[10]",
                        -- ["msg"]="结构内部列表，长度为10的int列表，将请求的参数1和参数2放到这个列表的0和1位置"
                        -- ["struct"] = 
                        -- {
                        --       ...
                        -- }

                        -- 结构体列表的写法2(列表数量不确定)
                        -- ["key"]="param2",
                        -- ["type"]="struct[$param2]",
                        -- ["msg"]="结构内部列表，长度为10的int列表，将请求的参数1和参数2放到这个列表的0和1位置"
                        -- ["struct"] = 
                        -- {
                        --       ...
                        -- }
                    },
                }
            },
        }
    },
}

return RPC_func_table
