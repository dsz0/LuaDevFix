--======================================================================
--（c）copyright 2018 dsz0 All Rights Reserved
--======================================================================
-- Filename: rpc_lua_table.lua
-- Author: xxxTool  created: 2018/3/5  20:58
--[[Description: 自动生成此lua,协议号pid对应的请求和返回函数。发送时要分socket,有四种,login，chat，game，pvp
TODO:这里重要的是下行接收函数resp_func,上行请求函数req_func只是用于check和信息提示。
--=====================================================================]]

--无请求参数["req_args"]为空,即["req_args"] = {}或直接不写这个字段
--无返回参数["resp_args"]为空,即["resp_args"] = {}或直接不写这个字段

RPC_func_table = {

	["110001"] = { --完成场景加载
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 9, --未包含协议头部长度
		["req_func"] = "req_scene_loaded",
		["resp_func"] = "resp_res_scene_loaded",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="aoiId"},
			{["key"]="isReconnect",["type"]="Bool",["msg"]="是否重连"},
		}
	},

	["110002"] = { --移动
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 22, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_move",
		["req_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
	},

	["110003"] = { --移动停止
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 22, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_stop",
		["req_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
	},

	["110004"] = { --背包道具列表
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 8", --未包含协议头部长度
		["req_func"] = "req_bag_list",
		["resp_func"] = "resp_bag_list",
		["req_args"] =
		{
			{["key"]="curPage",["type"]="Signed32",["msg"]="取第几页的数据"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="pageAll",["type"]="Signed32",["msg"]="全部装备的页数"},
			{["key"]="page",["type"]="Signed32",["msg"]="当前第几页[0,n)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["110005"] = { --获得玩家相关参数（目前只有技能点，后面需要再加）
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["req_func"] = "req_user_parm",
		["resp_func"] = "resp_user_parm",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="skillpoint",["type"]="Signed32",["msg"]="技能点"},
			{["key"]="nextRefTime",["type"]="Signed32",["msg"]="技能点下次刷新时间"},
			{["key"]="refInterval",["type"]="Signed32",["msg"]="刷新间隔"},
			{["key"]="skillpointMax",["type"]="Signed32",["msg"]="技能点最高上限"},
		}
	},

	["110006"] = { --玩家完成指引
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_user_guide_complete",
		["req_args"] =
		{
			{["key"]="guideId",["type"]="Signed64",["msg"]="玩家完成引导ID当guideType=4时，高32位表示引导组id，低32位表示步骤id"},
			{["key"]="guideType",["type"]="Signed32",["msg"]="玩家完成引导ID的类型，1：NPC引导，2：强制引导,3：功能连环图片引导,4：新手引导系统"},
			{["key"]="state",["type"]="Signed32",["msg"]="状态，当guideType=4,此字段填引导状态(0:正常，1:异常退出)"},
		},
	},

	["110007"] = { --获得玩家引导
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "36 + num * 0", --未包含协议头部长度
		["req_func"] = "req_user_guide",
		["resp_func"] = "resp_user_guide",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="guide",["type"]="Signed64",["msg"]="玩家引导进度,-1表示已完成所有引导"},
			{["key"]="guidePic",["type"]="Signed64",["msg"]="图片指引进度(旧强制引导，已废弃)"},
			{["key"]="openFlag",["type"]="Signed32",["msg"]="ui功能按钮的开放"},
			{["key"]="funcPicGuide",["type"]="Signed64",["msg"]="功能图片引导"},
			{["key"]="funcOtherGuide",["type"]="Signed32",["msg"]="特殊的需要服务器提醒客户端的引导"},
			{
				["key"]="guidancelist",
				["type"]="",
				["msg"]="新手引导进度列表（高32位表示引导组id，低32位表示步骤id）",
			},
		}
	},

	["110008"] = { --修改头像
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_icon",
		["req_args"] =
		{
			{["key"]="icon",["type"]="Signed32",["msg"]="头像ID"},
		},
	},

	["110009"] = { --发送银汉登录日志
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 215, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_y_h_log_parm",
		["req_args"] =
		{
			{["key"]="operator",["type"]="UTF8String[4]",["msg"]="运营商"},
			{["key"]="net",["type"]="UTF8String[8]",["msg"]="网络环境，2g/3g/4g/wifi等"},
			{["key"]="modelType",["type"]="UTF8String[10]",["msg"]="终端型号"},
			{["key"]="ip",["type"]="UTF8String[15]",["msg"]="ip"},
			{["key"]="imei",["type"]="UTF8String[17]",["msg"]="IMEI"},
			{["key"]="mac",["type"]="UTF8String[17]",["msg"]="mac"},
			{["key"]="parm",["type"]="UTF8String[20]",["msg"]="预留参数：sdk版本,sdk_id"},
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型，1注册，2登陆"},
			{["key"]="system",["type"]="UTF8String[100]",["msg"]="客户端系统版本号"},
			{["key"]="adID",["type"]="UTF8String[20]",["msg"]="广告短链ID"},
		},
	},

	["110010"] = { --修改个性签名
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 60, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_change_signature",
		["resp_func"] = "resp_change_signature",
		["req_args"] =
		{
			{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
		}
	},

	["110011"] = { --玩家登陆
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 370, --未包含协议头部长度
		["resp_socket_size"] = 77, --未包含协议头部长度
		["req_func"] = "req_login",
		["resp_func"] = "resp_login_response",
		["req_args"] =
		{
			{["key"]="pid",["type"]="UTF8String[64]",["msg"]="平台ID"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道"},
			{["key"]="time",["type"]="Signed32",["msg"]="时间"},
			{["key"]="zoneId",["type"]="Unsigned16",["msg"]="选择大区ID"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
			{["key"]="tk",["type"]="UTF8String[32]",["msg"]="Apple推送token"},
			{["key"]="tkType",["type"]="Signed16",["msg"]="apple推送token类型,1:iphone 2:ipad"},
			{["key"]="model",["type"]="UTF8String[32]",["msg"]="机器型号"},
			{["key"]="ip",["type"]="UTF8String[15]",["msg"]="客户端IP，服务端智能生成，不用传参"},
			{["key"]="mac",["type"]="UTF8String[17]",["msg"]="mac地址"},
			{["key"]="queueSign",["type"]="UTF8String[32]",["msg"]="排队获得的key,没有经过排队，则给空字符串"},
			{["key"]="queueExpireTime",["type"]="Signed32",["msg"]="排队的key过期时间, 没有排队，则给0"},
			{["key"]="runSystem",["type"]="Signed32",["msg"]="运行平台,4=安卓/5=ios/7=wm"},
			{["key"]="clientVersion",["type"]="UTF8String[32]",["msg"]="客户端版本"},
			{["key"]="adID",["type"]="UTF8String[20]",["msg"]="广告短链ID"},
			{["key"]="dbSign",["type"]="UTF8String[32]",["msg"]="用于校验数据库与xml数据版本是否一致"},
			{["key"]="preRegAward",["type"]="Signed64",["msg"]="预注册奖励"},
		},
		["resp_args"] =
		{
			{["key"]="stime",["type"]="Signed32",["msg"]="服务器时间：登录排队服务器时需要发送"},
			{["key"]="result",["type"]="Signed8",["msg"]="是否成功 0：没创号 1登陆成功 2 未知错误 3 账号封停 45需要登录排队服 6 排队失败、78排队验证失败，需要重新登录 9成功，需要选择英雄"},
			{["key"]="uid",["type"]="Signed64",["msg"]="角色uid，排队时需要，在未创号时会为0"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值:用于登录排队服务器，需要排队时才有"},
			{["key"]="reconnectKey",["type"]="UTF8String[32]",["msg"]="随机生成的一个字符串，用于客户端重连时校验，防止伪造登录"},
		}
	},

	["110012"] = { --创号
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 104, --未包含协议头部长度
		["resp_socket_size"] = 134, --未包含协议头部长度
		["req_func"] = "req_register",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄类型 0-不创建英雄，等下一步创建英雄 >0 直接选择与创建英雄"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="昵称"},
			{["key"]="runSystem",["type"]="Signed32",["msg"]="运行平台,4=安卓/5=ios/7=wm"},
			{["key"]="clientVersion",["type"]="UTF8String[32]",["msg"]="客户端版本"},
			{["key"]="adID",["type"]="UTF8String[20]",["msg"]="广告短链ID"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="帐号创建时间(银汉日志用)"},
		},
	},

	["110013"] = { --选择英雄
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 60, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_select_hero",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄类型"},
			{["key"]="runSystem",["type"]="Signed32",["msg"]="运行平台,4=安卓/5=ios/7=wm"},
			{["key"]="clientVersion",["type"]="UTF8String[32]",["msg"]="客户端版本"},
			{["key"]="adID",["type"]="UTF8String[20]",["msg"]="广告短链ID"},
		},
	},

	["110014"] = { --转向
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 22, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_turn",
		["req_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="新的方向"},
		},
	},

	["110016"] = { --后台游戏进度日志
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_player_process_after_sdk_log",
		["req_args"] =
		{
			{["key"]="process",["type"]="Signed32",["msg"]="游戏进度类型"},
			{["key"]="status",["type"]="Signed32",["msg"]="游戏每个进度类型的状态顺序"},
		},
	},

	["110017"] = { --同步好友列表
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = "36 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_syn_friend_list",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于校验好友数据是否伪造"},
			{
				["key"]="friendList",
				["type"]="Signed64[$num]",
				["msg"]="好友列表",
			},
		},
	},

	["110018"] = { --客户端改变画质
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_client_quality",
		["req_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="type",["type"]="Signed32",["msg"]="1低 2中 3高"},
		},
	},

	["110019"] = { --客户端取消红点
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_cancel_red_point",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="红点类型"},
			{["key"]="param",["type"]="Signed32",["msg"]="参数(当type=14时，param=CollectData.id当type=13时，param=HuntingMagic.id当type=15时，param=goodsId)"},
		},
	},

	["110020"] = { --记录玩家设备信息
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 283, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_record_device_info",
		["req_args"] =
		{
			{["key"]="ip",["type"]="UTF8String[39]",["msg"]="ip(客户端不用赋值)"},
			{["key"]="net",["type"]="UTF8String[8]",["msg"]="网络环境，2g/3g/4g/wifi等"},
			{["key"]="modelType",["type"]="UTF8String[32]",["msg"]="终端型号:iphone7/荣耀6等"},
			{["key"]="pcType",["type"]="Signed32",["msg"]="设备类型：1-手持设备，2-pc设备"},
			{["key"]="imei",["type"]="UTF8String[17]",["msg"]="IMEI"},
			{["key"]="mac",["type"]="UTF8String[17]",["msg"]="mac"},
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型，1注册，2登陆"},
			{["key"]="clientVersion",["type"]="UTF8String[32]",["msg"]="客户端版本号"},
			{["key"]="resolution",["type"]="UTF8String[10]",["msg"]="客户端分辨率"},
			{["key"]="system",["type"]="UTF8String[100]",["msg"]="客户端系统版本"},
			{["key"]="param",["type"]="UTF8String[20]",["msg"]="预留参数"},
		},
	},

	["110021"] = { --防作弊：检查玩家战斗数据
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = "76 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_check_fight_data",
		["resp_func"] = "resp_check_fight_data",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="damageSum",["type"]="Signed32",["msg"]="攻击力总和；（被动修改攻击力之后的攻击力数值）"},
			{["key"]="bst",["type"]="Signed32",["msg"]="普通/技能攻击力总和；"},
			{["key"]="crit",["type"]="Signed32",["msg"]="是否暴击"},
			{["key"]="damage",["type"]="Signed32",["msg"]="固定伤害"},
			{["key"]="damageProportion",["type"]="Signed32",["msg"]="固定伤害百分比"},
			{["key"]="restraint",["type"]="Signed32",["msg"]="属性克制比例"},
			{["key"]="ratio",["type"]="Signed32",["msg"]="技能伤害倍率"},
			{["key"]="finalDamage",["type"]="Signed32",["msg"]="最终造成的伤害值"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="BST",["type"]="Signed32",["msg"]="技能类型"},
			{["key"]="AV",["type"]="Signed32",["msg"]="技能基础伤害"},
			{["key"]="aiSL",["type"]="Signed32",["msg"]="技能成长伤害"},
			{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
			{["key"]="CD",["type"]="Signed32",["msg"]="技能CD"},
			{["key"]="EpC",["type"]="Signed32",["msg"]="技能消耗"},
			{["key"]="ADdp",["type"]="Signed32",["msg"]="伤害属性"},
			{["key"]="CSD",["type"]="Signed32",["msg"]="攻击范围"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="当前英雄ID"},
			{
				["key"]="attrList",
				["type"]="struct[$num]",	--FightDataKeyVal
				["msg"]="英雄属性",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="战斗属性类型TypeAttr"},
					{["key"]="val",["type"]="Signed32",["msg"]="战斗属性数值"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0正常,1数值异常暂不处理,2判定为作弊需封号"},
		}
	},

	["110022"] = { --查询当前战斗是否作弊
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_check_is_hack",
		["resp_func"] = "resp_check_is_hack",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="1作弊 0正常"},
		}
	},

	["110023"] = { --发送登录日志
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 644, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_send_login_log",
		["req_args"] =
		{
			{["key"]="PlatID",["type"]="Signed32",["msg"]="(必填)ios 0 /android 1"},
			{["key"]="ClientVersion",["type"]="UTF8String[64]",["msg"]="(可选)客户端版本"},
			{["key"]="SystemSoftware",["type"]="UTF8String[64]",["msg"]="(可选)移动终端操作系统版本"},
			{["key"]="SystemHardware",["type"]="UTF8String[64]",["msg"]="(可选)移动终端机型"},
			{["key"]="TelecomOper",["type"]="UTF8String[64]",["msg"]="(必填)运营商"},
			{["key"]="Network",["type"]="UTF8String[64]",["msg"]="(可选)3G/WIFI/2G"},
			{["key"]="ScreenWidth",["type"]="Signed32",["msg"]="(可选)显示屏宽度"},
			{["key"]="ScreenHight",["type"]="Signed32",["msg"]="(可选)显示屏高度"},
			{["key"]="Density",["type"]="Signed32",["msg"]="(可选)像素密度 *1000"},
			{["key"]="Channel",["type"]="Signed32",["msg"]="(必填)注册渠道/登陆渠道"},
			{["key"]="CpuHardware",["type"]="UTF8String[64]",["msg"]="(可选)cpu类型|频率|核数"},
			{["key"]="Memory",["type"]="Signed32",["msg"]="(可选)内存信息单位M"},
			{["key"]="GLRender",["type"]="UTF8String[64]",["msg"]="(可选)opengl render信息"},
			{["key"]="GLVersion",["type"]="UTF8String[64]",["msg"]="(可选)opengl版本信息"},
			{["key"]="DeviceId",["type"]="UTF8String[64]",["msg"]="(可选)设备ID"},
			{["key"]="platformType",["type"]="Signed32",["msg"]="(必填)平台类型:0:QQ,1:微信"},
			{["key"]="ip",["type"]="UTF8String[40]",["msg"]="ip(客户端不用赋值)"},
		},
	},

	["110024"] = { --修改头像
		["module_name"] = "system", --系统模块
		["socket_type"] = "game",
		["req_socket_size"] = 256, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_icon_url",
		["req_args"] =
		{
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像ID"},
		},
	},

	["110101"] = { --英雄列表
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 90", --未包含协议头部长度
		["req_func"] = "req_hero_list",
		["resp_func"] = "resp_hero_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--HeroInfo
				["msg"]="英雄列表",
				["struct"]=
				{
					{["key"]="control",["type"]="Signed8",["msg"]="控制英雄 1主 2副 0无"},
					{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄配置ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="stage",["type"]="Signed32",["msg"]="档次"},
					{["key"]="stageItemId",["type"]="Signed32",["msg"]="魂阶药水ID"},
					{["key"]="effectStage",["type"]="Signed32",["msg"]="魂阶药水影响等级， 如果此值为0 则可以不考虑魂阶药水相关参数"},
					{["key"]="effectType",["type"]="Signed32",["msg"]="魂阶药水影响类型， 1. 叠加魂阶；2. 指定魂阶"},
					{["key"]="continueType",["type"]="Signed32",["msg"]="魂阶药水持续类型， 1. 指定时间有效；2. 指定打副本xx次"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="魂阶药水生效时间；1. 如果持续类型为指定时间则表示药水结束时间；2. 如果持续类型为打副本xx次，则表示为总共可用次数"},
					{["key"]="useTimes",["type"]="Signed32",["msg"]="魂阶药水如果持续类型是使用次数时，该字段指定已经使用过的次数"},
					{["key"]="exp",["type"]="Signed32",["msg"]="当前经验"},
					{["key"]="practiceExp",["type"]="Signed32",["msg"]="英雄熟练度"},
					{["key"]="status",["type"]="Signed8",["msg"]="状态(是否在执行派遣任务:0 默认状态, 1 已被派遣,不能做任何操作)"},
					{["key"]="missionId",["type"]="Signed32",["msg"]="剧情任务id(当前在做但是未完成的), 0表示还未开始"},
					{["key"]="skill1Level",["type"]="Signed32",["msg"]="技能1等级"},
					{["key"]="skill2Level",["type"]="Signed32",["msg"]="技能2等级"},
					{["key"]="skill3Level",["type"]="Signed32",["msg"]="技能3等级"},
					{["key"]="skill4Level",["type"]="Signed32",["msg"]="技能4等级"},
					{["key"]="skill5Level",["type"]="Signed32",["msg"]="技能5等级"},
					{["key"]="skill1branch",["type"]="Signed32",["msg"]="技能1所选分支"},
					{["key"]="skill2branch",["type"]="Signed32",["msg"]="技能2所选分支"},
					{["key"]="skill3branch",["type"]="Signed32",["msg"]="技能3所选分支"},
					{["key"]="skill4branch",["type"]="Signed32",["msg"]="技能4所选分支"},
					{["key"]="skill5branch",["type"]="Signed32",["msg"]="技能5所选分支"},
				}
			},
		}
	},

	["110102"] = { --设置主控、副控英雄
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_hero_appoint",
		["req_args"] =
		{
			{["key"]="firstHero",["type"]="Signed32",["msg"]="新主控英雄ID"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="新副控英雄ID, 0表示留空"},
		},
	},

	["110103"] = { --激活英雄
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "94 + num * 26", --未包含协议头部长度
		["req_func"] = "req_hero_activate",
		["resp_func"] = "resp_hero_activate",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="heroInfo",
				["type"]="struct",	--HeroInfo
				["msg"]="英雄信息",
				["struct"]=
				{
					{["key"]="control",["type"]="Signed8",["msg"]="控制英雄 1主 2副 0无"},
					{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄配置ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="stage",["type"]="Signed32",["msg"]="档次"},
					{["key"]="stageItemId",["type"]="Signed32",["msg"]="魂阶药水ID"},
					{["key"]="effectStage",["type"]="Signed32",["msg"]="魂阶药水影响等级， 如果此值为0 则可以不考虑魂阶药水相关参数"},
					{["key"]="effectType",["type"]="Signed32",["msg"]="魂阶药水影响类型， 1. 叠加魂阶；2. 指定魂阶"},
					{["key"]="continueType",["type"]="Signed32",["msg"]="魂阶药水持续类型， 1. 指定时间有效；2. 指定打副本xx次"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="魂阶药水生效时间；1. 如果持续类型为指定时间则表示药水结束时间；2. 如果持续类型为打副本xx次，则表示为总共可用次数"},
					{["key"]="useTimes",["type"]="Signed32",["msg"]="魂阶药水如果持续类型是使用次数时，该字段指定已经使用过的次数"},
					{["key"]="exp",["type"]="Signed32",["msg"]="当前经验"},
					{["key"]="practiceExp",["type"]="Signed32",["msg"]="英雄熟练度"},
					{["key"]="status",["type"]="Signed8",["msg"]="状态(是否在执行派遣任务:0 默认状态, 1 已被派遣,不能做任何操作)"},
					{["key"]="missionId",["type"]="Signed32",["msg"]="剧情任务id(当前在做但是未完成的), 0表示还未开始"},
					{["key"]="skill1Level",["type"]="Signed32",["msg"]="技能1等级"},
					{["key"]="skill2Level",["type"]="Signed32",["msg"]="技能2等级"},
					{["key"]="skill3Level",["type"]="Signed32",["msg"]="技能3等级"},
					{["key"]="skill4Level",["type"]="Signed32",["msg"]="技能4等级"},
					{["key"]="skill5Level",["type"]="Signed32",["msg"]="技能5等级"},
					{["key"]="skill1branch",["type"]="Signed32",["msg"]="技能1所选分支"},
					{["key"]="skill2branch",["type"]="Signed32",["msg"]="技能2所选分支"},
					{["key"]="skill3branch",["type"]="Signed32",["msg"]="技能3所选分支"},
					{["key"]="skill4branch",["type"]="Signed32",["msg"]="技能4所选分支"},
					{["key"]="skill5branch",["type"]="Signed32",["msg"]="技能5所选分支"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--EquipInfo
				["msg"]="装备列表",
				["struct"]=
				{
					{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="equipId",["type"]="Signed32",["msg"]="装备ID"},
					{["key"]="level",["type"]="Signed8",["msg"]="星级"},
					{["key"]="part",["type"]="Signed8",["msg"]="部位"},
					{["key"]="grade",["type"]="Signed8",["msg"]="品质(阶)"},
					{["key"]="enchant1",["type"]="Signed8",["msg"]="附魔属性1"},
					{["key"]="enchant2",["type"]="Signed8",["msg"]="附魔属性2"},
					{["key"]="enchant3",["type"]="Signed8",["msg"]="附魔属性3"},
					{["key"]="evalue1",["type"]="Signed32",["msg"]="附魔数值1"},
					{["key"]="evalue2",["type"]="Signed32",["msg"]="附魔数值2"},
					{["key"]="evalue3",["type"]="Signed32",["msg"]="附魔数值3"},
				}
			},
		}
	},

	["110104"] = { --英雄提升魂阶
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_hero_stage",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="stage",["type"]="Signed32",["msg"]="英雄当前魂阶(操作后)"},
		},
	},

	["110105"] = { --英雄技能升级
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 9, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_hero_skill_upgrade",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="index",["type"]="Signed8",["msg"]="英雄技能的下标[0,4]"},
			{["key"]="level",["type"]="Signed32",["msg"]="当前的英雄技能等级(操作后)"},
		},
	},

	["110107"] = { --购买技能点数
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_buy_skill_point",
		["req_args"] =
		{
		},
	},

	["110108"] = { --英雄技能选择分支
		["module_name"] = "hero", --英雄模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_select_skill_branch",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="index",["type"]="Signed32",["msg"]="英雄技能的位置[0, 4]"},
			{["key"]="branch",["type"]="Signed32",["msg"]="分支序号[1, 4]"},
		},
	},

	["110201"] = { --英雄符文列表
		["module_name"] = "rune", --符文模块(旧装备)
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 26", --未包含协议头部长度
		["req_func"] = "req_equip_list",
		["resp_func"] = "resp_equip_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--EquipInfo
				["msg"]="装备列表",
				["struct"]=
				{
					{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="equipId",["type"]="Signed32",["msg"]="装备ID"},
					{["key"]="level",["type"]="Signed8",["msg"]="星级"},
					{["key"]="part",["type"]="Signed8",["msg"]="部位"},
					{["key"]="grade",["type"]="Signed8",["msg"]="品质(阶)"},
					{["key"]="enchant1",["type"]="Signed8",["msg"]="附魔属性1"},
					{["key"]="enchant2",["type"]="Signed8",["msg"]="附魔属性2"},
					{["key"]="enchant3",["type"]="Signed8",["msg"]="附魔属性3"},
					{["key"]="evalue1",["type"]="Signed32",["msg"]="附魔数值1"},
					{["key"]="evalue2",["type"]="Signed32",["msg"]="附魔数值2"},
					{["key"]="evalue3",["type"]="Signed32",["msg"]="附魔数值3"},
				}
			},
		}
	},

	["110202"] = { --符文进阶
		["module_name"] = "rune", --符文模块(旧装备)
		["socket_type"] = "game",
		["req_socket_size"] = 5, --未包含协议头部长度
		["resp_socket_size"] = 17, --未包含协议头部长度
		["req_func"] = "req_equip_upgrade",
		["resp_func"] = "resp_equip_upgrade",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="part",["type"]="Signed8",["msg"]="装备部位"},
		},
		["resp_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="part",["type"]="Signed8",["msg"]="装备部位"},
			{["key"]="grade",["type"]="Signed32",["msg"]="进阶后的品质"},
			{["key"]="level",["type"]="Signed32",["msg"]="进阶后的级"},
			{["key"]="gold",["type"]="Signed32",["msg"]="进阶后的金币数量"},
		}
	},

	["110203"] = { --增加魔力
		["module_name"] = "rune", --符文模块(旧装备)
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_add_mana",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="材料ID"},
			{["key"]="num",["type"]="Signed32",["msg"]="材料数量"},
			{["key"]="mana",["type"]="Signed32",["msg"]="此次操作获得的魔力值总数"},
		},
	},

	["110204"] = { --符文附魔(等待返回)
		["module_name"] = "rune", --符文模块(旧装备)
		["socket_type"] = "game",
		["req_socket_size"] = 14, --未包含协议头部长度
		["resp_socket_size"] = 18, --未包含协议头部长度
		["req_func"] = "req_equip_enchant",
		["resp_func"] = "resp_equip_enchant",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="part",["type"]="Signed8",["msg"]="装备部位"},
			{["key"]="pos",["type"]="Signed8",["msg"]="附魔第几个属性:0,1,2"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="附魔使用的材料ID"},
			{["key"]="mana",["type"]="Signed32",["msg"]="附魔使用的魔力值"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Bool",["msg"]="附魔结果:1成功，0失败"},
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="part",["type"]="Signed8",["msg"]="装备部位"},
			{["key"]="pos",["type"]="Signed32",["msg"]="附魔第几个属性:0,1,2"},
			{["key"]="enchant",["type"]="Signed32",["msg"]="附魔得到的属性类型"},
			{["key"]="evalue",["type"]="Signed32",["msg"]="附魔得到的属性值"},
		}
	},

	["110205"] = { --符文一键进阶
		["module_name"] = "rune", --符文模块(旧装备)
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 9", --未包含协议头部长度
		["req_func"] = "req_equip_upgrade_one_key",
		["resp_func"] = "resp_equip_upgrade_one_key",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OneKeyEquipInfo
				["msg"]="符文列表",
				["struct"]=
				{
					{["key"]="part",["type"]="Signed8",["msg"]="装备部位"},
					{["key"]="grade",["type"]="Signed32",["msg"]="装备当前品质(操作后)"},
					{["key"]="level",["type"]="Signed32",["msg"]="装备当前级(操作后)"},
				}
			},
		}
	},

	["110301"] = { --浏览商店(等待返回)
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 24", --未包含协议头部长度
		["req_func"] = "req_sell_data_list",
		["resp_func"] = "resp_sell_data_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{["key"]="lastHeroSellTime",["type"]="Signed32",["msg"]="上一次英雄出去售卖的时间（秒数）"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SellDataInfo
				["msg"]="商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型:1钻石, 2金币"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)"},
				}
			},
		}
	},

	["110302"] = { --刷新商店(等待返回)
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 24", --未包含协议头部长度
		["req_func"] = "req_shop_refresh",
		["resp_func"] = "resp_shop_refresh",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SellDataInfo
				["msg"]="刷新后的商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型:1钻石, 2金币"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)"},
				}
			},
		}
	},

	["110303"] = { --购买物品(等待返回)
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_shop_buy",
		["resp_func"] = "resp_shop_buy",
		["req_args"] =
		{
			{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
			{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID,用于验证商品数据是否已经过期"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="购买成功1，商品信息已经过期需要刷新0"},
		}
	},

	["110304"] = { --出售物品
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_shop_sell",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
			{["key"]="num",["type"]="Signed32",["msg"]="数量"},
			{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型：1钻石, 2金币(用于验证)"},
			{["key"]="money",["type"]="Signed32",["msg"]="获得货币总数(用于验证)"},
		},
	},

	["110305"] = { --英雄外出采购
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_shop_hero_out",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
		},
	},

	["110306"] = { --马车
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_shop_hero_arrive",
		["req_args"] =
		{
		},
	},

	["110307"] = { --召回
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_shop_hero_recall",
		["req_args"] =
		{
		},
	},

	["110308"] = { --获得英雄出售物品列表
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 16", --未包含协议头部长度
		["req_func"] = "req_shop_hero_sell_item_list",
		["resp_func"] = "resp_shop_hero_sell_item_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--HeroSellDataInfo
				["msg"]="英雄出售的商品列表",
				["struct"]=
				{
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型:1钻石, 2金币"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)"},
				}
			},
		}
	},

	["110309"] = { --购买英雄出售的物品
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_shop_hero_sell_buy",
		["req_args"] =
		{
			{["key"]="index",["type"]="Signed32",["msg"]="物品Index"},
		},
	},

	["110311"] = { --魔法石商店信息
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_magic_stone_shop",
		["resp_func"] = "resp_magic_stone_shop",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MagicStoneShopInfo
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="格子id，对应MagicStoneShop.id"},
					{["key"]="sell",["type"]="Signed32",["msg"]="出售商品，对应MagicStoneShopFactory.id"},
				}
			},
		}
	},

	["110312"] = { --魔法石商店购买
		["module_name"] = "shop", --商店模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_magic_stone_shop_buy",
		["resp_func"] = "resp_magic_stone_shop_buy",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="格子id MagicStoneShop.id"},
			{["key"]="sell",["type"]="Signed32",["msg"]="MagicStoneShopFactory.id,用于校验"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果 1:成功  0:商品过期，需重新刷新"},
		}
	},

	["110402"] = { --浏览任务信息(等待返回)
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "172 + num * 36", --未包含协议头部长度
		["req_func"] = "req_mission_list",
		["resp_func"] = "resp_mission_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="curMission",["type"]="Signed32",["msg"]="玩家当前领取的任务id"},
			{
				["key"]="curMissionInfo",
				["type"]="struct",	--MissionInfo
				["msg"]="玩家当前领取的任务详情, curMission为0时不考虑",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务状态:0 初始状态,1 剧情可触发，但是还未触发,2 可以接任务的状态,3 已接未进入关卡,4 进入关卡，还未完成,5 已经完成"},
					{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
					{["key"]="countDay",["type"]="Signed32",["msg"]="当天完成任务的次数"},
					{["key"]="countWeek",["type"]="Signed32",["msg"]="本周完成任务的次数"},
					{["key"]="acceptTime",["type"]="Signed32",["msg"]="接受任务的时间"},
					{["key"]="faceChips",["type"]="Signed16",["msg"]="获取到面具的数量"},
					{["key"]="isGetFaceBox",["type"]="Signed16",["msg"]="任务宝箱是否领取"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="购买挑战次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
					{["key"]="blessing",["type"]="Signed32",["msg"]="选择的祝福种类，默认为0表示原始的未加倍，1表示选择第一种"},
				}
			},
			{["key"]="singleMission",["type"]="Signed32",["msg"]="单人任务最新进度的任务id"},
			{["key"]="singleExtr",["type"]="Signed32",["msg"]="单人(额外)最新进度的任务id"},
			{["key"]="singleHard",["type"]="Signed32",["msg"]="单人(困难)最新进度的任务id"},
			{["key"]="singleHell",["type"]="Signed32",["msg"]="单人(地狱)最新进度的任务id"},
			{["key"]="playerMission",["type"]="Signed32",["msg"]="主线剧情的任务id"},
			{["key"]="heroMission",["type"]="Signed32",["msg"]="当前主控英雄的剧情任务id"},
			{["key"]="dailyMission",["type"]="UTF8String[100]",["msg"]="日常任务的id串id1,id2,id3..."},
			{["key"]="lastTeamMission",["type"]="Signed32",["msg"]="上一次打过的组队任务"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MissionInfo
				["msg"]="预留:活动任务信息列表",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务状态:0 初始状态,1 剧情可触发，但是还未触发,2 可以接任务的状态,3 已接未进入关卡,4 进入关卡，还未完成,5 已经完成"},
					{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
					{["key"]="countDay",["type"]="Signed32",["msg"]="当天完成任务的次数"},
					{["key"]="countWeek",["type"]="Signed32",["msg"]="本周完成任务的次数"},
					{["key"]="acceptTime",["type"]="Signed32",["msg"]="接受任务的时间"},
					{["key"]="faceChips",["type"]="Signed16",["msg"]="获取到面具的数量"},
					{["key"]="isGetFaceBox",["type"]="Signed16",["msg"]="任务宝箱是否领取"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="购买挑战次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
					{["key"]="blessing",["type"]="Signed32",["msg"]="选择的祝福种类，默认为0表示原始的未加倍，1表示选择第一种"},
				}
			},
		}
	},

	["110404"] = { --完成任务
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 17, --未包含协议头部长度
		["resp_socket_size"] = "15 + num * 8", --未包含协议头部长度
		["req_func"] = "req_mission_complete",
		["resp_func"] = "resp_mission_complete",
		["req_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
			{["key"]="practiceExp1",["type"]="Signed32",["msg"]="主英雄熟练度：大于0（增量值）"},
			{["key"]="practiceExp2",["type"]="Signed32",["msg"]="副英雄熟练度：大于0（增量值）"},
			{["key"]="faceChip",["type"]="Signed8",["msg"]="面部碎片： 用二进制表示碎片例如 7=111 表示三个碎片。3=11 表示2个碎片（前两个）；5=101表示两个碎片（首尾达成）"},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
			{["key"]="exp",["type"]="Signed32",["msg"]="增加的总经验值"},
			{["key"]="totalChip",["type"]="Signed8",["msg"]="当个任务的总的面积碎片：1~3的值"},
			{["key"]="newFaceChip",["type"]="Signed8",["msg"]="当次新增加的面具碎片"},
			{["key"]="faceBoxStatus",["type"]="Signed8",["msg"]="当前任务的面具宝箱的状态， 0 无宝箱；1有宝箱，未达成;2有宝箱，已经领取"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="宝箱奖励",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["110405"] = { --放弃任务
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_mission_cancel",
		["resp_func"] = "resp_mission_cancel",
		["req_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="状态:0未进入关卡, 1 取取消任务"},
			{["key"]="exp",["type"]="Signed32",["msg"]="增加的总经验值"},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
			{["key"]="practiceExp1",["type"]="Signed32",["msg"]="主英雄熟练度：大于0（增量值）"},
			{["key"]="practiceExp2",["type"]="Signed32",["msg"]="副英雄熟练度：大于0（增量值）"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
			{["key"]="exp",["type"]="Signed32",["msg"]="增加的总经验值"},
		}
	},

	["110406"] = { --任务失败
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_mission_fail",
		["resp_func"] = "resp_mission_fail",
		["req_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="状态:0未进入关卡, 1 取取消任务"},
			{["key"]="exp",["type"]="Signed32",["msg"]="增加的总经验值"},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
			{["key"]="practiceExp1",["type"]="Signed32",["msg"]="主英雄熟练度：大于0（增量值）"},
			{["key"]="practiceExp2",["type"]="Signed32",["msg"]="副英雄熟练度：大于0（增量值）"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
			{["key"]="exp",["type"]="Signed32",["msg"]="增加的总经验值"},
		}
	},

	["110410"] = { --查看指定ID任务列表
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 36", --未包含协议头部长度
		["req_func"] = "req_mission_info",
		["resp_func"] = "resp_mission_info_special",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="idList",
				["type"]="Signed32[$num]",
				["msg"]="需要查看的任务id列表",
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MissionInfo
				["msg"]="任务信息列表",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务状态:0 初始状态,1 剧情可触发，但是还未触发,2 可以接任务的状态,3 已接未进入关卡,4 进入关卡，还未完成,5 已经完成"},
					{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
					{["key"]="countDay",["type"]="Signed32",["msg"]="当天完成任务的次数"},
					{["key"]="countWeek",["type"]="Signed32",["msg"]="本周完成任务的次数"},
					{["key"]="acceptTime",["type"]="Signed32",["msg"]="接受任务的时间"},
					{["key"]="faceChips",["type"]="Signed16",["msg"]="获取到面具的数量"},
					{["key"]="isGetFaceBox",["type"]="Signed16",["msg"]="任务宝箱是否领取"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="购买挑战次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
					{["key"]="blessing",["type"]="Signed32",["msg"]="选择的祝福种类，默认为0表示原始的未加倍，1表示选择第一种"},
				}
			},
		}
	},

	["110411"] = { --查看指定章节任务
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 36", --未包含协议头部长度
		["req_func"] = "req_mission_info_chapter",
		["resp_func"] = "resp_mission_info",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="任务类型(普通 5， 额外8， 困难12， 额外13, 每日产出副本14 ,外传15)"},
			{["key"]="chapter",["type"]="Signed32",["msg"]="章节"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MissionInfo
				["msg"]="任务信息列表",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务状态:0 初始状态,1 剧情可触发，但是还未触发,2 可以接任务的状态,3 已接未进入关卡,4 进入关卡，还未完成,5 已经完成"},
					{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
					{["key"]="countDay",["type"]="Signed32",["msg"]="当天完成任务的次数"},
					{["key"]="countWeek",["type"]="Signed32",["msg"]="本周完成任务的次数"},
					{["key"]="acceptTime",["type"]="Signed32",["msg"]="接受任务的时间"},
					{["key"]="faceChips",["type"]="Signed16",["msg"]="获取到面具的数量"},
					{["key"]="isGetFaceBox",["type"]="Signed16",["msg"]="任务宝箱是否领取"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="购买挑战次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
					{["key"]="blessing",["type"]="Signed32",["msg"]="选择的祝福种类，默认为0表示原始的未加倍，1表示选择第一种"},
				}
			},
		}
	},

	["110412"] = { --查看每个章节的新任务信息
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "28 + num * 13", --未包含协议头部长度
		["req_func"] = "req_new_mission_info",
		["resp_func"] = "resp_new_mission_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="copperFaces",["type"]="Signed32",["msg"]="铜面总数"},
			{["key"]="copperBox",["type"]="Signed32",["msg"]="铜箱子的开启的进度"},
			{["key"]="silverFaces",["type"]="Signed32",["msg"]="银面具总数"},
			{["key"]="silverBox",["type"]="Signed32",["msg"]="银面具的开启的进度"},
			{["key"]="goldFaces",["type"]="Signed32",["msg"]="金面具总数"},
			{["key"]="goldBox",["type"]="Signed32",["msg"]="金箱子的开启的进度"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--NewMissionInfo
				["msg"]="每个章节是否有新任务",
				["struct"]=
				{
					{["key"]="chapter",["type"]="Signed32",["msg"]="章节"},
					{["key"]="hasNewNormal",["type"]="Bool",["msg"]="普通难度有新任务"},
					{["key"]="hasNewHard",["type"]="Bool",["msg"]="困难难度有新任务"},
					{["key"]="hasNewHell",["type"]="Bool",["msg"]="普通难度有新任务"},
					{["key"]="hasNewExtr",["type"]="Bool",["msg"]="困难难度有新任务"},
					{["key"]="isAllCompletedNormal",["type"]="Bool",["msg"]="是否所有单人普通已经完成"},
					{["key"]="isAllCompletedHard",["type"]="Bool",["msg"]="是否所有单人困难已经完成"},
					{["key"]="isAllCompletedHell",["type"]="Bool",["msg"]="是否所有单人地狱已经完成"},
					{["key"]="isAllCompletedExtr",["type"]="Bool",["msg"]="是否所有单人额外已经完成"},
					{["key"]="isGetAllFaceChips",["type"]="Bool",["msg"]="是否所有面具已经被领取"},
				}
			},
		}
	},

	["110413"] = { --接受任务并进入关卡
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = "62 + num * 20", --未包含协议头部长度
		["req_func"] = "req_accept_and_enter",
		["resp_func"] = "resp_accept_and_enter",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
			{["key"]="helper",["type"]="Signed64",["msg"]="选择的助战者uid"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="maxCount",["type"]="Signed32",["msg"]="最多可完成次数(超过以后不能再获得角色经验)"},
			{["key"]="count",["type"]="Signed32",["msg"]="已经完成次数"},
			{["key"]="collectPage",["type"]="UTF8String[50]",["msg"]="书页信息"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["110414"] = { --查看指定ID任务
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 36, --未包含协议头部长度
		["req_func"] = "req_single_mission_info",
		["resp_func"] = "resp_single_mission_info",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="需要查看的任务id"},
		},
		["resp_args"] =
		{
			{
				["key"]="info",
				["type"]="struct",	--MissionInfo
				["msg"]="任务信息",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务状态:0 初始状态,1 剧情可触发，但是还未触发,2 可以接任务的状态,3 已接未进入关卡,4 进入关卡，还未完成,5 已经完成"},
					{["key"]="result",["type"]="Signed32",["msg"]="任务评价:0未进入关卡,1 Fail失败,2 Clear,3 Success,4 Perfect,5 Ace"},
					{["key"]="countDay",["type"]="Signed32",["msg"]="当天完成任务的次数"},
					{["key"]="countWeek",["type"]="Signed32",["msg"]="本周完成任务的次数"},
					{["key"]="acceptTime",["type"]="Signed32",["msg"]="接受任务的时间"},
					{["key"]="faceChips",["type"]="Signed16",["msg"]="获取到面具的数量"},
					{["key"]="isGetFaceBox",["type"]="Signed16",["msg"]="任务宝箱是否领取"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="购买挑战次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
					{["key"]="blessing",["type"]="Signed32",["msg"]="选择的祝福种类，默认为0表示原始的未加倍，1表示选择第一种"},
				}
			},
		}
	},

	["110415"] = { --领取秘币
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 24, --未包含协议头部长度
		["req_func"] = "req_coin_reward_new",
		["resp_func"] = "resp_coin_reward_new",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="coin",["type"]="Signed32",["msg"]="当前领取的秘币数量"},
			{["key"]="coinAll",["type"]="Signed32",["msg"]="领取后玩家身上的秘币数量"},
			{["key"]="nextCoinTime",["type"]="Signed32",["msg"]="下次领取秘币的时间"},
			{["key"]="coinInteval",["type"]="Signed32",["msg"]="领取秘币的间隔"},
			{["key"]="coinAdd",["type"]="Signed32",["msg"]="每次间隔可领取秘币数"},
			{["key"]="time",["type"]="Signed32",["msg"]="服务器当前时间"},
		}
	},

	["110416"] = { --获取已经完成的任务id
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 4", --未包含协议头部长度
		["req_func"] = "req_completed_list",
		["resp_func"] = "resp_completed_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="plotMission",["type"]="Signed32",["msg"]="玩家当前主线剧情任务id"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="任务id列表",
			},
		}
	},

	["110417"] = { --领取面具宝箱
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 5, --未包含协议头部长度
		["resp_socket_size"] = "9 + num * 8", --未包含协议头部长度
		["req_func"] = "req_get_face_box",
		["resp_func"] = "resp_get_face_box",
		["req_args"] =
		{
			{["key"]="boxType",["type"]="Signed8",["msg"]="宝箱类型：0. 关卡宝箱；1. 铜币宝箱；2.银宝箱；3.金宝箱"},
			{["key"]="faceBoxID",["type"]="Signed32",["msg"]="宝箱ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="faceBoxID",["type"]="Signed32",["msg"]="宝箱ID"},
			{["key"]="result",["type"]="Signed8",["msg"]="领取结果： 1：成功，其他为失败"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["110418"] = { --任务扫荡
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "24 + num * 8", --未包含协议头部长度
		["req_func"] = "req_mission_mop_up",
		["resp_func"] = "resp_mission_mop_up",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="获得的钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="获得的金币"},
			{["key"]="mana",["type"]="Signed32",["msg"]="获得的魔力值"},
			{["key"]="playerExp",["type"]="Signed32",["msg"]="玩家增加的验值"},
			{["key"]="heroExp",["type"]="Signed32",["msg"]="英雄增加的验值"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="奖励",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["110419"] = { --每日产出副本获取主界面信息
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 21", --未包含协议头部长度
		["req_func"] = "req_daily_dungeon_info",
		["resp_func"] = "resp_daily_dungeon_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DailyDungeon
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="chapter",["type"]="Signed32",["msg"]="配置id"},
					{["key"]="isOpen",["type"]="Bool",["msg"]="是否开启"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="结束的时间戳,只有付费开启的才有值，否则为0(s)"},
					{["key"]="count",["type"]="Signed32",["msg"]="当日已经完成的次数(如果是花钱解锁的任务，重新解锁时会重置)"},
					{["key"]="buyTimes",["type"]="Signed32",["msg"]="当日解锁次数(解锁获得的挑战次数读表(DailyDungeon.TimeLimit),一小时后重置"},
					{["key"]="price",["type"]="Signed32",["msg"]="解锁价格(钻石)"},
				}
			},
		}
	},

	["110420"] = { --完成剧情任务
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_plot_complete",
		["resp_func"] = "resp_plot_complete",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="剧情任务id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="newMissionId",["type"]="Signed32",["msg"]="新的剧情任务id, 若任务未完成返回原任务"},
			{["key"]="playerStatus",["type"]="Signed32",["msg"]="主线剧情任务的状态0初始, 2已对话副本未完成, 5全部完成"},
		}
	},

	["110421"] = { --每日产出副本 请求解锁
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_daily_dungeon_open",
		["resp_func"] = "resp_daily_dungeon_open",
		["req_args"] =
		{
			{["key"]="chapter",["type"]="Signed32",["msg"]="配置id"},
		},
		["resp_args"] =
		{
			{["key"]="chapter",["type"]="Signed32",["msg"]="配置id"},
			{["key"]="endTime",["type"]="Signed32",["msg"]="结束的时间戳(s)"},
		}
	},

	["110422"] = { --任务版:购买挑战次数
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_mission_buy_challenge_count",
		["resp_func"] = "resp_mission_buy_challenge_count",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
		["resp_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="buyTimes",["type"]="Signed32",["msg"]="已购买次数(乘上MissionData表的limitCount才是实际增加的挑战次数)"},
		}
	},

	["110423"] = { --选择奖励加倍
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_select_blessing",
		["resp_func"] = "resp_select_blessing",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="index",["type"]="Signed32",["msg"]="0取消祝福1~3表示选择第几个"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
		}
	},

	["110424"] = { --外传任务信息
		["module_name"] = "mission", --任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 2", --未包含协议头部长度
		["req_func"] = "req_biography_info",
		["resp_func"] = "resp_biography_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--BiographyInfo
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="openCond",["type"]="Signed8",["msg"]="对应CMissionData.openCond的判断结果(0:false 1:true)"},
					{["key"]="enterCond",["type"]="Signed8",["msg"]="对应CMissionData.enterCond的判断结果(0:false 1:true)"},
				}
			},
		}
	},

	["110501"] = { --查看派遣任务列表(等待返回)
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 112", --未包含协议头部长度
		["req_func"] = "req_dispatch_list",
		["resp_func"] = "resp_dispatch_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="refreshTime",["type"]="Signed32",["msg"]="下一次任务刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="已经刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DispatchInfo
				["msg"]="派遣任务列表",
				["struct"]=
				{
					{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务的id"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务的状态:0 未接, 1已接"},
					{["key"]="completeTime",["type"]="Signed32",["msg"]="完成任务的时间戳(秒)"},
					{["key"]="heroIdList",["type"]="UTF8String[100]",["msg"]="派遣的英雄ID列表(领取任务后才有值)：id1,id2"},
				}
			},
		}
	},

	["110502"] = { --刷新派遣任务列表(等待返回)
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 112", --未包含协议头部长度
		["req_func"] = "req_dispatch_refresh",
		["resp_func"] = "resp_dispatch_refresh",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="已经刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DispatchInfo
				["msg"]="派遣任务列表",
				["struct"]=
				{
					{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务的id"},
					{["key"]="status",["type"]="Signed32",["msg"]="任务的状态:0 未接, 1已接"},
					{["key"]="completeTime",["type"]="Signed32",["msg"]="完成任务的时间戳(秒)"},
					{["key"]="heroIdList",["type"]="UTF8String[100]",["msg"]="派遣的英雄ID列表(领取任务后才有值)：id1,id2"},
				}
			},
		}
	},

	["110503"] = { --领取派遣任务
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 104, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_dispatch_accept",
		["req_args"] =
		{
			{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务ID"},
			{["key"]="heroIdList",["type"]="UTF8String[100]",["msg"]="派遣的英雄ID列表：id1,id2"},
		},
	},

	["110504"] = { --领取已完成的任务奖励(等待返回)
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_dispatch_complete",
		["resp_func"] = "resp_dispatch_complete",
		["req_args"] =
		{
			{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务ID"},
		},
		["resp_args"] =
		{
		}
	},

	["110505"] = { --召回已派遣的英雄
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_dispatch_cancle",
		["req_args"] =
		{
			{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务ID"},
		},
	},

	["110506"] = { --立即完成
		["module_name"] = "dispatch", --派遣任务模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_quick_complete",
		["req_args"] =
		{
			{["key"]="dispatchId",["type"]="Signed32",["msg"]="派遣任务ID"},
		},
	},

	["110601"] = { --战斗中使用物品
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_battle_use",
		["resp_func"] = "resp_battle_use",
		["req_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求ID"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
		},
		["resp_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
		}
	},

	["110602"] = { --实时结算杀怪基础经验
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_battle_exp_base",
		["resp_func"] = "resp_battle_exp_base",
		["req_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{
				["key"]="monsterId",
				["type"]="struct",	--MonsterId
				["msg"]="杀死的怪物唯一id",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed8",["msg"]="0任务1箱子2防守"},
					{["key"]="id1",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id2",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id3",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="area",["type"]="Signed8",["msg"]="怪物所在区域"},
					{["key"]="groupId",["type"]="Signed8",["msg"]="怪物批次"},
					{["key"]="sortId",["type"]="Signed8",["msg"]="第几波"},
					{["key"]="seq",["type"]="Signed8",["msg"]="一波中第几个,从0开始"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
		}
	},

	["110606"] = { --购买复活药
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_buy_resu_item",
		["resp_func"] = "resp_buy_resu_item",
		["req_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
		},
		["resp_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
			{["key"]="count",["type"]="Signed32",["msg"]="购买后物品数量"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="购买后玩家的剩余灵核"},
			{["key"]="gold",["type"]="Signed32",["msg"]="购买后玩家的剩余金币"},
		}
	},

	["110607"] = { --TODO 结算所有的拾取金币及物品   已经改为实时掉落 见110612
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_battle_drop_all",
		["resp_func"] = "resp_battle_drop_all",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{
				["key"]="goodsList",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="掉落的怪物id(唯一id,不是模版id)",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果1成功0失败"},
		}
	},

	["110608"] = { --战斗中开启宝箱
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_battle_box_open",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="boxIdList",
				["type"]="Signed32[$num]",
				["msg"]="开启箱子id集合",
			},
		},
	},

	["110609"] = { --获取助战者列表
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "36 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 73", --未包含协议头部长度
		["req_func"] = "req_helper_list",
		["resp_func"] = "resp_helper_list",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于校验好友数据是否伪造"},
			{
				["key"]="friendList",
				["type"]="Signed64[$num]",
				["msg"]="好友列表",
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--HelperInfo
				["msg"]="助战者列表",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="昵称"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
					{["key"]="stage",["type"]="Signed32",["msg"]="英雄魂阶"},
					{["key"]="level",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="damage",["type"]="Signed32",["msg"]="输出能力"},
					{["key"]="viability",["type"]="Signed32",["msg"]="生存能力"},
					{["key"]="lastLogin",["type"]="Signed32",["msg"]="上次登录时间"},
					{["key"]="isFriend",["type"]="Signed8",["msg"]="是否好友:0否1是"},
				}
			},
		}
	},

	["110611"] = { --同步战斗数据
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "8 + num * 116", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_rsync_battle_data",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="heroChange",["type"]="Signed32",["msg"]="该局英雄切换次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--BattleData
				["msg"]="战斗数据列表[0]主英雄[1]副英雄",
				["struct"]=
				{
					{["key"]="damageReceived",["type"]="Signed32",["msg"]="承受伤害"},
					{["key"]="damageHit",["type"]="Signed32",["msg"]="输出伤害"},
					{["key"]="timesDefeated",["type"]="Signed32",["msg"]="战败次数(死亡次数)"},
					{["key"]="enemiesDefeated",["type"]="Signed32",["msg"]="消灭怪物数量"},
					{["key"]="skillIdList",["type"]="UTF8String[100]",["msg"]="该局使用技能列表{技能id:次数,技能id:次数}"},
				}
			},
		},
	},

	["110612"] = { --战斗实时掉落
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "16 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_battle_real_time_drop",
		["resp_func"] = "resp_battle_real_time_drop",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="seqId",["type"]="Signed32",["msg"]="请求识别seqId"},
			{
				["key"]="monsterId",
				["type"]="struct",	--MonsterId
				["msg"]="杀死的怪物唯一id",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed8",["msg"]="0任务1箱子2防守"},
					{["key"]="id1",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id2",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id3",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="area",["type"]="Signed8",["msg"]="怪物所在区域"},
					{["key"]="groupId",["type"]="Signed8",["msg"]="怪物批次"},
					{["key"]="sortId",["type"]="Signed8",["msg"]="第几波"},
					{["key"]="seq",["type"]="Signed8",["msg"]="一波中第几个,从0开始"},
				}
			},
			{
				["key"]="goodsList",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="掉落的物品ID集合",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="seqId",["type"]="Signed32",["msg"]="请求识别seqId"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果  1成功     0失败"},
		}
	},

	["110613"] = { --战斗连杀发放经验（连杀断掉之后请求）
		["module_name"] = "battle", --战斗(关卡)
		["socket_type"] = "game",
		["req_socket_size"] = "16 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_battle_multi_kill_exp",
		["resp_func"] = "resp_battle_multi_kill_exp",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="seqId",["type"]="Signed32",["msg"]="请求识别seqId"},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
			{["key"]="count",["type"]="Signed32",["msg"]="连杀数"},
			{
				["key"]="monsterIdList",
				["type"]="struct[$num]",	--MonsterId
				["msg"]="杀死的怪物id列表",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed8",["msg"]="0任务1箱子2防守"},
					{["key"]="id1",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id2",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="id3",["type"]="Signed8",["msg"]="id1,id2,id3按顺序3个字节合成一个整数用来表示各种id"},
					{["key"]="area",["type"]="Signed8",["msg"]="怪物所在区域"},
					{["key"]="groupId",["type"]="Signed8",["msg"]="怪物批次"},
					{["key"]="sortId",["type"]="Signed8",["msg"]="第几波"},
					{["key"]="seq",["type"]="Signed8",["msg"]="一波中第几个,从0开始"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="seqId",["type"]="Signed32",["msg"]="请求识别seqId"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果  1成功     0失败"},
		}
	},

	["110701"] = { --获得玩家参与博彩情况 (等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_draw_detail",
		["resp_func"] = "resp_draw_detail",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="goldFreeNum",["type"]="Signed16",["msg"]="已经使用的金币免费次数"},
			{["key"]="goldLastFreeDrawTime",["type"]="Signed32",["msg"]="上一次免费金币抽取时间（用于倒计时）"},
			{["key"]="diamondFreeNum",["type"]="Signed16",["msg"]="已经使用的钻石免费次数"},
			{["key"]="diamondLastFreeDrawTime",["type"]="Signed32",["msg"]="上一次免费钻石抽取时间（用于倒计时）"},
		}
	},

	["110702"] = { --获取金币抽奖的奖励列表 (等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_draw_gold_list",
		["req_args"] =
		{
		},
	},

	["110703"] = { --金币抽奖(等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_draw_gold",
		["resp_func"] = "resp_draw_gold",
		["req_args"] =
		{
			{["key"]="drawIndex",["type"]="Signed32",["msg"]="抽的卡牌index"},
		},
		["resp_args"] =
		{
			{["key"]="rewardId",["type"]="Signed32",["msg"]="抽中的奖励ID"},
		}
	},

	["110704"] = { --金币抽奖刷新(等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_draw_gold_refresh",
		["req_args"] =
		{
		},
	},

	["110705"] = { --钻石博彩猜大小(等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = "14 + num * 4", --未包含协议头部长度
		["req_func"] = "req_draw_diamond",
		["resp_func"] = "resp_draw_diamond",
		["req_args"] =
		{
			{["key"]="bigOrSmall",["type"]="Signed8",["msg"]="猜的大小"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="iswin",["type"]="Bool",["msg"]="是否赢了"},
			{["key"]="point",["type"]="UTF8String[5]",["msg"]="点数"},
			{["key"]="chipNum",["type"]="Signed32",["msg"]="获得筹码数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--RewardInfo
				["msg"]="奖励列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="记录ID"},
				}
			},
		}
	},

	["110706"] = { --选择物品
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_draw_choose",
		["req_args"] =
		{
			{["key"]="index",["type"]="Signed8",["msg"]="选中的物品位置"},
		},
	},

	["110707"] = { --获得物品兑换列表(等待返回)
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 5", --未包含协议头部长度
		["req_func"] = "req_draw_exchange_list",
		["resp_func"] = "resp_draw_exchange_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ExchangeItem
				["msg"]="兑换物品列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="记录ID"},
					{["key"]="canGet",["type"]="Signed8",["msg"]="是否可用,0不可用，1可用"},
				}
			},
		}
	},

	["110708"] = { --兑换
		["module_name"] = "draw", --博彩
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_draw_exchange",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="记录ID"},
		},
	},

	["110801"] = { --获得玩家成就列表(等待返回)
		["module_name"] = "achievement", --成就
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 9", --未包含协议头部长度
		["req_func"] = "req_achievement_list",
		["resp_func"] = "resp_achievement_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--Achievement
				["msg"]="成就列表",
				["struct"]=
				{
					{["key"]="achId",["type"]="Signed32",["msg"]="成就ID"},
					{["key"]="isOver",["type"]="Signed8",["msg"]="是否完成,0未完成，1已完成"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="进度"},
				}
			},
		}
	},

	["110802"] = { --领取成就奖励
		["module_name"] = "achievement", --成就
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 9", --未包含协议头部长度
		["req_func"] = "req_achievement_get_reward",
		["resp_func"] = "resp_achievement_list_after_reward",
		["req_args"] =
		{
			{["key"]="achId",["type"]="Signed32",["msg"]="成就ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--Achievement
				["msg"]="成就列表",
				["struct"]=
				{
					{["key"]="achId",["type"]="Signed32",["msg"]="成就ID"},
					{["key"]="isOver",["type"]="Signed8",["msg"]="是否完成,0未完成，1已完成"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="进度"},
				}
			},
		}
	},

	["110803"] = { --获得成就勋章
		["module_name"] = "achievement", --成就
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 13", --未包含协议头部长度
		["req_func"] = "req_honor_get_by_player",
		["resp_func"] = "resp_honor_get_by_player",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="honorInfos",
				["type"]="struct[$num]",	--AchievementHonorInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="typeId",["type"]="Signed32",["msg"]="成就链ID"},
					{["key"]="state",["type"]="Signed8",["msg"]="动画播放状态,1:没播放,0:已播放"},
					{["key"]="progress",["type"]="Signed16",["msg"]="进度"},
					{["key"]="total",["type"]="Signed16",["msg"]="总量"},
					{["key"]="time",["type"]="Signed32",["msg"]="完成时间"},
				}
			},
		}
	},

	["110901"] = { --查看邮件列表(等待返回)
		["module_name"] = "mail", --邮件
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 603", --未包含协议头部长度
		["req_func"] = "req_mail_list",
		["resp_func"] = "resp_mail_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MailInfo
				["msg"]="邮件列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="邮件的自增唯一id"},
					{["key"]="type",["type"]="Signed32",["msg"]="邮件类型:1系统邮件(程序自动发)，2后台邮件(GM发)，3保留作为玩家邮件"},
					{["key"]="senderId",["type"]="Signed64",["msg"]="发送者uid,保留给玩家邮件用, 系统邮件为0"},
					{["key"]="tag",["type"]="UTF8String[15]",["msg"]="显示在客户端左侧的标签文字"},
					{["key"]="sender",["type"]="UTF8String[30]",["msg"]="发送者名字"},
					{["key"]="title",["type"]="UTF8String[30]",["msg"]="邮件标题"},
					{["key"]="content",["type"]="UTF8String[400]",["msg"]="邮件内容"},
					{["key"]="award",["type"]="UTF8String[100]",["msg"]="附加奖励(json)"},
					{["key"]="status",["type"]="Signed32",["msg"]="邮件状态：0初始, 1已读, 2已接收附件,4已删除"},
					{["key"]="createTime",["type"]="Signed32",["msg"]="创建时间戳"},
				}
			},
		}
	},

	["110902"] = { --打开邮件
		["module_name"] = "mail", --邮件
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_mail_read",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="打开的邮件的自增唯一id"},
		},
	},

	["110903"] = { --接收邮件附件
		["module_name"] = "mail", --邮件
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_mail_accept",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="邮件的自增唯一id"},
		},
	},

	["110904"] = { --删除邮件
		["module_name"] = "mail", --邮件
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_mail_delete",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="邮件的自增唯一id"},
		},
	},

	["111001"] = { --设置竞技场主副英雄
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_hero_appoint_arena",
		["req_args"] =
		{
			{["key"]="firstHero",["type"]="Signed32",["msg"]="新主控英雄ID"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="新副控英雄ID, 0表示留空"},
		},
	},

	["111002"] = { --竞技场商店商品列表
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 20", --未包含协议头部长度
		["req_func"] = "req_arena_shop",
		["resp_func"] = "resp_arena_shop",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ArenaShopInfo
				["msg"]="商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="位置，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)：纹章"},
				}
			},
		}
	},

	["111003"] = { --刷新竞技场商店
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 20", --未包含协议头部长度
		["req_func"] = "req_arena_shop_refresh",
		["resp_func"] = "resp_arena_shop_refresh",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ArenaShopInfo
				["msg"]="商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="位置，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)：纹章"},
				}
			},
		}
	},

	["111004"] = { --纹章兑换物品
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_arena_shop_buy",
		["resp_func"] = "resp_arena_shop_buy",
		["req_args"] =
		{
			{["key"]="pos",["type"]="Signed32",["msg"]="商品位置，用来标识商店中的物品，相当于id"},
			{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID,用于验证商品数据是否已经过期"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="购买成功1，商品信息已经过期需要刷新0"},
		}
	},

	["111005"] = { --竞技场匹配
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_arena_match",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed8",["msg"]="战斗类型：0组队副本 1:1v1 2:2v2 3:3v3"},
		},
	},

	["111006"] = { --取消匹配
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_cancel_match",
		["req_args"] =
		{
		},
	},

	["111007"] = { --竞技场主面板获取信息
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 86, --未包含协议头部长度
		["req_func"] = "req_main_info",
		["resp_func"] = "resp_main_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="level",["type"]="Signed32",["msg"]="竞技场等级"},
			{["key"]="exp",["type"]="Signed32",["msg"]="竞技场经验"},
			{["key"]="point",["type"]="Signed32",["msg"]="竞技场点数"},
			{["key"]="simpleMatchTimes",["type"]="Signed32",["msg"]="快速匹配场次"},
			{["key"]="seasonId",["type"]="Signed32",["msg"]="当前赛季id,0表示从未打过排位"},
			{["key"]="rankTimes",["type"]="Signed32",["msg"]="当前赛季排位赛匹配场次"},
			{["key"]="stage",["type"]="Signed32",["msg"]="当前段位:0定位区1青铜三...具体看后端定义"},
			{["key"]="score",["type"]="Signed32",["msg"]="当前段位分"},
			{["key"]="score2",["type"]="Signed32",["msg"]="定位赛、晋级赛、降级赛的积分"},
			{["key"]="type",["type"]="Signed32",["msg"]="当前赛事类型TypeMatch:4定位赛5正赛6晋级赛7降级赛"},
			{["key"]="maxCount",["type"]="Signed32",["msg"]="当前赛事最大次数,正赛为0"},
			{["key"]="dayTimes",["type"]="Signed32",["msg"]="每日挑战次数(可累计到下一日)"},
			{["key"]="isGetReward",["type"]="Signed32",["msg"]="是否已经领取每日挑战的奖励,1:已领取 0:未领取"},
			{["key"]="record",["type"]="UTF8String[30]",["msg"]="当前赛事胜负记录1胜0负,正赛为空"},
			{["key"]="seasonEndTime",["type"]="Signed32",["msg"]="当前赛季结束的时间"},
		}
	},

	["111008"] = { --个人快速匹配面板获取信息
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "64 + num * 9", --未包含协议头部长度
		["req_func"] = "req_simple_arena_info",
		["resp_func"] = "resp_simple_arena_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="first",["type"]="Signed32",["msg"]="主英雄"},
			{["key"]="second",["type"]="Signed32",["msg"]="副英雄"},
			{["key"]="winTimes",["type"]="Signed32",["msg"]="胜利场次"},
			{["key"]="percent",["type"]="Signed32",["msg"]="胜率"},
			{["key"]="conWinTimes",["type"]="Signed32",["msg"]="最高连胜数"},
			{["key"]="killHeros",["type"]="Signed32",["msg"]="总击败数:击杀敌方英雄的数量"},
			{["key"]="averageOutput",["type"]="Signed32",["msg"]="场均输出"},
			{["key"]="maxOutputHeroId",["type"]="Signed32",["msg"]="最高输出英雄Id"},
			{["key"]="maxOutputNumber",["type"]="Signed64",["msg"]="最高输出对应的数值"},
			{["key"]="maxUsedHeroId",["type"]="Signed32",["msg"]="出场最多的英雄id"},
			{["key"]="maxUsedHeroTimes",["type"]="Signed32",["msg"]="出场最多的英雄场次"},
			{["key"]="maxWinHeroId",["type"]="Signed32",["msg"]="胜场最多的英雄id"},
			{["key"]="maxWinHeroTimes",["type"]="Signed32",["msg"]="出场最多的英雄的场次"},
			{["key"]="averageTime",["type"]="Signed32",["msg"]="每场平均时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SimpleArena
				["msg"]="对战记录",
				["struct"]=
				{
					{["key"]="fightTime",["type"]="Signed32",["msg"]="对战时间: 秒"},
					{["key"]="status",["type"]="Signed8",["msg"]="状态： 1成功， 0失败"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="该场主英雄，用来显示记录的头像"},
				}
			},
		}
	},

	["111009"] = { --领取pvp每日任务奖励
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_p_v_p_get_daily_reward",
		["resp_func"] = "resp_p_v_p_get_daily_reward",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果： 1成功， 0失败"},
		}
	},

	["111011"] = { --排位赛匹配
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_p_v_p_rank_match",
		["resp_func"] = "resp_rank_match",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：0之前已经在匹配,1表示成功正在匹配"},
		}
	},

	["111012"] = { --排位赛信息
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "64 + num * 9", --未包含协议头部长度
		["req_func"] = "req_p_v_p_rank_info",
		["resp_func"] = "resp_p_v_p_rank_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="first",["type"]="Signed32",["msg"]="主英雄"},
			{["key"]="second",["type"]="Signed32",["msg"]="副英雄"},
			{["key"]="winTimes",["type"]="Signed32",["msg"]="胜利场次"},
			{["key"]="percent",["type"]="Signed32",["msg"]="胜率"},
			{["key"]="conWinTimes",["type"]="Signed32",["msg"]="最高连胜数"},
			{["key"]="killHeros",["type"]="Signed32",["msg"]="总击败数:击杀敌方英雄的数量"},
			{["key"]="averageOutput",["type"]="Signed32",["msg"]="场均输出"},
			{["key"]="maxOutputHeroId",["type"]="Signed32",["msg"]="最高输出英雄Id"},
			{["key"]="maxOutputNumber",["type"]="Signed64",["msg"]="最高输出对应的数值"},
			{["key"]="maxUsedHeroId",["type"]="Signed32",["msg"]="出场最多的英雄id"},
			{["key"]="maxUsedHeroTimes",["type"]="Signed32",["msg"]="出场最多的英雄场次"},
			{["key"]="maxWinHeroId",["type"]="Signed32",["msg"]="胜场最多的英雄id"},
			{["key"]="maxWinHeroTimes",["type"]="Signed32",["msg"]="出场最多的英雄的场次"},
			{["key"]="averageTime",["type"]="Signed32",["msg"]="每场平均时间(s)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SimpleArena
				["msg"]="对战记录",
				["struct"]=
				{
					{["key"]="fightTime",["type"]="Signed32",["msg"]="对战时间: 秒"},
					{["key"]="status",["type"]="Signed8",["msg"]="状态： 1成功， 0失败"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="该场主英雄，用来显示记录的头像"},
				}
			},
		}
	},

	["111013"] = { --排位赛取消匹配
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_p_v_p_rank_cancel",
		["resp_func"] = "resp_rank_cancel",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：0之前已经在匹配,1表示成功正在匹配"},
		}
	},

	["111101"] = { --创建公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 33, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_create_guild",
		["req_args"] =
		{
			{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="icon",["type"]="Signed8",["msg"]="公会ICON"},
		},
	},

	["111102"] = { --兑换公会建造度(废弃建造度)
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 5, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_exchange_build_point",
		["req_args"] =
		{
			{["key"]="moneyType",["type"]="Signed8",["msg"]="兑换的货币"},
			{["key"]="money",["type"]="Signed32",["msg"]="兑换的货币数"},
		},
	},

	["111103"] = { --公会成员向公会捐献
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_member2_guild_donated",
		["req_args"] =
		{
			{["key"]="ingot",["type"]="Signed32",["msg"]="捐献的钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="捐献的金币"},
		},
	},

	["111201"] = { --使用英雄经验药水
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_use_exp_item",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="经验药水的物品ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="使用数量"},
		},
	},

	["111203"] = { --使用礼包
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_use_gift",
		["resp_func"] = "resp_use_gift",
		["req_args"] =
		{
			{["key"]="itemId",["type"]="Signed32",["msg"]="礼包ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="礼包物品列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["111205"] = { --分解道具
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 18, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_decompose_item",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed16",["msg"]="背包页签:1 装备;2 材料;3 消耗品"},
			{["key"]="outfitId",["type"]="Signed64",["msg"]="装备唯一id:普通道具,未鉴定的装备填0"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="道具ID:已鉴定的装备填0"},
			{["key"]="num",["type"]="Signed32",["msg"]="道具数量"},
		},
	},

	["111206"] = { --一键分解道具
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 22, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_decompose_item_onekey",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed16",["msg"]="背包页签:1 装备;2 材料;3 消耗品"},
			{["key"]="stage",["type"]="UTF8String[20]",["msg"]="品阶 格式:[1,2,3,4,5] 类型:1 劣质; 2 魔法;3 稀有; 4 传奇;5 套装"},
		},
	},

	["111207"] = { --使用魂阶药水
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 24, --未包含协议头部长度
		["req_func"] = "req_use_stage_item",
		["resp_func"] = "resp_use_stage_item",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="魂阶药水的物品ID"},
			{["key"]="isSure",["type"]="Signed32",["msg"]="二次确认使用该物品：第一次传0 请求使用，如果尚未未失效药水，会返回给你失败，第二次传大于0的值过来就会覆盖之前的药水效果"},
		},
		["resp_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="effectType",["type"]="Signed32",["msg"]="魂阶影响的类型, 1. 叠加魂阶；2. 指定魂阶"},
			{["key"]="effectStage",["type"]="Signed32",["msg"]="魂阶影响的等级，如果类型为叠加魂阶则新魂阶为 英雄魂阶 + effectStage，如果是指定魂阶则直接取effectStage"},
			{["key"]="continueype",["type"]="Signed32",["msg"]="魂阶药水的失效类型： 1. 表示按时间跑；2. 表示按进入副本的次数算"},
			{["key"]="endTime",["type"]="Signed32",["msg"]="魂阶药水的失效时间、或者可以进入副本使用的次数"},
			{["key"]="errCode",["type"]="Signed32",["msg"]="等于1时表示当前还有魂阶药水为过期，需要二次确认是否覆盖使用，二次确认时，需要传递参数C2SS4UseStageItem的isSure = 1"},
		}
	},

	["111208"] = { --使用魂阶药水
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_stage_item_expire",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="heroIdList",
				["type"]="Signed32[$num]",
				["msg"]="英雄ID 列表",
			},
		},
	},

	["111209"] = { --使用掉宝药水
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 24", --未包含协议头部长度
		["req_func"] = "req_use_drop_item",
		["resp_func"] = "resp_use_drop_item",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="药水的物品ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DropEff
				["msg"]="效果列表",
				["struct"]=
				{
					{["key"]="groupId",["type"]="Signed32",["msg"]="组id，相同组的效果相同，时间叠加"},
					{["key"]="atlas",["type"]="Signed32",["msg"]="图集id"},
					{["key"]="icon",["type"]="Signed32",["msg"]="显示的图标"},
					{["key"]="rate",["type"]="Signed32",["msg"]="掉率x%"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="效果到期时间"},
					{["key"]="sumTime",["type"]="Signed32",["msg"]="效果总时间"},
				}
			},
		}
	},

	["111210"] = { --查看掉宝药水效果
		["module_name"] = "item", --使用物品
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_drop_item_info",
		["req_args"] =
		{
		},
	},

	["111301"] = { --地下城：获得关卡列表（等待返回）
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 6", --未包含协议头部长度
		["req_func"] = "req_d_x_c_mission_list",
		["resp_func"] = "resp_d_x_c_mission_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefTime",["type"]="Signed32",["msg"]="下一次免费刷新的时间"},
			{["key"]="refCount",["type"]="Signed32",["msg"]="已经付费刷新的次数（免费那次不计）"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MissionStatus
				["msg"]="关卡信息",
				["struct"]=
				{
					{["key"]="missionProgress",["type"]="Signed8",["msg"]="章节进度：1~n表示最大可以打第几个节点，0表示还不可以打, 错误数据"},
					{["key"]="phase",["type"]="Signed8",["msg"]="章节"},
					{["key"]="flag",["type"]="Signed32",["msg"]="节点完成的标记,第一个bit表示mission=1是否完成"},
				}
			},
		}
	},

	["111302"] = { --地下城：获得节点列表（等待返回）
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 2, --未包含协议头部长度
		["resp_socket_size"] = "5 + num * 9", --未包含协议头部长度
		["req_func"] = "req_node_list",
		["resp_func"] = "resp_node_list",
		["req_args"] =
		{
			{["key"]="phase",["type"]="Signed8",["msg"]="章节"},
			{["key"]="mission",["type"]="Signed8",["msg"]="层号"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="getRewardOr",["type"]="Signed8",["msg"]="是否领取了宝箱"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--NodeInfo
				["msg"]="节点信息",
				["struct"]=
				{
					{["key"]="nodeId",["type"]="Signed32",["msg"]="节点ID"},
					{["key"]="pass",["type"]="Signed8",["msg"]="是否通关"},
					{["key"]="nodeMonsterId",["type"]="Signed32",["msg"]="出怪ID"},
				}
			},
		}
	},

	["111303"] = { --地下城：获得英雄列表（等待返回）
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 28", --未包含协议头部长度
		["req_func"] = "req_d_x_c_hero_list",
		["resp_func"] = "resp_d_x_c_hero_list",
		["req_args"] =
		{
			{["key"]="nodeId",["type"]="Signed32",["msg"]="关卡ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DXCHeroInfo
				["msg"]="英雄信息",
				["struct"]=
				{
					{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄配置ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="hp",["type"]="Signed32",["msg"]="血量"},
					{["key"]="mp",["type"]="Signed32",["msg"]="魔法值"},
					{["key"]="anger",["type"]="Signed32",["msg"]="怒气"},
					{["key"]="power",["type"]="Signed32",["msg"]="体力"},
					{["key"]="status",["type"]="Signed32",["msg"]="状态(英雄处于的节点ID)"},
				}
			},
		}
	},

	["111304"] = { --地下城：出战（等待返回）
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = "58 + num * 20", --未包含协议头部长度
		["req_func"] = "req_go_to_battle",
		["resp_func"] = "resp_go_to_battle",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID1"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID2,如果没有填0"},
			{["key"]="nodeId",["type"]="Signed32",["msg"]="关卡ID"},
			{["key"]="helper",["type"]="Signed64",["msg"]="选择的助战者uid"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nodeId",["type"]="Signed32",["msg"]="节点ID"},
			{["key"]="collectPage",["type"]="UTF8String[50]",["msg"]="书页信息"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["111305"] = { --地下城：英雄阵亡
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_hero_dea",
		["resp_func"] = "resp_hero_dea",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["111306"] = { --地下城：退出节点
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_exit_node",
		["resp_func"] = "resp_exit_node",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["111307"] = { --地下城：通关节点
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 76, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_pass_node",
		["resp_func"] = "resp_pass_node",
		["req_args"] =
		{
			{["key"]="hero1Id",["type"]="Signed32",["msg"]="英雄1ID"},
			{["key"]="hero1Parm",["type"]="UTF8String[32]",["msg"]="hero1剩余参数，格式：HP,MP,Anger,power"},
			{["key"]="hero2Id",["type"]="Signed32",["msg"]="英雄2ID,单英雄出战为0"},
			{["key"]="hero2Parm",["type"]="UTF8String[32]",["msg"]="hero2剩余参数，格式：HP,MP,Anger,power,单英雄出战为'' "},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["111308"] = { --地下城：放弃关卡
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_give_up_mission",
		["resp_func"] = "resp_give_up_mission",
		["req_args"] =
		{
			{["key"]="phase",["type"]="Signed32",["msg"]="章节号"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["111310"] = { --地下城：打开宝箱（等待返回）
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_open_box",
		["resp_func"] = "resp_open_box",
		["req_args"] =
		{
			{["key"]="nodeId",["type"]="Signed32",["msg"]="节点ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="goldCount",["type"]="Signed32",["msg"]="金币数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["111312"] = { --地下城：获得地下城关卡奖励
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_get_d_x_c_mission_reward",
		["resp_func"] = "resp_send_d_x_c_mission_reward",
		["req_args"] =
		{
			{["key"]="bossNodeId",["type"]="Signed32",["msg"]="需要获得 的boss关卡的ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["111313"] = { --地下城：返回主城
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_return_to_city",
		["req_args"] =
		{
		},
	},

	["111314"] = { --地下城：刷新
		["module_name"] = "underground", --地下城
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_d_x_c_reset",
		["resp_func"] = "resp_d_x_c_reset",
		["req_args"] =
		{
			{["key"]="isFree",["type"]="Signed32",["msg"]="是否免费刷新 1：是 0：否"},
		},
		["resp_args"] =
		{
			{["key"]="refCount",["type"]="Signed32",["msg"]="已经付费刷新的次数（免费那次不计）"},
			{["key"]="nextFreeRefTime",["type"]="Signed32",["msg"]="下一次免费刷新的时间"},
		}
	},

	["111401"] = { --每日任务：获得玩家每日任务列表(等待返回)
		["module_name"] = "dailytask", --每日任务
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 9", --未包含协议头部长度
		["req_func"] = "req_daily_task_list",
		["resp_func"] = "resp_daily_task_list",
		["req_args"] =
		{
			{["key"]="tab",["type"]="Signed32",["msg"]="标签页:对应DailyTask表的tab"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DailyTask
				["msg"]="任务列表",
				["struct"]=
				{
					{["key"]="taskId",["type"]="Signed32",["msg"]="任务ID"},
					{["key"]="isOver",["type"]="Signed8",["msg"]="是否完成,0未完成，1已完成"},
					{["key"]="num",["type"]="Signed32",["msg"]="完成数量"},
				}
			},
		}
	},

	["111402"] = { --每日任务：领取每日任务奖励
		["module_name"] = "dailytask", --每日任务
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_daily_task_get_reward",
		["resp_func"] = "resp_daily_task_get_reward",
		["req_args"] =
		{
			{["key"]="taskId",["type"]="Signed32",["msg"]="成就ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DailyTaskOverInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="taskId",["type"]="Signed32",["msg"]="成就ID"},
					{["key"]="parm",["type"]="Signed32",["msg"]="参数"},
				}
			},
		}
	},

	["111403"] = { --每日任务：获取玩家任务点(等待返回)
		["module_name"] = "dailytask", --每日任务
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 4", --未包含协议头部长度
		["req_func"] = "req_get_task_point",
		["resp_func"] = "resp_get_task_point",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="taskPoint",["type"]="Signed32",["msg"]="任务点"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TaskPointRewardInfo
				["msg"]="已经领取的任务点奖励",
				["struct"]=
				{
					{["key"]="rewardId",["type"]="Signed32",["msg"]="奖励id，对应TaskPointReward表_id"},
				}
			},
		}
	},

	["111404"] = { --每日任务：领取任务点奖励(等待返回)
		["module_name"] = "dailytask", --每日任务
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_task_point_get_reward",
		["resp_func"] = "resp_task_point_get_reward",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="任务点奖励唯一ID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：0失败,1成功"},
		}
	},

	["111501"] = { --查看兑换商店
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 4", --未包含协议头部长度
		["req_func"] = "req_challenge_shop_view",
		["resp_func"] = "resp_challenge_shop_view",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="layer",["type"]="Signed32",["msg"]="玩家当前在混沌之渊所处层数"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="字段未有注解",
			},
		}
	},

	["111502"] = { --刷新兑换商店
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 4", --未包含协议头部长度
		["req_func"] = "req_challenge_shop_refresh",
		["resp_func"] = "resp_challenge_shop_refresh",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="layer",["type"]="Signed32",["msg"]="玩家当前在混沌之渊所处层数"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="字段未有注解",
			},
		}
	},

	["111503"] = { --兑换物品
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_challenge_shop_buy",
		["resp_func"] = "resp_challenge_shop_buy",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="商品id(非物品id)"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="购买成功1"},
		}
	},

	["111504"] = { --查看自己的混沌之渊相关信息
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_info",
		["req_args"] =
		{
		},
	},

	["111505"] = { --购买混沌之渊出战次数
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_buy_challenge_count",
		["req_args"] =
		{
		},
	},

	["111506"] = { --获取混沌之渊挑战目标
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_target",
		["req_args"] =
		{
		},
	},

	["111507"] = { --编辑防守阵型
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 70, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_team_def",
		["req_args"] =
		{
			{["key"]="teamInfo",["type"]="UTF8String[70]",["msg"]="英雄id列表(0为空)"},
		},
	},

	["111509"] = { --出战
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 83, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_attack",
		["req_args"] =
		{
			{["key"]="teamInfo",["type"]="UTF8String[70]",["msg"]="英雄id列表(0为空)"},
			{["key"]="layer",["type"]="Signed32",["msg"]="目标层数"},
			{["key"]="uid",["type"]="Signed64",["msg"]="目标的uid, 若是npc则无用"},
			{["key"]="isPlayer",["type"]="Bool",["msg"]="目标是否为NPC(用于验证数据是否已经改变)"},
		},
	},

	["111601"] = { --获取收集列表
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 13", --未包含协议头部长度
		["req_func"] = "req_collect_list",
		["resp_func"] = "resp_collect_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--CollectInfo
				["msg"]="收集列表",
				["struct"]=
				{
					{["key"]="phase",["type"]="Signed32",["msg"]="章节"},
					{["key"]="isOver",["type"]="Signed8",["msg"]="是否完成,0未完成，1已完成"},
					{["key"]="progress",["type"]="Signed64",["msg"]="完成进度"},
				}
			},
		}
	},

	["111602"] = { --领取章节奖励
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_collect_get_reward",
		["req_args"] =
		{
			{["key"]="phase",["type"]="Signed32",["msg"]="章节"},
		},
	},

	["111603"] = { --获得收集物品
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_get_collect_item",
		["req_args"] =
		{
			{["key"]="collectId",["type"]="Signed32",["msg"]="收集Id"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="场景ID"},
		},
	},

	["111604"] = { --图鉴：装备图鉴数据
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 4", --未包含协议头部长度
		["req_func"] = "req_outfit_collection_data",
		["resp_func"] = "resp_outfit_collection_data",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="1:传奇装备  2:套装装备"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="type",["type"]="Signed32",["msg"]="1:传奇装备  2:套装装备"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="列表(物品id)",
			},
		}
	},

	["111605"] = { --图鉴：领取图鉴奖励
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_collection_award",
		["resp_func"] = "resp_collection_award",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="1:传奇装备  2:套装装备"},
			{["key"]="awardId",["type"]="Signed32",["msg"]="type=1，填OutfitCollectionAward.id,type=2,填outfitSet.id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果 1:成功"},
		}
	},

	["111650"] = { --触发防守
		["module_name"] = "defend", --防守
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 20", --未包含协议头部长度
		["req_func"] = "req_defence_trigger",
		["resp_func"] = "resp_defence_trigger",
		["req_args"] =
		{
			{["key"]="defenceId",["type"]="Signed32",["msg"]="防守id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="defenceId",["type"]="Signed32",["msg"]="防守id"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="防守刷怪掉落信息",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["111701"] = { --查看黑暗之境信息
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "18 + num * 12", --未包含协议头部长度
		["req_func"] = "req_diablo_info",
		["resp_func"] = "resp_diablo_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="level",["type"]="Signed32",["msg"]="钥匙的等级，相当于层数"},
			{["key"]="isBigKey",["type"]="Bool",["msg"]="用宝石升级过钥匙"},
			{["key"]="canAddKey",["type"]="Bool",["msg"]="可以领钥匙"},
			{["key"]="choiceMin",["type"]="Signed32",["msg"]="可选最小层数"},
			{["key"]="choiceMax",["type"]="Signed32",["msg"]="可选最大层数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DiabloHero
				["msg"]="已经战斗过的英雄，保存的状态",
				["struct"]=
				{
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
					{["key"]="hp",["type"]="Signed32",["msg"]="剩余hp"},
					{["key"]="mp",["type"]="Signed32",["msg"]="剩余mp"},
				}
			},
		}
	},

	["111702"] = { --开启黑暗之境
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_start",
		["req_args"] =
		{
		},
	},

	["111703"] = { --领取钥匙
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_add_key",
		["req_args"] =
		{
		},
	},

	["111704"] = { --升级钥匙
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_upgrade_key",
		["req_args"] =
		{
		},
	},

	["111705"] = { --进入战斗场景
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = "13 + num * 20", --未包含协议头部长度
		["req_func"] = "req_diablo_enter",
		["resp_func"] = "resp_diablo_enter",
		["req_args"] =
		{
			{["key"]="level",["type"]="Signed32",["msg"]="进入层数"},
			{["key"]="firstHero",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="helper",["type"]="Signed64",["msg"]="选择的助战者uid"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="level",["type"]="Signed32",["msg"]="钥匙等级，即层数"},
			{["key"]="isBigKey",["type"]="Signed8",["msg"]="大钥匙"},
			{["key"]="bossId",["type"]="Signed32",["msg"]="最终大boss(不用了)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DiabloMonster
				["msg"]="怪物掉落数据, 包括大boss",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed32",["msg"]="MonsterFactory.id(冗余)"},
					{["key"]="index",["type"]="Signed32",["msg"]="在生成的怪物池里面的index, 用来标识相同monsterId的怪物(冗余)"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["111706"] = { --杀怪
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_diablo_kill",
		["resp_func"] = "resp_diablo_kill",
		["req_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
			{["key"]="monsterId",["type"]="Signed32",["msg"]="被杀死的怪物id(怪物工厂id)"},
		},
		["resp_args"] =
		{
			{["key"]="reqId",["type"]="Signed32",["msg"]="请求识别id"},
		}
	},

	["111707"] = { --胜利
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 28, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_diablo_success",
		["resp_func"] = "resp_diablo_success",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="主英雄"},
			{["key"]="hp1",["type"]="Signed32",["msg"]="剩余血量"},
			{["key"]="mp1",["type"]="Signed32",["msg"]="剩余mp"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="副英雄"},
			{["key"]="hp2",["type"]="Signed32",["msg"]="剩余血量"},
			{["key"]="mp2",["type"]="Signed32",["msg"]="剩余mp"},
			{["key"]="multiKillExp",["type"]="Signed32",["msg"]="连击经验奖励"},
		},
		["resp_args"] =
		{
			{["key"]="level",["type"]="Signed32",["msg"]="当前层数"},
		}
	},

	["111708"] = { --失败
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_fail",
		["req_args"] =
		{
		},
	},

	["111709"] = { --放弃
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_diablo_drop",
		["resp_func"] = "resp_diablo_drop",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["111710"] = { --换英雄继续
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_restart",
		["req_args"] =
		{
			{["key"]="firstHero",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="英雄ID"},
		},
	},

	["111711"] = { --超时
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = 24, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_diablo_battle_time_limit",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="主英雄"},
			{["key"]="hp1",["type"]="Signed32",["msg"]="剩余血量"},
			{["key"]="mp1",["type"]="Signed32",["msg"]="剩余mp"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="副英雄"},
			{["key"]="hp2",["type"]="Signed32",["msg"]="剩余血量"},
			{["key"]="mp2",["type"]="Signed32",["msg"]="剩余mp"},
		},
	},

	["111712"] = { --奖励
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_diablo_reward",
		["resp_func"] = "resp_diablo_reward",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="indexList",
				["type"]="Signed8[$num]",
				["msg"]="掉落的怪物在怪物列表中的位置，大boss为-1",
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="获得的物品",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["111713"] = { --战斗中开启宝箱
		["module_name"] = "diablo", --黑暗之境
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_battle_box_open",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="boxIdList",
				["type"]="Signed32[$num]",
				["msg"]="开启箱子id集合",
			},
		},
	},

	["111801"] = { --查看亲密度
		["module_name"] = "intimacy", --亲密度
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 17, --未包含协议头部长度
		["req_func"] = "req_intimacy_info",
		["resp_func"] = "resp_intimacy_info",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID"},
		},
		["resp_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="level",["type"]="Signed32",["msg"]="亲密度等级"},
			{["key"]="intimacy",["type"]="Signed32",["msg"]="当前等级的亲密度"},
			{["key"]="isRewarded",["type"]="Bool",["msg"]="亲密度满，且已经领取奖励(亲密度满级才会为true)"},
		}
	},

	["111802"] = { --增加亲密度
		["module_name"] = "intimacy", --亲密度
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_intimacy_add",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 0表示对话"},
			{["key"]="count",["type"]="Signed32",["msg"]="物品数量"},
		},
	},

	["111803"] = { --领取亲密度奖励
		["module_name"] = "intimacy", --亲密度
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_intimacy_reward",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID"},
		},
	},

	["111901"] = { --挑战
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_oracle_enter",
		["req_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="pos",["type"]="Signed32",["msg"]="位置:1,2,3"},
			{["key"]="relation",["type"]="Signed32",["msg"]="关系类型:0自己, 1好友, 2陌生人"},
		},
	},

	["111902"] = { --结算
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 9, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_oracle_battle_end",
		["req_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="isWin",["type"]="Bool",["msg"]="战斗胜利"},
		},
	},

	["112001"] = { --公会商店 : 浏览商店
		["module_name"] = "guild", --公会商店
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "20 + num * 20", --未包含协议头部长度
		["req_func"] = "req_sell_guild_shop_data_list",
		["resp_func"] = "resp_sell_guild_shop_data_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次自动刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{["key"]="lastHeroSellTime",["type"]="Signed32",["msg"]="上一次英雄出去售卖的时间（秒数）"},
			{["key"]="shoplevel",["type"]="Signed32",["msg"]="公会商店等级"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildSellDataInfo
				["msg"]="商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)"},
				}
			},
		}
	},

	["112002"] = { --公会商店 : 商店刷新
		["module_name"] = "guild", --公会商店
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 20", --未包含协议头部长度
		["req_func"] = "req_guild_shop_refresh",
		["resp_func"] = "resp_guild_shop_refresh",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="nextRefreshTime",["type"]="Signed32",["msg"]="下一次刷新的时间戳(秒)"},
			{["key"]="refreshCount",["type"]="Signed32",["msg"]="今天已刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildSellDataInfo
				["msg"]="刷新后的商品列表",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
					{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品模版ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="可购买数量, 0表示已售出"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格(总)"},
				}
			},
		}
	},

	["112003"] = { --公会商店 : 购买
		["module_name"] = "guild", --公会商店
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_guild_shop_buy",
		["resp_func"] = "resp_guild_shop_buy",
		["req_args"] =
		{
			{["key"]="pos",["type"]="Signed32",["msg"]="生成商品信息时的顺序，用来标识商店中的物品，相当于id"},
			{["key"]="sellDataId",["type"]="Signed32",["msg"]="商品的模版ID,用于验证商品数据是否已经过期"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="购买成功1，商品信息已经过期需要刷新0"},
		}
	},

	["112101"] = { --公会任务 : 获取任务列表
		["module_name"] = "guild", --公会任务
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 5", --未包含协议头部长度
		["req_func"] = "req_guild_mission_list",
		["resp_func"] = "resp_guild_mission_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hasbattleNum",["type"]="Signed32",["msg"]="已使用挑战次数"},
			{["key"]="totalbattleNum",["type"]="Signed32",["msg"]="总共可使用挑战次数"},
			{["key"]="hasRefNum",["type"]="Signed32",["msg"]="已使用刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildMissionInfo
				["msg"]="任务列表",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="公会任务ID"},
					{["key"]="isComplete",["type"]="Bool",["msg"]="完成情况：true完成，false未完成"},
				}
			},
		}
	},

	["112102"] = { --公会任务 : 刷新公会任务列表
		["module_name"] = "guild", --公会任务
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 5", --未包含协议头部长度
		["req_func"] = "req_refresh_guild_mission_list",
		["resp_func"] = "resp_refresh_guild_mission_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildMissionInfo
				["msg"]="任务列表",
				["struct"]=
				{
					{["key"]="missionId",["type"]="Signed32",["msg"]="公会任务ID"},
					{["key"]="isComplete",["type"]="Bool",["msg"]="完成情况：true完成，false未完成"},
				}
			},
		}
	},

	["112103"] = { --公会任务 : 接受公会任务
		["module_name"] = "guild", --公会任务
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 20", --未包含协议头部长度
		["req_func"] = "req_guild_mission_accept",
		["resp_func"] = "resp_guild_mission_accept",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["112104"] = { --公会任务 : 完成公会任务
		["module_name"] = "guild", --公会任务
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_guild_mission_complete",
		["req_args"] =
		{
			{["key"]="status",["type"]="Signed32",["msg"]="结果：0失败（放弃）, 1成功"},
		},
	},

	["112201"] = { --Boss血量同步
		["module_name"] = "guild", --公会boss
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_sync_boss_hurt",
		["req_args"] =
		{
			{["key"]="guildId",["type"]="Signed32",["msg"]="公会ID"},
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍ID"},
			{["key"]="bossId",["type"]="Signed32",["msg"]="BossID"},
			{["key"]="hurtValue",["type"]="Signed32",["msg"]="boss伤害"},
			{["key"]="hpValue",["type"]="Signed32",["msg"]="玩家当前血量"},
		},
	},

	["112202"] = { --boss技能同步
		["module_name"] = "guild", --公会boss
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_sync_guild_boss_skill",
		["req_args"] =
		{
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍ID"},
			{["key"]="bossSkillId",["type"]="Signed32",["msg"]="怪物的技能Id"},
		},
	},

	["112203"] = { --英雄技能同步
		["module_name"] = "guild", --公会boss
		["socket_type"] = "game",
		["req_socket_size"] = 24, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_sync_hero_skill",
		["req_args"] =
		{
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能Id"},
			{["key"]="time",["type"]="Signed32",["msg"]="施放的时间戳"},
			{["key"]="posX",["type"]="Signed32",["msg"]="posX"},
			{["key"]="posY",["type"]="Signed32",["msg"]="posY"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="posZ"},
		},
	},

	["112204"] = { --挑战公会BOSS的时间到了
		["module_name"] = "guild", --公会boss
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_guild_boss_time_over",
		["req_args"] =
		{
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍ID"},
		},
	},

	["112301"] = { --装备：装备列表
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 762", --未包含协议头部长度
		["req_func"] = "req_outfit_list",
		["resp_func"] = "resp_outfit_list",
		["req_args"] =
		{
			{["key"]="curPage",["type"]="Signed32",["msg"]="取第几页的数据"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="pageAll",["type"]="Signed32",["msg"]="全部装备的页数"},
			{["key"]="page",["type"]="Signed32",["msg"]="当前第几页[0,n)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OutfitInfo
				["msg"]="装备列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112302"] = { --装备：鉴定装备
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = "16 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_identify",
		["resp_func"] = "resp_identify",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
			{["key"]="outfitId",["type"]="Signed64",["msg"]="装备唯一id"},
			{
				["key"]="selectAttrList",
				["type"]="Signed32[$num]",
				["msg"]="选择属性列表 :数组下标为属性池池序号，数值表示该池的属性位置。例indexArr[0]=1，indexArr[1]=2 表示选择第一个池的第二条属性，第二个池的第三条属性",
			},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备唯一id",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112304"] = { --装备：穿上装备
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_put_on_outfit",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="装备到哪个英雄"},
		},
	},

	["112305"] = { --装备：卸下装备
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_take_off_outfit",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
		},
	},

	["112307"] = { --装备：装备出售
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_sell_outfit",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id，用于未鉴定的装备，已鉴定的填0"},
		},
	},

	["112308"] = { --装备：打造装备
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_compose",
		["resp_func"] = "resp_compose",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备数据",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112309"] = { --装备：装备强化
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 9, --未包含协议头部长度
		["resp_socket_size"] = 1, --未包含协议头部长度
		["req_func"] = "req_outfit_upgrade",
		["resp_func"] = "resp_outfit_upgrade",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="isForce",["type"]="Signed8",["msg"]="是否使用钻石强制成功"},
		},
		["resp_args"] =
		{
			{["key"]="isSuccess",["type"]="Bool",["msg"]="强化结果"},
		}
	},

	["112310"] = { --装备：套装打造
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_set_compose",
		["resp_func"] = "resp_set_compose",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="setId",["type"]="Signed32",["msg"]="套装id"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备数据",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112311"] = { --装备：装备赌博
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_outfit_lottery",
		["resp_func"] = "resp_outfit_lottery",
		["req_args"] =
		{
			{["key"]="part",["type"]="Signed32",["msg"]="装备类型：1武器2头盔..."},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112312"] = { --装备：装备填充值
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = "12 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 774, --未包含协议头部长度
		["req_func"] = "req_outfit_fill_value",
		["resp_func"] = "resp_outfit_fill_value",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{
				["key"]="goodsList",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果 成功：1 ，成功且暴击 2"},
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112313"] = { --装备：装备打孔
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 774, --未包含协议头部长度
		["req_func"] = "req_outfit_punched",
		["resp_func"] = "resp_outfit_punched",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
		},
		["resp_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="result",["type"]="Signed32",["msg"]="结果 成功：1 ，失败：0"},
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112314"] = { --装备：镶嵌宝石
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 766, --未包含协议头部长度
		["req_func"] = "req_outfit_insert_gem",
		["resp_func"] = "resp_outfit_insert_gem",
		["req_args"] =
		{
			{["key"]="oufitId",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="gemId",["type"]="Signed32",["msg"]="物品id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果 成功：1 ，失败：0"},
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112315"] = { --装备：拆除宝石/母矿
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 774, --未包含协议头部长度
		["req_func"] = "req_outfit_remove_gem",
		["resp_func"] = "resp_outfit_remove_gem",
		["req_args"] =
		{
			{["key"]="oufitId",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="gemId",["type"]="Signed64",["msg"]="后端发给前端的装备信息里的宝石id(long型)"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果 成功：1 ，失败：0"},
			{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112316"] = { --装备：宝石合成
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_gem_combine",
		["resp_func"] = "resp_gem_combine",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="宝石的物品id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果 成功：1 ，失败：0"},
		}
	},

	["112320"] = { --装备：母矿：母矿列表
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 69", --未包含协议头部长度
		["req_func"] = "req_gem_container_list",
		["resp_func"] = "resp_gem_container_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GemContainerInfo
				["msg"]="母矿列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["112321"] = { --装备：母矿：鉴定
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 69, --未包含协议头部长度
		["req_func"] = "req_gem_container_identify",
		["resp_func"] = "resp_gem_container_identify",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--GemContainerInfo
				["msg"]="母矿数据",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["112322"] = { --装备：母矿：储存小宝石
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 70, --未包含协议头部长度
		["req_func"] = "req_gem_container_save",
		["resp_func"] = "resp_gem_container_save",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
			{["key"]="gemGoodsId",["type"]="Signed32",["msg"]="小宝石物品id(GoodsData._id)"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed8",["msg"]="结果 1.覆盖同类宝石，2.原宝石数量已达上限，随机替换  3.扩展孔位成功 4.扩展孔位失败，随机替换"},
			{
				["key"]="data",
				["type"]="struct",	--GemContainerInfo
				["msg"]="母矿数据",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["112323"] = { --装备：母矿：融合
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 69, --未包含协议头部长度
		["req_func"] = "req_gem_container_mix",
		["resp_func"] = "resp_gem_container_mix",
		["req_args"] =
		{
			{["key"]="id1",["type"]="Signed64",["msg"]="母矿1(母矿唯一id)"},
			{["key"]="id2",["type"]="Signed64",["msg"]="母矿2(母矿唯一id)"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--GemContainerInfo
				["msg"]="母矿数据",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["112324"] = { --装备：母矿：镶嵌
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_gem_container_insert",
		["resp_func"] = "resp_gem_container_insert",
		["req_args"] =
		{
			{["key"]="oufitId",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="gemId",["type"]="Signed64",["msg"]="母矿唯一id"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112330"] = { --装备：属性重铸
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = "12 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_outfit_recast",
		["resp_func"] = "resp_outfit_recast",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="outfitId",["type"]="Signed64",["msg"]="装备唯一id(未鉴定的装备不能重铸)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OutfitRecastInfo
				["msg"]="属性列表",
				["struct"]=
				{
					{["key"]="index",["type"]="Signed32",["msg"]="该条属性在随机属性列表(OutfitInfo.randAttr)里的下标(只有随机属性才能重铸)"},
					{["key"]="lock",["type"]="Signed32",["msg"]="是否锁定(1:是 0:否)"},
				}
			},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112331"] = { --装备：强化等级继承
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_outfit_upgrade_inherit",
		["resp_func"] = "resp_outfit_upgrade_inherit",
		["req_args"] =
		{
			{["key"]="formOutfit",["type"]="Signed64",["msg"]="传承装备唯一id"},
			{["key"]="toOutfit",["type"]="Signed64",["msg"]="继承装备唯一id"},
		},
		["resp_args"] =
		{
			{["key"]="upgradeLevel",["type"]="Signed32",["msg"]="继承后装备的强化等级"},
		}
	},

	["112332"] = { --装备：魔法槽位填充
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["req_func"] = "req_outfit_magic_slot_fill",
		["resp_func"] = "resp_outfit_magic_slot_fill",
		["req_args"] =
		{
			{["key"]="outfitId",["type"]="Signed64",["msg"]="装备唯一id"},
			{["key"]="itemId",["type"]="Signed32",["msg"]="填充物 物品id=OutfitSlotFiller._id"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112333"] = { --装备：魔法槽位回溯
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_outfit_magic_slot_recovery",
		["resp_func"] = "resp_outfit_magic_slot_recovery",
		["req_args"] =
		{
			{["key"]="outfitId",["type"]="Signed64",["msg"]="装备唯一id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["112334"] = { --装备：魔法槽位填充物合成
		["module_name"] = "outfit", --(新)装备系统
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_outfit_magic_slot_filler_compose",
		["resp_func"] = "resp_outfit_magic_slot_filler_compose",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="填充物物品id列表",
			},
		},
		["resp_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="合成结果(物品id)"},
		}
	},

	["112401"] = { --登录奖励列表
		["module_name"] = "activity", --活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 5", --未包含协议头部长度
		["req_func"] = "req_login_reward_list",
		["resp_func"] = "resp_login_reward_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--loginReward
				["msg"]="登录奖励列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="活动ID"},
					{["key"]="status",["type"]="Signed8",["msg"]="活动状态"},
				}
			},
		}
	},

	["112402"] = { --领取登录奖励
		["module_name"] = "activity", --活动
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_get_login_reward",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="唯一ID"},
		},
	},

	["112403"] = { --活动列表
		["module_name"] = "activity", --活动
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 12", --未包含协议头部长度
		["req_func"] = "req_activity_list",
		["resp_func"] = "resp_activity_list",
		["req_args"] =
		{
			{["key"]="aType",["type"]="Signed32",["msg"]="活动类型"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="atype",["type"]="Signed32",["msg"]="活动类型"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--Activity
				["msg"]="活动列表",
				["struct"]=
				{
					{["key"]="aid",["type"]="Signed32",["msg"]="活动ID"},
					{["key"]="value",["type"]="Signed32",["msg"]="活动临界值"},
					{["key"]="status",["type"]="Signed32",["msg"]="活动状态:0 初始状态,1 不可领取 2 可领取但未领取 3 已经领取"},
				}
			},
		}
	},

	["112404"] = { --领取活动奖励
		["module_name"] = "activity", --活动
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_get_activity_reward",
		["req_args"] =
		{
			{["key"]="aid",["type"]="Signed32",["msg"]="活动ID"},
			{["key"]="value",["type"]="Signed32",["msg"]="活动临界值"},
		},
	},

	["112501"] = { --查看游戏进度
		["module_name"] = "gameschedule", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_game_schedule",
		["req_args"] =
		{
		},
	},

	["112502"] = { --查看陌生人
		["module_name"] = "gameschedule", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 614, --未包含协议头部长度
		["req_func"] = "req_target_schedule",
		["resp_func"] = "resp_target_schedule",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
		},
		["resp_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="角色名"},
			{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
			{["key"]="icon",["type"]="Signed32",["msg"]="角色头像"},
			{["key"]="iconFrame",["type"]="Signed32",["msg"]="头像外框"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
			{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
			{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
			{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
			{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
			{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
			{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
			{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
			{["key"]="pvpWin",["type"]="Signed32",["msg"]="快速匹配胜利场次"},
			{["key"]="rankStage",["type"]="Signed32",["msg"]="排位赛段位"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="工会id"},
			{["key"]="guildname",["type"]="UTF8String[32]",["msg"]="工会名称"},
			{["key"]="heroList",["type"]="UTF8String[150]",["msg"]="英雄id列表(id1,id2..)"},
			{["key"]="mainHero",["type"]="Signed32",["msg"]="主英雄"},
			{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="装备图鉴(传奇装备+套装装备的总件数)"},
			{["key"]="outfitCollectRank",["type"]="Signed32",["msg"]="装备图鉴全收藏排行榜名次"},
		}
	},

	["112503"] = { --查看他人英雄
		["module_name"] = "gameschedule", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = "325 + num * 8", --未包含协议头部长度
		["req_func"] = "req_target_hero",
		["resp_func"] = "resp_target_hero",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="uid",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="stage",["type"]="Signed32",["msg"]="英雄魂阶"},
			{["key"]="level",["type"]="Signed32",["msg"]="英雄等级"},
			{["key"]="practiceExp",["type"]="Signed32",["msg"]="英雄熟练度"},
			{["key"]="mainHero",["type"]="Signed8",["msg"]="1主控英雄0否"},
			{["key"]="damage",["type"]="Signed32",["msg"]="输出能力"},
			{["key"]="viability",["type"]="Signed32",["msg"]="生存能力"},
			{["key"]="weaponId",["type"]="Signed32",["msg"]="武器的物品id"},
			{["key"]="runelevel",["type"]="Signed32",["msg"]="符文等级(取最低的一个)"},
			{["key"]="skillLevel",["type"]="UTF8String[15]",["msg"]="skill1,skill2,skill3,skill4,skill5"},
			{["key"]="branchList",["type"]="UTF8String[15]",["msg"]="branch1,branch2,branch3,branch4,branch5"},
			{["key"]="outfitList",["type"]="UTF8String[150]",["msg"]="装备列表(装备物品id,用逗号隔开)"},
			{["key"]="activateFashionList",["type"]="UTF8String[100]",["msg"]="当前激活时装列表(时装物品id,用逗号隔开)"},
			{
				["key"]="list",
				["type"]="Signed64[$num]",
				["msg"]="属性列表,每一个long的高32位表示TypeAttr, 低32位表示attrValue",
			},
		}
	},

	["112504"] = { --查看他人英雄装备
		["module_name"] = "gameschedule", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 762", --未包含协议头部长度
		["req_func"] = "req_target_outfit",
		["resp_func"] = "resp_target_outfit",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="uid",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OutfitInfo
				["msg"]="装备列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["112505"] = { --查看他人英雄母矿
		["module_name"] = "gameschedule", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 69", --未包含协议头部长度
		["req_func"] = "req_target_gem_container",
		["resp_func"] = "resp_target_gem_container",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="uid",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GemContainerInfo
				["msg"]="母矿列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["112601"] = { --查看信息板数据
		["module_name"] = "board", --信息板
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 65, --未包含协议头部长度
		["req_func"] = "req_board_data",
		["resp_func"] = "resp_board_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="navigationType",["type"]="Signed8",["msg"]="导航的类型, 0表示无导航"},
			{["key"]="navigationId",["type"]="Signed32",["msg"]="导航的id如每日成就的id,0表示不需要,如混沌之渊"},
			{["key"]="trackDailyTask",["type"]="UTF8String[30]",["msg"]="跟踪的每日成就:id1,id2..."},
			{["key"]="trackOpActivity",["type"]="UTF8String[30]",["msg"]="预留:跟踪的运营活动:id1,id2..."},
		}
	},

	["112602"] = { --修改信息板跟踪的项
		["module_name"] = "board", --信息板
		["socket_type"] = "game",
		["req_socket_size"] = 6, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_edit_track",
		["req_args"] =
		{
			{["key"]="opType",["type"]="Signed8",["msg"]="操作:0:删除, 1:增加"},
			{["key"]="type",["type"]="Signed8",["msg"]="2:每日任务, 3:预留为运营活动"},
			{["key"]="id",["type"]="Signed32",["msg"]="id"},
		},
	},

	["112603"] = { --设置导航
		["module_name"] = "board", --信息板
		["socket_type"] = "game",
		["req_socket_size"] = 5, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_set_navigation",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed8",["msg"]="导航的类型"},
			{["key"]="id",["type"]="Signed32",["msg"]="导航的id"},
		},
	},

	["112604"] = { --获取各种类型的数据
		["module_name"] = "board", --信息板
		["socket_type"] = "game",
		["req_socket_size"] = 50, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_refresh_data",
		["req_args"] =
		{
			{["key"]="typeList",["type"]="UTF8String[50]",["msg"]="type1,type2..."},
		},
	},

	["112701"] = { --
		["module_name"] = "gm", --客户端GM功能
		["socket_type"] = "game",
		["req_socket_size"] = 260, --未包含协议头部长度
		["resp_socket_size"] = 260, --未包含协议头部长度
		["req_func"] = "req_g_m_func",
		["resp_func"] = "resp_g_m_func_result",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型"},
			{["key"]="parm",["type"]="UTF8String[256]",["msg"]="参数"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型，0为不成功"},
			{["key"]="parm",["type"]="UTF8String[256]",["msg"]="参数"},
		}
	},

	["112801"] = { --赠送秘币的记录
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_give_coin_list",
		["resp_func"] = "resp_give_coin_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="maxCount",["type"]="Signed32",["msg"]="每天最多可以赠送次数"},
			{
				["key"]="list",
				["type"]="Signed64[$num]",
				["msg"]="好友uid列表",
			},
		}
	},

	["112802"] = { --赠送秘币
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 80, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["req_func"] = "req_give_coin",
		["resp_func"] = "resp_give_coin",
		["req_args"] =
		{
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="验证参数"},
		},
		["resp_args"] =
		{
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		}
	},

	["112803"] = { --赠送的记录
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 8", --未包含协议头部长度
		["req_func"] = "req_give_list",
		["resp_func"] = "resp_give_list",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="赠送的类型：1秘币2混沌之渊3黑暗之境4派遣5失落遗迹"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="type",["type"]="Signed32",["msg"]="赠送的类型：1秘币2混沌之渊3黑暗之境4派遣5失落遗迹"},
			{["key"]="maxCount",["type"]="Signed32",["msg"]="每天最多可以赠送次数(或下次可赠送派遣的时间)"},
			{
				["key"]="list",
				["type"]="Signed64[$num]",
				["msg"]="好友uid列表",
			},
		}
	},

	["112804"] = { --普通赠送
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 84, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_normal_give",
		["resp_func"] = "resp_normal_give",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="赠送的类型：1秘币2混沌之渊3黑暗之境4派遣5失落遗迹"},
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="验证参数"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="赠送的类型：1秘币2混沌之渊3黑暗之境4派遣5失落遗迹"},
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		}
	},

	["112805"] = { --赠送派遣
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 80, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_dispatch_give",
		["req_args"] =
		{
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="验证参数"},
		},
	},

	["112806"] = { --赠送派遣的记录
		["module_name"] = "friend", --好友赠送
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 12", --未包含协议头部长度
		["req_func"] = "req_dispatch_give_list",
		["resp_func"] = "resp_dispatch_give_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DispatchGiveInfo
				["msg"]="好友uid列表",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="好友uid"},
					{["key"]="nextTime",["type"]="Signed32",["msg"]="下次赠送的时间"},
				}
			},
		}
	},

	["112901"] = { --签到获取信息
		["module_name"] = "signin", --签到活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "5 + num * 12", --未包含协议头部长度
		["req_func"] = "req_signin_info",
		["resp_func"] = "resp_signin_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="display",["type"]="Signed8",["msg"]="0不显示1显示"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SigninInfo
				["msg"]="签到活动信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="签到活动ID"},
					{["key"]="days",["type"]="Signed32",["msg"]="签到天数"},
					{["key"]="isSignin",["type"]="Signed32",["msg"]="当天是否已经签到"},
				}
			},
		}
	},

	["112902"] = { --签到
		["module_name"] = "signin", --签到活动
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_signin",
		["resp_func"] = "resp_signin",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="签到活动id"},
		},
		["resp_args"] =
		{
			{["key"]="state",["type"]="Signed32",["msg"]="0 为成功，其他为失败"},
		}
	},

	["113001"] = { --30日签到获取信息
		["module_name"] = "monthsignin", --签到模块，常驻活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 13, --未包含协议头部长度
		["req_func"] = "req_month_signin_info",
		["resp_func"] = "resp_month_signin_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="hadSignin",["type"]="Signed32",["msg"]="已经签到的次数"},
			{["key"]="IsSign",["type"]="Signed32",["msg"]="当天是否签到, 1：表示已經签到"},
			{["key"]="cost",["type"]="Signed32",["msg"]="已经补签过次数"},
			{["key"]="display",["type"]="Signed8",["msg"]="0不显示1显示"},
		}
	},

	["113002"] = { --30日签到
		["module_name"] = "monthsignin", --签到模块，常驻活动
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_month_signin",
		["resp_func"] = "resp_month_signin",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型：1. 补签，2. 当天签到"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型：1. 补签，2. 当天签到"},
		}
	},

	["113101"] = { --猎魔录获取信息
		["module_name"] = "huntingmagic", --猎魔录
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 12", --未包含协议头部长度
		["req_func"] = "req_hunting_magic_info",
		["resp_func"] = "resp_hunting_magic_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--HuntingMagicInfo
				["msg"]="收集列表",
				["struct"]=
				{
					{["key"]="hID",["type"]="Signed32",["msg"]="猎魔录ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="Num 数量"},
					{["key"]="reward",["type"]="Signed32",["msg"]="领奖进度"},
				}
			},
		}
	},

	["113102"] = { --猎魔录获取奖励
		["module_name"] = "huntingmagic", --猎魔录
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_hunting_magic_reward",
		["resp_func"] = "resp_hunting_magic_reward",
		["req_args"] =
		{
			{["key"]="rewardID",["type"]="Signed32",["msg"]="猎魔录ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="奖励列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["113217"] = { --查看任务首通信息
		["module_name"] = "worldteam", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 452", --未包含协议头部长度
		["req_func"] = "req_first_pass_data",
		["resp_func"] = "resp_first_pass_data",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TeamMemberData
				["msg"]="各队伍(包括1,2,3,4人通关，但不一定全有)的队员信息",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="队伍人数"},
					{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
					{["key"]="passTime",["type"]="Signed32",["msg"]="通关时间"},
					{["key"]="uid",["type"]="Signed64",["msg"]="队员uid"},
					{["key"]="isLeader",["type"]="Signed32",["msg"]="是否为队长1是0否"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="队员名字"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconFrame",["type"]="Signed32",["msg"]="队员头像外框"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像URL"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
					{["key"]="firstHero",["type"]="Signed32",["msg"]="队员主英雄id"},
					{["key"]="firstLevel",["type"]="Signed32",["msg"]="队员主英雄等级"},
					{["key"]="firstStage",["type"]="Signed32",["msg"]="队员主英雄魂阶"},
					{["key"]="secondHero",["type"]="Signed32",["msg"]="队员副英雄id"},
					{["key"]="secondLevel",["type"]="Signed32",["msg"]="队员副英雄等级"},
					{["key"]="secondStage",["type"]="Signed32",["msg"]="队员副英雄魂阶"},
				}
			},
		}
	},

	["114001"] = { --请求玩家头像或头像外框列表
		["module_name"] = "icon", --玩家头像与头像外框显示
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 4", --未包含协议头部长度
		["req_func"] = "req_get_player_icon",
		["resp_func"] = "resp_get_player_icon",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="border",["type"]="Signed32",["msg"]="玩家解锁的头像和头像外框数据的下标分界"},
			{
				["key"]="iconList",
				["type"]="Signed32[$num]",
				["msg"]="玩家解锁的头像和头像外框",
			},
		}
	},

	["114002"] = { --请求玩家头像或头像外框列表
		["module_name"] = "icon", --玩家头像与头像外框显示
		["socket_type"] = "game",
		["req_socket_size"] = 5, --未包含协议头部长度
		["resp_socket_size"] = 1, --未包含协议头部长度
		["req_func"] = "req_change_player_icon",
		["resp_func"] = "resp_change_player_icon",
		["req_args"] =
		{
			{["key"]="icon",["type"]="Signed32",["msg"]="变更使用的头像或外框"},
			{["key"]="isIcon",["type"]="Bool",["msg"]="标志位，标识该操作是变更头像还是变更头像外框，true:为头像,false:头像外框"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Bool",["msg"]="标志位，标识该操作是变更是否成功，true:为成功,false:失败"},
		}
	},

	["114101"] = { --商城：请求商城信息
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 121", --未包含协议头部长度
		["req_func"] = "req_store_get_info",
		["resp_func"] = "resp_store_get_info",
		["req_args"] =
		{
			{["key"]="area",["type"]="Signed32",["msg"]="商店信息"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="refreshTimes",["type"]="Signed32",["msg"]="刷新次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--StoreItem
				["msg"]="商店信息",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="货架Id"},
					{["key"]="itemId",["type"]="Signed32",["msg"]="商品Id: 对应： storeCommondity中的ID（当itemId=0时表示这是特殊货架，一个货架有多个商品，需要通过114107获取商品信息）"},
					{["key"]="buyNumber",["type"]="Signed32",["msg"]="已经购买过的数量"},
					{["key"]="productId",["type"]="UTF8String[40]",["msg"]="第三方平台(苹果)商品ID"},
					{["key"]="firstChargeReward",["type"]="Signed8",["msg"]="是否有首充奖励， 1:是，0：否"},
					{["key"]="sell",["type"]="UTF8String[40]",["msg"]="售货 对应： storeCommondity中的sell"},
					{["key"]="sellLimit",["type"]="Signed32",["msg"]="购买限制/存货 对应： storeCommondity中的sellLimit"},
					{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格： 计算后的价格*100(前端拿到之后要/100)"},
					{["key"]="display",["type"]="Signed32",["msg"]="基础显示    对应：storeCommondity中的display"},
					{["key"]="rewardType",["type"]="Signed32",["msg"]="首充额外奖励的货币类型(或物品id)"},
					{["key"]="rewardValue",["type"]="Signed32",["msg"]="首充额外奖励数量"},
					{["key"]="rewardDisplay",["type"]="Signed32",["msg"]="首充特殊显示     对应： storeCommondity中的RewardDisplay"},
				}
			},
		}
	},

	["114102"] = { --商城：购买道具
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = "12 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 1, --未包含协议头部长度
		["req_func"] = "req_store_buy",
		["resp_func"] = "resp_store_buy",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="id",["type"]="Signed32",["msg"]="商柜Id"},
			{["key"]="buyCount",["type"]="Signed32",["msg"]="购买数量(当货架类型是(0:固定货架)才能够批量购买，才需要设置此值)"},
			{
				["key"]="commodityList",
				["type"]="Signed32[$num]",
				["msg"]="商品Id列表(当货架类型是(2:选择货架)时才需要设置此值)",
			},
		},
		["resp_args"] =
		{
			{["key"]="resuly",["type"]="Signed8",["msg"]="结果 :0 表示成功 ,1:表示该商品已经过去了，需要重新刷新"},
		}
	},

	["114103"] = { --商城：刷新商柜
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_store_reflush",
		["resp_func"] = "resp_store_reflush",
		["req_args"] =
		{
			{["key"]="area",["type"]="Signed32",["msg"]="区域"},
		},
		["resp_args"] =
		{
			{["key"]="storeCommonDityid",["type"]="Signed32",["msg"]="字段未有注解"},
		}
	},

	["114104"] = { --商城：小功能付费接口
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_store_buy_other",
		["resp_func"] = "resp_store_buy_other",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="付费类型：1. 钻石兑金币；2. 钻石开背包格子；3.钻石兑换秘币；4.钻石购买红紋黑耀（黑暗之境的钥匙）"},
			{["key"]="number",["type"]="Signed32",["msg"]="兑换数量：例如： 钻石兑金币 这个值发的是金币的数量"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="付费类型：1. 钻石兑金币；2. 钻石开背包格子；3.钻石兑换秘币；4.钻石购买红紋黑耀（黑暗之境的钥匙）；5. 混沌之渊的挑战次数 "},
		}
	},

	["114105"] = { --商城：获取礼品信息
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_store_gift_info",
		["resp_func"] = "resp_store_gift_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextTime",["type"]="Signed32",["msg"]="下次领取时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="礼品列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["114106"] = { --商城：领取礼品
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_store_get_gift",
		["resp_func"] = "resp_store_gift_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="nextTime",["type"]="Signed32",["msg"]="下次领取时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GiftItem
				["msg"]="礼品列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["114107"] = { --商城：获取选择货架内容
		["module_name"] = "store", --商城模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 64", --未包含协议头部长度
		["req_func"] = "req_store_selection_shlef",
		["resp_func"] = "resp_store_selection_shlef",
		["req_args"] =
		{
			{["key"]="shlefId",["type"]="Signed32",["msg"]="货架id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="shlefId",["type"]="Signed32",["msg"]="货架id,StoreShlef.id"},
			{
				["key"]="commodityList",
				["type"]="struct[$num]",	--StoreItem_selectShlef
				["msg"]="商品列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="商品Id: 对应： storeCommondity中的ID"},
					{["key"]="buyNumber",["type"]="Signed32",["msg"]="已经购买过的数量"},
					{["key"]="sell",["type"]="UTF8String[40]",["msg"]="售货 对应： storeCommondity中的sell"},
					{["key"]="sellLimit",["type"]="Signed32",["msg"]="购买限制/存货 对应： storeCommondity中的sellLimit"},
					{["key"]="moneyType",["type"]="Signed32",["msg"]="货币类型"},
					{["key"]="price",["type"]="Signed32",["msg"]="价格： 计算后的价格*100(前端拿到之后要/100)"},
					{["key"]="display",["type"]="Signed32",["msg"]="基础显示    对应：storeCommondity中的display"},
				}
			},
		}
	},

	["114201"] = { --抽奖宝箱：查看抽奖宝箱
		["module_name"] = "chest", --抽奖宝箱
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 20", --未包含协议头部长度
		["req_func"] = "req_chest_shop_info",
		["resp_func"] = "resp_chest_shop_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChestData
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="group",["type"]="Signed32",["msg"]="宝箱group"},
					{["key"]="num",["type"]="Signed32",["msg"]="拥有数量 (弃用，宝箱不再入背包)"},
					{["key"]="freeTotal",["type"]="Signed32",["msg"]="当日总共可领取免费宝箱数量"},
					{["key"]="freeDay",["type"]="Signed32",["msg"]="当日已经领取免费宝箱数量"},
					{["key"]="nextTime",["type"]="Signed32",["msg"]="下次领取免费宝箱时间(假如当日领取完毕，则返回的是系统刷新时间),-1表示没有免费宝箱可领取"},
				}
			},
		}
	},

	["114202"] = { --抽奖宝箱：购买抽奖宝箱
		["module_name"] = "chest", --抽奖宝箱
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_buy_chest",
		["resp_func"] = "resp_buy_chest",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="唯一id，对应chestshop表_id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：0失败,1成功"},
		}
	},

	["114204"] = { --抽奖宝箱：领取免费宝箱
		["module_name"] = "chest", --抽奖宝箱
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_get_free_chest",
		["resp_func"] = "resp_get_free_chest",
		["req_args"] =
		{
			{["key"]="group",["type"]="Signed32",["msg"]="宝箱组(ChestShop.group)"},
		},
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--ChestData
				["msg"]="宝箱组信息",
				["struct"]=
				{
					{["key"]="group",["type"]="Signed32",["msg"]="宝箱group"},
					{["key"]="num",["type"]="Signed32",["msg"]="拥有数量 (弃用，宝箱不再入背包)"},
					{["key"]="freeTotal",["type"]="Signed32",["msg"]="当日总共可领取免费宝箱数量"},
					{["key"]="freeDay",["type"]="Signed32",["msg"]="当日已经领取免费宝箱数量"},
					{["key"]="nextTime",["type"]="Signed32",["msg"]="下次领取免费宝箱时间(假如当日领取完毕，则返回的是系统刷新时间),-1表示没有免费宝箱可领取"},
				}
			},
		}
	},

	["114304"] = { --苹果充值：@Deprecated
		["module_name"] = "charge", --充值模块
		["socket_type"] = "game",
		["req_socket_size"] = "4 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_i_o_s_charge",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="receipt",
				["type"]="Signed8[$num]",
				["msg"]="购买成功后，苹果给前端的收据6756",
			},
		},
	},

	["114305"] = { --谷歌充值：@Deprecated
		["module_name"] = "charge", --充值模块
		["socket_type"] = "game",
		["req_socket_size"] = 1158, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_g_g_charge",
		["req_args"] =
		{
			{["key"]="productId",["type"]="UTF8String[50]",["msg"]="产品ID:exampleSku"},
			{["key"]="orderId",["type"]="UTF8String[50]",["msg"]="订单ID:exampleSku"},
			{["key"]="developerPayload",["type"]="UTF8String[50]",["msg"]="自定义ID"},
			{["key"]="purchaseTime",["type"]="Signed64",["msg"]="购买成功后,Google向客户端返回的purchaseTime"},
			{["key"]="purchaseToken",["type"]="UTF8String[1000]",["msg"]="购买成功后,Google向客户端返回的Token值"},
		},
	},

	["114306"] = { --苹果充值
		["module_name"] = "charge", --充值模块
		["socket_type"] = "game",
		["req_socket_size"] = "41 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_i_o_s_charge_new",
		["resp_func"] = "resp_charge_respone",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="myOrderId",["type"]="Signed32",["msg"]="自定义订单ID"},
			{["key"]="storeCommodityId",["type"]="Signed32",["msg"]="配置商品ID"},
			{["key"]="currency",["type"]="UTF8String[9]",["msg"]="货币类型"},
			{["key"]="money",["type"]="UTF8String[20]",["msg"]="支付金额"},
			{
				["key"]="receipt",
				["type"]="Signed8[$num]",
				["msg"]="购买成功后，苹果给前端的收据6756",
			},
		},
		["resp_args"] =
		{
			{["key"]="myOrderId",["type"]="Signed32",["msg"]="自定义订单ID"},
			{["key"]="status",["type"]="Signed32",["msg"]="0成功或其他 状态码"},
		}
	},

	["114307"] = { --谷歌充值 响应共用114306：SS2C4ChargeRespone
		["module_name"] = "charge", --充值模块
		["socket_type"] = "game",
		["req_socket_size"] = 1195, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_g_g_charge_new",
		["req_args"] =
		{
			{["key"]="myOrderId",["type"]="Signed32",["msg"]="自定义订单ID"},
			{["key"]="storeCommodityId",["type"]="Signed32",["msg"]="配置商品ID"},
			{["key"]="currency",["type"]="UTF8String[9]",["msg"]="货币类型"},
			{["key"]="money",["type"]="UTF8String[20]",["msg"]="支付金额"},
			{["key"]="productId",["type"]="UTF8String[50]",["msg"]="产品ID:exampleSku"},
			{["key"]="orderId",["type"]="UTF8String[50]",["msg"]="订单ID:exampleSku"},
			{["key"]="developerPayload",["type"]="UTF8String[50]",["msg"]="自定义ID"},
			{["key"]="purchaseTime",["type"]="Signed64",["msg"]="购买成功后,Google向客户端返回的purchaseTime"},
			{["key"]="purchaseToken",["type"]="UTF8String[1000]",["msg"]="购买成功后,Google向客户端返回的Token值"},
		},
	},

	["114401"] = { --特权卡：查看玩家拥有的特权卡
		["module_name"] = "privilege", --特权卡
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 16", --未包含协议头部长度
		["req_func"] = "req_privilege_card_info",
		["resp_func"] = "resp_privilege_card_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PrivilegeCard
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="唯一id"},
					{["key"]="buyTime",["type"]="Signed32",["msg"]="购买时间（若卡升级，此购买时间即升级时间）"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="到期时间"},
					{["key"]="rewardCount",["type"]="Signed32",["msg"]="待领数量:注意 ！！可累计（可升级）的特权卡：返回的是可领取奖励的“个数”（例钻石10个，则返回10），不可累计的特权卡：返回的是可领取奖励的“次数”（因为不可累计，所以最大只可能返回1）"},
				}
			},
		}
	},

	["114402"] = { --特权卡：领取特权卡奖励
		["module_name"] = "privilege", --特权卡
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_get_privilege_card_reward",
		["resp_func"] = "resp_get_privilege_card_reward",
		["req_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="唯一id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="领取数量:注意！！可累计（可升级）的特权卡：返回的是可领取奖励的“个数”（例钻石10个，则返回10），不可累计的特权卡：返回的是可领取奖励的“次数”（因为不可累计，所以最大只可能返回1）"},
		}
	},

	["114501"] = { --运营活动：查看正在进行的运营活动
		["module_name"] = "operate", --运营活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 268", --未包含协议头部长度
		["req_func"] = "req_operate_act_info",
		["resp_func"] = "resp_operate_act_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OperateActInfo
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="operateId",["type"]="Signed64",["msg"]="运营活动唯一id"},
					{["key"]="activityId",["type"]="Signed32",["msg"]="活动编号"},
					{["key"]="beginTime",["type"]="Signed32",["msg"]="活动开始时间 "},
					{["key"]="endTime",["type"]="Signed32",["msg"]="活动结束时间  "},
					{["key"]="beginTime_ui",["type"]="Signed32",["msg"]="UI显示活动开始时间 "},
					{["key"]="endTime_ui",["type"]="Signed32",["msg"]="UI显示活动结束时间 "},
					{
						["key"]="process",
						["type"]="struct[20]",	--OperateActSeqInfo
						["msg"]="此活动的每个档次完成情况(结构体)",
						["struct"]=
						{
							{["key"]="templeteId",["type"]="Signed32",["msg"]="运营活动表_id"},
							{["key"]="num",["type"]="Signed32",["msg"]="完成数量*100"},
							{["key"]="status",["type"]="Signed32",["msg"]="活动状态0未完成，1已完成可领奖，2已完成已领奖"},
						}
					},
				}
			},
		}
	},

	["114502"] = { --运营活动：领取奖励
		["module_name"] = "operate", --运营活动
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 252, --未包含协议头部长度
		["req_func"] = "req_operate_act_get_reward",
		["resp_func"] = "resp_operate_act_get_reward",
		["req_args"] =
		{
			{["key"]="operateId",["type"]="Signed64",["msg"]="运营活动唯一id"},
			{["key"]="templeteId",["type"]="Signed32",["msg"]="运营活动表_id"},
		},
		["resp_args"] =
		{
			{["key"]="operateId",["type"]="Signed64",["msg"]="运营活动唯一id"},
			{["key"]="templeteId",["type"]="Signed32",["msg"]="领奖的那个档次的运营活动表_id"},
			{
				["key"]="process",
				["type"]="struct[20]",	--OperateActSeqInfo
				["msg"]="此活动的每个档次完成情况(结构体)",
				["struct"]=
				{
					{["key"]="templeteId",["type"]="Signed32",["msg"]="运营活动表_id"},
					{["key"]="num",["type"]="Signed32",["msg"]="完成数量*100"},
					{["key"]="status",["type"]="Signed32",["msg"]="活动状态0未完成，1已完成可领奖，2已完成已领奖"},
				}
			},
		}
	},

	["114503"] = { --运营活动：请求单个营活动完成情况
		["module_name"] = "operate", --运营活动
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 248, --未包含协议头部长度
		["req_func"] = "req_single_operate_act_info",
		["resp_func"] = "resp_single_operate_act_info",
		["req_args"] =
		{
			{["key"]="operateId",["type"]="Signed64",["msg"]="运营活动唯一id"},
		},
		["resp_args"] =
		{
			{["key"]="operateId",["type"]="Signed64",["msg"]="运营活动唯一id"},
			{
				["key"]="process",
				["type"]="struct[20]",	--OperateActSeqInfo
				["msg"]="此活动的每个档次完成情况(结构体)",
				["struct"]=
				{
					{["key"]="templeteId",["type"]="Signed32",["msg"]="运营活动表_id"},
					{["key"]="num",["type"]="Signed32",["msg"]="完成数量*100"},
					{["key"]="status",["type"]="Signed32",["msg"]="活动状态0未完成，1已完成可领奖，2已完成已领奖"},
				}
			},
		}
	},

	["114504"] = { --运营活动：请求额外数据
		["module_name"] = "operate", --运营活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 321, --未包含协议头部长度
		["req_func"] = "req_operate_act_extra_data",
		["resp_func"] = "resp_operate_act_extra_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="homeURL",["type"]="UTF8String[100]",["msg"]="社交平台首页链接"},
			{["key"]="shareURL",["type"]="UTF8String[100]",["msg"]="分享链接"},
			{["key"]="cdkey",["type"]="UTF8String[21]",["msg"]="分享码"},
			{["key"]="spare",["type"]="UTF8String[100]",["msg"]="备用字段"},
		}
	},

	["114505"] = { --运营活动：完成社交事件
		["module_name"] = "operate", --运营活动
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_operate_act_social",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="事件类型：1.跳转链接浏览主页,2.分享事件"},
			{["key"]="platform",["type"]="Signed32",["msg"]="社交平台：1.facebook,2.新浪微博"},
		},
	},

	["114601"] = { --兑换码: 领取兑换码奖励
		["module_name"] = "cdkey", --兑换码
		["socket_type"] = "game",
		["req_socket_size"] = 21, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_cdkey_get_reward",
		["resp_func"] = "resp_cdkey_get_reward",
		["req_args"] =
		{
			{["key"]="cdkey",["type"]="UTF8String[21]",["msg"]="兑换码"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果(0:成功,1:兑换码为空或不合法,2:兑换码已达使用上限,3:同批次已达使用上限,4：互斥组已兑换5:兑换码已过期7:分享码无效8:不能使用自己的分享码"},
		}
	},

	["114701"] = { --SS远程执行代码
		["module_name"] = "monitor", --远程执行代码
		["socket_type"] = "game",
		["req_socket_size"] = "51 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = 500, --未包含协议头部长度
		["req_func"] = "req_remote_code_execute",
		["resp_func"] = "resp_remote_execute_result",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="remoteIP",["type"]="UTF8String[39]",["msg"]="来源服务器IP"},
			{["key"]="processKey",["type"]="UTF8String[8]",["msg"]="目标SS唯一标志key"},
			{
				["key"]="remoteCode",
				["type"]="Signed8[$num]",
				["msg"]="远程代码编译后产生的class文件的字节数组",
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="UTF8String[500]",["msg"]="远程代码的执行结果"},
		}
	},

	["114801"] = { --时装:获得收集过的时装列表
		["module_name"] = "fashion", --时装
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 104", --未包含协议头部长度
		["req_func"] = "req_fashion_collect_list",
		["resp_func"] = "resp_fashion_collect_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--CollectFashionInfo
				["msg"]="时装列表(GoodsData._id)",
				["struct"]=
				{
					{["key"]="goodsId",["type"]="Signed32",["msg"]="时装物品id(GoodsData._id)"},
					{
						["key"]="heroIdList",
						["type"]="Signed32[25]",
						["msg"]="英雄id列表(表示这个时装被这些英雄激活了，单个时装可被多个英雄激活)这是个数组哦，数组长度25",
					},
				}
			},
		}
	},

	["114802"] = { --时装:在时装柜里激活时装(同个时装可以被多个英雄激活)
		["module_name"] = "fashion", --时装
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_activate_hero_fashion",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="时装物品id"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
	},

	["114901"] = { --熔铸:获得已使用过的配方列表
		["module_name"] = "casting", --熔铸
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 4", --未包含协议头部长度
		["req_func"] = "req_casting_formula_list",
		["resp_func"] = "resp_casting_formula_list",
		["req_args"] =
		{
			{["key"]="tab",["type"]="Signed32",["msg"]="CastingFormula.tab (填0表示获取所有)"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="tab",["type"]="Signed32",["msg"]="CastingFormula.tab (0表示所有)"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="配方列表",
			},
		}
	},

	["114902"] = { --熔铸:根据配方进行熔铸
		["module_name"] = "casting", --熔铸
		["socket_type"] = "game",
		["req_socket_size"] = "8 + num * 16", --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_casting",
		["resp_func"] = "resp_casting",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="formulaId",["type"]="Signed32",["msg"]="配方id(CastingFormula._id)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--CastingGoodsInfo
				["msg"]="材料列表",
				["struct"]=
				{
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="matId",["type"]="Signed32",["msg"]="素材定义id(该物品作为哪个素材进行熔铸)(GoodsData.defineMaterial)"},
					{["key"]="uniqueId",["type"]="Signed64",["msg"]="唯一id(如果材料是已鉴定的装备，或者是时装，需要填写唯一id)"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="formulaId",["type"]="Signed32",["msg"]="配方id(CastingFormula._id)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["115001"] = { --天赋树:查看某个英雄的天赋数据
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 2096", --未包含协议头部长度
		["req_func"] = "req_talent_data",
		["resp_func"] = "resp_talent_data",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的天赋页"},
			{["key"]="buyTalentPoint",["type"]="Signed32",["msg"]="最多可购买的天赋点值    -1=无限制  0=不可购买   大于0的表示限制购买的点数"},
			{["key"]="allTalentPoint",["type"]="Signed32",["msg"]="玩家身上所有的天赋点"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TalentInfo
				["msg"]="英雄所有天赋页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="天赋页名称"},
					{["key"]="remainTalent",["type"]="Signed32",["msg"]="天赋页剩余天赋点"},
					{["key"]="talentData",["type"]="UTF8String[2048]",["msg"]="每个天赋页的数据(json格式) {'70101' : 2, '70201' : 2, '70202' : 1, '70203' : 1, '70204' : 1}"},
				}
			},
		}
	},

	["115002"] = { --天赋树:重置天赋数据
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 2108, --未包含协议头部长度
		["req_func"] = "req_reset_talent_data",
		["resp_func"] = "resp_reset_talent_data",
		["req_args"] =
		{
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败, -1消耗的资源不足, -2天赋页不存在或者没有解锁    说明：result为1时，下面的值才有数据，客户端需要先判断result的值"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的天赋页"},
			{["key"]="allTalentPoint",["type"]="Signed32",["msg"]="玩家身上所有的天赋点"},
			{
				["key"]="talentInfo",
				["type"]="struct",	--TalentInfo
				["msg"]="选定天赋页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="天赋页名称"},
					{["key"]="remainTalent",["type"]="Signed32",["msg"]="天赋页剩余天赋点"},
					{["key"]="talentData",["type"]="UTF8String[2048]",["msg"]="每个天赋页的数据(json格式) {'70101' : 2, '70201' : 2, '70202' : 1, '70203' : 1, '70204' : 1}"},
				}
			},
		}
	},

	["115003"] = { --天赋树:切换英雄当前选定天赋页
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 2108, --未包含协议头部长度
		["req_func"] = "req_change_talent_page",
		["resp_func"] = "resp_change_talent_page",
		["req_args"] =
		{
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="切换结果：1成功, 0失败    说明：result为1时，下面的值才有数据，客户端需要先判断result的值"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的天赋页"},
			{["key"]="allTalentPoint",["type"]="Signed32",["msg"]="玩家身上所有的天赋点"},
			{
				["key"]="talentInfo",
				["type"]="struct",	--TalentInfo
				["msg"]="选定天赋页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="天赋页名称"},
					{["key"]="remainTalent",["type"]="Signed32",["msg"]="天赋页剩余天赋点"},
					{["key"]="talentData",["type"]="UTF8String[2048]",["msg"]="每个天赋页的数据(json格式) {'70101' : 2, '70201' : 2, '70202' : 1, '70203' : 1, '70204' : 1}"},
				}
			},
		}
	},

	["115004"] = { --天赋树:解锁天赋页
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 2108, --未包含协议头部长度
		["req_func"] = "req_unlock_talent_page",
		["resp_func"] = "resp_unlock_talent_page",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="解锁结果：1成功, 0失败, -1消耗的资源不足, -2天赋页已达最大值, -3天赋页已经解锁   说明：result为1时，下面的值才有数据，客户端需要先判断result的值"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的天赋页"},
			{["key"]="allTalentPoint",["type"]="Signed32",["msg"]="玩家身上所有的天赋点"},
			{
				["key"]="talentInfo",
				["type"]="struct",	--TalentInfo
				["msg"]="选定天赋页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="天赋页名称"},
					{["key"]="remainTalent",["type"]="Signed32",["msg"]="天赋页剩余天赋点"},
					{["key"]="talentData",["type"]="UTF8String[2048]",["msg"]="每个天赋页的数据(json格式) {'70101' : 2, '70201' : 2, '70202' : 1, '70203' : 1, '70204' : 1}"},
				}
			},
		}
	},

	["115005"] = { --天赋树:解锁天赋位置
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_unlock_talent_point",
		["resp_func"] = "resp_unlock_talent_point",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="point",["type"]="Signed32",["msg"]="天赋点位置"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="解锁结果：1成功, 0失败, -1消耗的资源不足, -2解锁条件不满足, -3重复解锁天赋点"},
		}
	},

	["115006"] = { --天赋树:激活天赋点/保存天赋页加点方案
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = "12 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_save_talent_data",
		["resp_func"] = "resp_save_talent_data",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
			{
				["key"]="talentData",
				["type"]="Signed32[$num]",
				["msg"]="需要激活的天赋点，天赋点数组列表 [1,2,3,4,5,6]",
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="加点结果：1成功, 0失败, -1激活条件不满足, -2天赋页不存在或者没有解锁"},
		}
	},

	["115007"] = { --天赋树:玩家所有英雄当前选定页已激活的天赋点
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 2048, --未包含协议头部长度
		["req_func"] = "req_all_talent_data",
		["resp_func"] = "resp_all_talent_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="data",["type"]="UTF8String[2048]",["msg"]="json字符串  格式{'英雄ID1,生效页':[70101,70202],'英雄ID2,生效页':[70101,70202]}"},
		}
	},

	["115008"] = { --天赋树:购买天赋点
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_buy_talent_point",
		["resp_func"] = "resp_buy_talent_point",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="购买天赋点数量"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="购买结果：1成功, 0失败, -1购买天赋点已达上线, -2不可购买, -3购买天赋点资源不足"},
		}
	},

	["115009"] = { --天赋树:修改天赋页名称
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 48, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_edit_talent_page_name",
		["resp_func"] = "resp_edit_talent_page_name",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="天赋页编号"},
			{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="天赋页名称"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="修改结果：1成功, 0失败, -1天赋页不存在或者没有解锁"},
		}
	},

	["115010"] = { --天赋树:显示购买天赋点弹出框时请求（购买天赋点之前）
		["module_name"] = "talent", --天赋树
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_buy_talent_point_before",
		["resp_func"] = "resp_buy_talent_point_before",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="canBuyPoint",["type"]="Signed32",["msg"]="可购买的天赋点数"},
			{["key"]="alreadyBuyPoint",["type"]="Signed32",["msg"]="已经购买的天赋点数"},
		}
	},

	["115101"] = { --在主城查看所有已经激活的大地图
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "78 + num * 12", --未包含协议头部长度
		["req_func"] = "req_map_list",
		["resp_func"] = "resp_map_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="worldId",["type"]="Signed64",["msg"]="玩家当前所在的世界id，0表示没有"},
			{["key"]="worldName",["type"]="UTF8String[60]",["msg"]="玩家当前所在的世界名字"},
			{["key"]="phy",["type"]="Signed32",["msg"]="大地图任务体力值"},
			{["key"]="isLeader",["type"]="Bool",["msg"]="是否是队长，true:是、false:否"},
			{["key"]="isInTeam",["type"]="Bool",["msg"]="是否在队伍中"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MapInfo
				["msg"]="大地图的状态",
				["struct"]=
				{
					{["key"]="mapId",["type"]="Signed32",["msg"]="地图id"},
					{["key"]="status",["type"]="Signed32",["msg"]="状态StatusMap:0未进入1进入未激活传送阵2已激活(冗余)"},
					{["key"]="num",["type"]="Signed32",["msg"]="地图上的队员数量"},
				}
			},
		}
	},

	["115102"] = { --在主城查看可用的传送门列表
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 60", --未包含协议头部长度
		["req_func"] = "req_door_list",
		["resp_func"] = "resp_door_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ssTime",["type"]="Signed32",["msg"]="服务器时间戳（用来校验）"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DoorInfoCity
				["msg"]="传送门列表",
				["struct"]=
				{
					{["key"]="owner",["type"]="Signed64",["msg"]="开启者uid"},
					{["key"]="ownerName",["type"]="UTF8String[40]",["msg"]="开启者昵称"},
					{["key"]="pos",["type"]="Signed32",["msg"]="在主城的位置"},
					{["key"]="mapId",["type"]="Signed32",["msg"]="目标地图"},
					{["key"]="cdTime",["type"]="Signed32",["msg"]="门cd时间戳"},
				}
			},
		}
	},

	["115103"] = { --开启一个新的传送门
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 92, --未包含协议头部长度
		["req_func"] = "req_create_door",
		["resp_func"] = "resp_create_door",
		["req_args"] =
		{
			{["key"]="x",["type"]="Signed32",["msg"]="目标位置x坐标"},
			{["key"]="y",["type"]="Signed32",["msg"]="目标位置y坐标"},
			{["key"]="z",["type"]="Signed32",["msg"]="目标位置z坐标"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="ssTime",["type"]="Signed32",["msg"]="服务器时间戳（客户端校验）"},
			{
				["key"]="door",
				["type"]="struct",	--DoorInfo
				["msg"]="传送门信息",
				["struct"]=
				{
					{["key"]="owner",["type"]="Signed64",["msg"]="开启者uid"},
					{["key"]="ownerName",["type"]="UTF8String[40]",["msg"]="开启者昵称"},
					{["key"]="worldId",["type"]="Signed64",["msg"]="所属世界的唯一id"},
					{["key"]="pos",["type"]="Signed32",["msg"]="在主城的位置"},
					{["key"]="mapId",["type"]="Signed32",["msg"]="目标地图"},
					{["key"]="sceneId",["type"]="Signed32",["msg"]="目标场景ID  @see CSceneData"},
					{["key"]="x",["type"]="Signed32",["msg"]="目标位置x坐标"},
					{["key"]="y",["type"]="Signed32",["msg"]="目标位置y坐标"},
					{["key"]="z",["type"]="Signed32",["msg"]="目标位置z坐标"},
					{["key"]="cdTime",["type"]="Signed32",["msg"]="门cd时间戳"},
				}
			},
		}
	},

	["115104"] = { --通过传送点跳地图
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_transfer_by_point",
		["req_args"] =
		{
			{["key"]="pointId",["type"]="Signed32",["msg"]="传送点id"},
		},
	},

	["115105"] = { --通过传送阵跳地图
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_transfer_by_station",
		["req_args"] =
		{
			{["key"]="srcStationId",["type"]="Signed32",["msg"]="玩家当前所在传送阵ID"},
			{["key"]="dstStationId",["type"]="Signed32",["msg"]="目标传送阵id"},
		},
	},

	["115106"] = { --通过传送门跳地图
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_transfer_by_door",
		["req_args"] =
		{
			{["key"]="owner",["type"]="Signed64",["msg"]="开门的玩家uid"},
		},
	},

	["115107"] = { --在主城查看地图任务列表
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "20 + num * 24", --未包含协议头部长度
		["req_func"] = "req_map_task_list",
		["resp_func"] = "resp_map_task_list",
		["req_args"] =
		{
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ssTime",["type"]="Signed32",["msg"]="服务器时间戳（客户端进行时间校验）"},
			{["key"]="refTime",["type"]="Signed32",["msg"]="重置按钮的cd结束时间"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
			{["key"]="MissionDataID",["type"]="Signed32",["msg"]="ActiveCellConfig表中的MissionID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ResTaskInfo
				["msg"]="任务列表",
				["struct"]=
				{
					{["key"]="mainTaskId",["type"]="Signed32",["msg"]="主任务ID（任务链ID）"},
					{["key"]="mainTaskStatus",["type"]="Signed32",["msg"]="主任务状态StatusTask"},
					{
						["key"]="childTask",
						["type"]="struct",	--ChildTaskInfo
						["msg"]="子任务",
						["struct"]=
						{
							{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务ID"},
							{["key"]="childTaskStatus",["type"]="Signed32",["msg"]="子任务状态"},
							{["key"]="preTaskId",["type"]="Signed32",["msg"]="前置任务ID"},
							{["key"]="afterTaskId",["type"]="Signed32",["msg"]="后置任务ID"},
						}
					},
				}
			},
		}
	},

	["115108"] = { --玩家主动刷新大地图任务
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "20 + num * 24", --未包含协议头部长度
		["req_func"] = "req_refresh_map_task_list",
		["resp_func"] = "resp_refresh_map_task_list",
		["req_args"] =
		{
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ssTime",["type"]="Signed32",["msg"]="服务器时间戳（客户端进行时间校验）"},
			{["key"]="refTime",["type"]="Signed32",["msg"]="重置按钮的cd结束时间"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
			{["key"]="MissionDataID",["type"]="Signed32",["msg"]="ActiveCellConfig表中的MissionID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ResTaskInfo
				["msg"]="任务列表",
				["struct"]=
				{
					{["key"]="mainTaskId",["type"]="Signed32",["msg"]="主任务ID（任务链ID）"},
					{["key"]="mainTaskStatus",["type"]="Signed32",["msg"]="主任务状态StatusTask"},
					{
						["key"]="childTask",
						["type"]="struct",	--ChildTaskInfo
						["msg"]="子任务",
						["struct"]=
						{
							{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务ID"},
							{["key"]="childTaskStatus",["type"]="Signed32",["msg"]="子任务状态"},
							{["key"]="preTaskId",["type"]="Signed32",["msg"]="前置任务ID"},
							{["key"]="afterTaskId",["type"]="Signed32",["msg"]="后置任务ID"},
						}
					},
				}
			},
		}
	},

	["115109"] = { --大地图回城（大地图销毁、队长大地图离队、玩家大地图离队......）
		["module_name"] = "map", --大地图传送
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_back2_city",
		["resp_func"] = "resp_ty",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
		}
	},

	["115201"] = { --大地图组队:获取队伍列表，返回信息见211901协议 ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_world_team_list",
		["req_args"] =
		{
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID  传0则获取所有的队伍列表    非酒馆中用，用到此参数，那么其他参数为0"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="创建哪个任务的队伍   酒馆中创建队伍用到  在酒馆中用到，用到此参数，那么其他参数为0"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍ID  在酒馆中根据具体队伍ID搜索，用到此参数，那么其他参数为0"},
		},
	},

	["115202"] = { --大地图组队:创建队伍  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 108, --未包含协议头部长度
		["resp_socket_size"] = "440 + num * 345", --未包含协议头部长度
		["req_func"] = "req_create_world_team",
		["resp_func"] = "resp_create_world_team",
		["req_args"] =
		{
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="创建哪个任务的队伍   酒馆中创建队伍用到"},
			{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="errCode",["type"]="Signed32",["msg"]="操作结果：@see ErrorCode"},
			{
				["key"]="teamInfo",
				["type"]="struct",	--WorldTeamInfo
				["msg"]="队伍信息",
				["struct"]=
				{
					{["key"]="teamId",["type"]="Signed64",["msg"]="队伍唯一id"},
					{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
					{["key"]="curNum",["type"]="Signed32",["msg"]="队伍当前人数"},
					{["key"]="leaderId",["type"]="Signed64",["msg"]="队长UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="队长名字"},
					{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
					{["key"]="groupId",["type"]="Signed32",["msg"]="区域组ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="队伍等级"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队伍头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队伍图标地址"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamMemberMessage
				["msg"]="队员列表",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["115203"] = { --大地图组队:申请加入队伍（需要队长同意，预先加到申请列表）ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_apply_join_world_team",
		["resp_func"] = "resp_apply_join_world_team",
		["req_args"] =
		{
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍ID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115204"] = { --大地图组队:快速申请加入队伍（系统随机一个有效队伍进行申请，预先加到申请列表）ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_quick_apply_join_world_team",
		["resp_func"] = "resp_quick_apply_join_world_team",
		["req_args"] =
		{
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115205"] = { --大地图组队:修改队伍名字  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 100, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_change_world_team_name",
		["resp_func"] = "resp_change_world_team_name",
		["req_args"] =
		{
			{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115206"] = { --大地图组队:获取申请入队的玩家列表，返回信息见211904协议  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_apply_world_team_list",
		["req_args"] =
		{
		},
	},

	["115207"] = { --大地图组队:队长处理队伍申请（同意  or 拒绝）  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_deal_with_apply_world_team",
		["resp_func"] = "resp_deal_with_apply_world_team",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型  1-同意     2-拒绝"},
			{["key"]="uid",["type"]="Signed64",["msg"]="申请者UID"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型  1-同意     2-拒绝"},
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115208"] = { --大地图组队:玩家处理队伍邀请（同意  or 拒绝）  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_deal_with_invite_world_team",
		["resp_func"] = "resp_deal_with_invite_world_team",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型  1-同意     2-拒绝"},
			{["key"]="uid",["type"]="Signed64",["msg"]="邀请者UID"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍ID"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型  1-同意     2-拒绝"},
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115209"] = { --大地图组队:队长踢人，返回信息见211908协议  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_world_team_kick",
		["req_args"] =
		{
			{["key"]="memberId",["type"]="Signed64",["msg"]="被踢队员的uid"},
		},
	},

	["115210"] = { --大地图组队:退出队伍，返回信息见211909协议   ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_world_team_cancel",
		["req_args"] =
		{
			{["key"]="mapType",["type"]="Signed32",["msg"]="场景类型 @see TypeMap 就是玩家当前所在场景ID值"},
		},
	},

	["115211"] = { --大地图组队:委任队长（队长转让），返回信息见211910协议    ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_world_team_leader",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标队长UID"},
		},
	},

	["115212"] = { --大地图组队:邀请玩家加入队伍  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_invite_add_world_team",
		["resp_func"] = "resp_invite_add_world_team",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="被邀请玩家的UID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115213"] = { --大地图组队:查看队伍详情，返回信息见211912协议  ok
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_query_world_team_details",
		["req_args"] =
		{
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍ID"},
		},
	},

	["115214"] = { --大地图组队:修改队伍所属区域  广播全队协议见211916
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_editor_world_team_area",
		["resp_func"] = "resp_editor_world_team_area",
		["req_args"] =
		{
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115215"] = { --大地图组队:通知队员组队出发（酒馆和大地图都需要用到） 广播协议见211914
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_start_together",
		["resp_func"] = "resp_start_together",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="出发类型  1-大地图    2-酒馆  @see  TypeStartOff"},
			{["key"]="srcStationId",["type"]="Signed32",["msg"]="玩家当前所在传送阵ID type=1时有效"},
			{["key"]="dstStationId",["type"]="Signed32",["msg"]="目标传送阵ID type=1时有效"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务ID type=2时有效"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115216"] = { --大地图组队:队员反馈组队出发请求（酒馆和大地图都需要用到）广播协议见211918
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_response_start_together",
		["resp_func"] = "resp_response_start_together",
		["req_args"] =
		{
			{["key"]="leaderId",["type"]="Signed64",["msg"]="队长ID"},
			{["key"]="type",["type"]="Signed32",["msg"]="同意/拒绝   @see TypeTeamDealWith"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115217"] = { --大地图组队:大地图传送的时候队长进行的二次确认的请求，同意则传送，不同意则全员广播此次进入失败    失败广播协议见211914
		["module_name"] = "worldteam", --大地图组队
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_confirm_transfer",
		["resp_func"] = "resp_confirm_transfer",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="同意/拒绝   @see TypeTeamDealWith"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["115301"] = { --技能页:查看某个英雄的技能页数据
		["module_name"] = "skilldata", --技能页
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 2092", --未包含协议头部长度
		["req_func"] = "req_skill_data",
		["resp_func"] = "resp_skill_data",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的技能页"},
			{["key"]="buyNum",["type"]="Signed32",["msg"]="购买的技能页页数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SkillInfo
				["msg"]="英雄所有技能页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="技能页名称"},
					{["key"]="skillData",["type"]="UTF8String[2048]",["msg"]="每个技能页的数据(json格式) {'-1' : [1,2,3,4,5]}  key==-1标识branch"},
				}
			},
		}
	},

	["115302"] = { --技能页:切换英雄当前选定技能页
		["module_name"] = "skilldata", --技能页
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 2100, --未包含协议头部长度
		["req_func"] = "req_change_skill_page",
		["resp_func"] = "resp_change_skill_page",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id "},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="切换结果：1成功, 0失败    说明：result为1时，下面的值才有数据，客户端需要先判断result的值"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的技能页"},
			{
				["key"]="skillInfo",
				["type"]="struct",	--SkillInfo
				["msg"]="选定技能页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="技能页名称"},
					{["key"]="skillData",["type"]="UTF8String[2048]",["msg"]="每个技能页的数据(json格式) {'-1' : [1,2,3,4,5]}  key==-1标识branch"},
				}
			},
		}
	},

	["115303"] = { --技能页:购买技能页
		["module_name"] = "skilldata", --技能页
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 2100, --未包含协议头部长度
		["req_func"] = "req_unlock_skill_page",
		["resp_func"] = "resp_unlock_skill_page",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="解锁结果：1成功, 0失败, -1消耗的资源不足, -2技能页已达最大值, -3技能页已经解锁   说明：result为1时，下面的值才有数据，客户端需要先判断result的值"},
			{["key"]="curPage",["type"]="Signed32",["msg"]="当前选用的技能页"},
			{
				["key"]="skillInfo",
				["type"]="struct",	--SkillInfo
				["msg"]="解锁（购买）技能页数据",
				["struct"]=
				{
					{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
					{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="技能页名称"},
					{["key"]="skillData",["type"]="UTF8String[2048]",["msg"]="每个技能页的数据(json格式) {'-1' : [1,2,3,4,5]}  key==-1标识branch"},
				}
			},
		}
	},

	["115304"] = { --技能页:保存技能页技能配置
		["module_name"] = "skilldata", --技能页
		["socket_type"] = "game",
		["req_socket_size"] = "12 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_save_skill_data",
		["resp_func"] = "resp_save_skill_data",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
			{
				["key"]="skillData",
				["type"]="Signed32[$num]",
				["msg"]="需要保存的branch技能数组  格式[1,2,3,4,4]",
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="加点结果：1成功, 0失败, -1激活条件不满足, -2技能页不存在或者没有解锁"},
		}
	},

	["115305"] = { --技能页:修改技能页名称
		["module_name"] = "skilldata", --技能页
		["socket_type"] = "game",
		["req_socket_size"] = 48, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_edit_skill_page_name",
		["resp_func"] = "resp_edit_skill_page_name",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="pageIndex",["type"]="Signed32",["msg"]="技能页编号"},
			{["key"]="pageName",["type"]="UTF8String[40]",["msg"]="技能页名称"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="修改结果：1成功, 0失败, -1技能页不存在或者没有解锁"},
		}
	},

	["119903"] = { --测试:增加物品
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_goods",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		},
	},

	["119904"] = { --测试:增加英雄的灵魂
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_soul",
		["req_args"] =
		{
			{["key"]="heroBaseId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		},
	},

	["119906"] = { --测试:修改角色等级
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_set_level",
		["req_args"] =
		{
			{["key"]="level",["type"]="Signed32",["msg"]="等级"},
		},
	},

	["119907"] = { --测试:修改英雄等级
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_set_hero_level",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="level",["type"]="Signed32",["msg"]="等级"},
		},
	},

	["119908"] = { --测试:发系统邮件
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 638, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_send_mail",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="langKey",["type"]="UTF8String[100]",["msg"]="语言包key"},
			{["key"]="title",["type"]="UTF8String[30]",["msg"]="邮件标题参数"},
			{["key"]="content",["type"]="UTF8String[400]",["msg"]="邮件内容参数"},
			{["key"]="award",["type"]="UTF8String[100]",["msg"]="附加奖励(json)"},
		},
	},

	["119910"] = { --测试:增加竞技场积分
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_score",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="score",["type"]="Signed32",["msg"]="积分"},
		},
	},

	["119911"] = { --测试:清除竞技场排行
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_clear_top_list",
		["req_args"] =
		{
		},
	},

	["119912"] = { --测试:增加金钱
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_money",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="类型:0 所有, 1 钻石, 2 金币, 3 魔力值, 4 纹章, 5 推图积分, 6 社交积分, 7 技能点"},
			{["key"]="num",["type"]="Signed32",["msg"]="数量"},
		},
	},

	["119913"] = { --开启引导
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_guide",
		["req_args"] =
		{
		},
	},

	["119914"] = { --测试:完成指定任务
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_complete_mission",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
	},

	["119915"] = { --测试:发送系统消息
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 264, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_send_system_msg",
		["req_args"] =
		{
			{["key"]="target",["type"]="Signed64",["msg"]="uid"},
			{["key"]="text",["type"]="UTF8String[256]",["msg"]="消息内容"},
		},
	},

	["119916"] = { --测试:设置装备等级
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_equip_upgrade",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="id"},
			{["key"]="part",["type"]="Signed32",["msg"]="部位"},
			{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
			{["key"]="level",["type"]="Signed32",["msg"]="级"},
		},
	},

	["119917"] = { --测试:设置技能等级
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_skill_upgrade",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="id"},
			{["key"]="pos",["type"]="Signed32",["msg"]="技能位置:0,2,3,4"},
			{["key"]="level",["type"]="Signed32",["msg"]="级"},
		},
	},

	["119918"] = { --测试:完成任务及所有前置
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_complete_single_mission",
		["req_args"] =
		{
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
	},

	["119919"] = { --测试:增加亲密度
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_intimacy",
		["req_args"] =
		{
			{["key"]="heroId1",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroId2",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="addValue",["type"]="Signed32",["msg"]="增加的值，可以为负数"},
		},
	},

	["119920"] = { --测试:触发神谕
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_create_oracle",
		["req_args"] =
		{
		},
	},

	["119921"] = { --测试:激活英雄
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_activate_hero",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
		},
	},

	["119922"] = { --测试:增加[新]装备
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_outfit",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		},
	},

	["119923"] = { --测试:nick查询uid
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 40, --未包含协议头部长度
		["resp_socket_size"] = 69, --未包含协议头部长度
		["req_func"] = "req_test_nick_to_pid",
		["resp_func"] = "resp_test_nick_to_pid",
		["req_args"] =
		{
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="昵称"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed8",["msg"]="是否成功 0：成功 , 1 : 没有对应的账号"},
			{["key"]="pid",["type"]="UTF8String[64]",["msg"]="玩家PID,没有则返回-1"},
			{["key"]="zid",["type"]="Signed32",["msg"]="返回zid"},
		}
	},

	["119924"] = { --测试:修改主副英雄熟练度
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_set_practice",
		["req_args"] =
		{
			{["key"]="practice",["type"]="Signed32",["msg"]="英雄熟练度"},
		},
	},

	["119925"] = { --测试:redis性能
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 1184, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_redis_rate",
		["req_args"] =
		{
			{["key"]="poolsize",["type"]="Signed16",["msg"]="测试线程池大小"},
			{["key"]="cmd",["type"]="UTF8String[100]",["msg"]="测试指令"},
			{["key"]="key",["type"]="UTF8String[50]",["msg"]="测试redisKey"},
			{["key"]="taskNum",["type"]="Signed32",["msg"]="任务数量"},
			{["key"]="count",["type"]="Signed32",["msg"]="单个线程任务操作次数"},
			{["key"]="param",["type"]="UTF8String[1024]",["msg"]="测试所用参数"},
		},
	},

	["119927"] = { --demo版大地图的杀怪奖励
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_test_monster_reward",
		["resp_func"] = "resp_test_monster_reward",
		["req_args"] =
		{
			{["key"]="monsterId",["type"]="Signed32",["msg"]="MonsterFactory表的id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="奖励列表，包括金币和物品等",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["119929"] = { --清空大地图组队相关的redis数据
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_clear_world_data",
		["resp_func"] = "resp_clear_world_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果  1成功     0失败"},
		}
	},

	["119930"] = { --清空大地图任务相关的redis数据
		["module_name"] = "test", --测试模块
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_clear_world_task_data",
		["resp_func"] = "resp_clear_world_task_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果  1成功     0失败"},
		}
	},

	["120001"] = { --加入战斗场景
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 132, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_join_in",
		["resp_func"] = "resp_join_in",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="TypeMatch"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="uid",["type"]="Signed64",["msg"]="角色uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="角色名"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="区"},
			{["key"]="typeTransfer",["type"]="Signed32",["msg"]="传送的类型TypeTransfer"},
			{["key"]="worldId",["type"]="Signed64",["msg"]="世界ID/mapObjId"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="场景ID"},
			{["key"]="doorId",["type"]="Signed64",["msg"]="传送门id"},
			{["key"]="time",["type"]="Signed32",["msg"]="生成sign的时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(对玩家信息生成的md5校验码, 用于防止伪造信息登录)"},
		},
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="TypeMatch"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="heroId"},
			{["key"]="camp",["type"]="Signed32",["msg"]="阵营"},
		}
	},

	["120002"] = { --移动
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 42, --未包含协议头部长度
		["resp_socket_size"] = 38, --未包含协议头部长度
		["req_func"] = "req_move",
		["resp_func"] = "resp_unit_move",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="startPosX",["type"]="Signed32",["msg"]="开始坐标x"},
			{["key"]="startPosY",["type"]="Signed32",["msg"]="开始坐标y"},
			{["key"]="startPosZ",["type"]="Signed32",["msg"]="开始坐标z"},
			{["key"]="endPosX",["type"]="Signed32",["msg"]="结束坐标x"},
			{["key"]="endPosY",["type"]="Signed32",["msg"]="结束坐标y"},
			{["key"]="endPosZ",["type"]="Signed32",["msg"]="结束坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="startPosX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="startPosY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="startPosZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="endPosX",["type"]="Signed32",["msg"]="终点坐标x"},
			{["key"]="endPosY",["type"]="Signed32",["msg"]="终点坐标y"},
			{["key"]="endPosZ",["type"]="Signed32",["msg"]="终点坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120003"] = { --停止移动
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 30, --未包含协议头部长度
		["resp_socket_size"] = 26, --未包含协议头部长度
		["req_func"] = "req_stop",
		["resp_func"] = "resp_unit_stop",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120004"] = { --保持心跳
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 12", --未包含协议头部长度
		["req_func"] = "req_heart_beat",
		["resp_func"] = "resp_heart_beat",
		["req_args"] =
		{
			{["key"]="time",["type"]="Signed64",["msg"]="时间"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="time",["type"]="Signed64",["msg"]="时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PingInfo
				["msg"]="其他玩家Ping值",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="ping",["type"]="Signed32",["msg"]="Ping值 "},
				}
			},
		}
	},

	["120005"] = { --切换英雄
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 30, --未包含协议头部长度
		["resp_socket_size"] = 26, --未包含协议头部长度
		["req_func"] = "req_change_hero",
		["resp_func"] = "resp_change_hero",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="AOIID"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="切换后的英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="AOIID"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="切换后的英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120006"] = { --转向
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 32, --未包含协议头部长度
		["resp_socket_size"] = 28, --未包含协议头部长度
		["req_func"] = "req_turn",
		["resp_func"] = "resp_unit_turn",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="currentDirection",["type"]="Signed16",["msg"]="当前方向"},
			{["key"]="targetDirection",["type"]="Signed16",["msg"]="新的方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="currentDirection",["type"]="Signed16",["msg"]="当前方向"},
			{["key"]="targetDirection",["type"]="Signed16",["msg"]="新的方向"},
		}
	},

	["120008"] = { --重载战场前先通讯一次拿到正确的信息
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 40, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_reconnect",
		["resp_func"] = "resp_reconnect",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="角色ID"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0:失败, 1:成功"},
			{["key"]="currentHeroId",["type"]="Signed32",["msg"]="当前英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
		}
	},

	["120009"] = { --重载战场
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_re_join_in",
		["resp_func"] = "resp_re_join_in",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="角色ID"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
		}
	},

	["120010"] = { --断线重连
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 40, --未包含协议头部长度
		["resp_socket_size"] = 84, --未包含协议头部长度
		["req_func"] = "req_fix_sockect",
		["resp_func"] = "resp_fix_sockect",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="角色ID"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0:失败, 1:成功"},
			{["key"]="type",["type"]="Signed32",["msg"]="TypeMatch"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="typeTransfer",["type"]="Signed32",["msg"]="传送的类型TypeTransfer"},
			{["key"]="worldId",["type"]="Signed64",["msg"]="世界ID/mapObjId"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="场景ID"},
			{["key"]="doorId",["type"]="Signed64",["msg"]="传送门id"},
			{["key"]="time",["type"]="Signed32",["msg"]="生成sign的时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(对玩家信息生成的md5校验码, 用于防止伪造信息登录)"},
		}
	},

	["120011"] = { --表情
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 24, --未包含协议头部长度
		["req_func"] = "req_emotion",
		["resp_func"] = "resp_emotion",
		["req_args"] =
		{
			{["key"]="emotionId",["type"]="Signed32",["msg"]="表情ID"},
			{["key"]="index",["type"]="Signed32",["msg"]="序号"},
		},
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="玩家UID"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="emotionId",["type"]="Signed32",["msg"]="表情ID"},
			{["key"]="index",["type"]="Signed32",["msg"]="序号"},
		}
	},

	["120012"] = { --防作弊：检查玩家战斗数据
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_check_fight_data",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="当前英雄ID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--FightDataKeyVal
				["msg"]="战斗属性类型数据键值列表，固定10个 0生命值 2生命回复量 4能量上限 6能量自然回复量 14攻击力15物理护甲 16魔法抗性 25普攻攻击力 26技能攻击力",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="战斗属性类型TypeAttr"},
					{["key"]="val",["type"]="Signed32",["msg"]="战斗属性数值"},
				}
			},
		},
	},

	["120013"] = { --查询当前战斗是否作弊
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_check_is_hack",
		["resp_func"] = "resp_check_is_hack",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="1作弊 0正常"},
		}
	},

	["120014"] = { --请求退出
		["module_name"] = "battle", --战斗
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_arena_quit",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="离开类型"},
		},
	},

	["120101"] = { --普通技能
		["module_name"] = "battle", --技能模块
		["socket_type"] = "pvp",
		["req_socket_size"] = 46, --未包含协议头部长度
		["resp_socket_size"] = 42, --未包含协议头部长度
		["req_func"] = "req_skill_simple",
		["resp_func"] = "resp_skill_simple",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120102"] = { --带终点位置技能
		["module_name"] = "battle", --技能模块
		["socket_type"] = "pvp",
		["req_socket_size"] = 58, --未包含协议头部长度
		["resp_socket_size"] = 54, --未包含协议头部长度
		["req_func"] = "req_skill_with_end_pos",
		["resp_func"] = "resp_skill_with_end_pos",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="startPosX",["type"]="Signed32",["msg"]="开始坐标x"},
			{["key"]="startPosY",["type"]="Signed32",["msg"]="开始坐标y"},
			{["key"]="startPosZ",["type"]="Signed32",["msg"]="开始坐标z"},
			{["key"]="endPosX",["type"]="Signed32",["msg"]="结束坐标x"},
			{["key"]="endPosY",["type"]="Signed32",["msg"]="结束坐标y"},
			{["key"]="endPosZ",["type"]="Signed32",["msg"]="结束坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="startPosX",["type"]="Signed32",["msg"]="开始坐标x"},
			{["key"]="startPosY",["type"]="Signed32",["msg"]="开始坐标y"},
			{["key"]="startPosZ",["type"]="Signed32",["msg"]="开始坐标z"},
			{["key"]="endPosX",["type"]="Signed32",["msg"]="结束坐标x"},
			{["key"]="endPosY",["type"]="Signed32",["msg"]="结束坐标y"},
			{["key"]="endPosZ",["type"]="Signed32",["msg"]="结束坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120103"] = { --带对象列表技能
		["module_name"] = "battle", --技能模块
		["socket_type"] = "pvp",
		["req_socket_size"] = "50 + num * 16", --未包含协议头部长度
		["resp_socket_size"] = "46 + num * 16", --未包含协议头部长度
		["req_func"] = "req_skill_with_obj_list",
		["resp_func"] = "resp_skill_with_obj_list",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ObjInfo
				["msg"]="对象列表",
				["struct"]=
				{
					{["key"]="objId",["type"]="Signed32",["msg"]="对象ID"},
					{["key"]="posX",["type"]="Signed32",["msg"]="坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="坐标z"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ObjInfo
				["msg"]="对象列表",
				["struct"]=
				{
					{["key"]="objId",["type"]="Signed32",["msg"]="对象ID"},
					{["key"]="posX",["type"]="Signed32",["msg"]="坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="坐标z"},
				}
			},
		}
	},

	["120104"] = { --带目标技能
		["module_name"] = "battle", --技能模块
		["socket_type"] = "pvp",
		["req_socket_size"] = 58, --未包含协议头部长度
		["resp_socket_size"] = 54, --未包含协议头部长度
		["req_func"] = "req_skill_with_target",
		["resp_func"] = "resp_skill_with_target",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="targetAoiId",["type"]="Signed64",["msg"]="目标AoiId"},
			{["key"]="targetHeroId",["type"]="Signed32",["msg"]="目标英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillIndex",["type"]="Signed32",["msg"]="技能序号"},
			{["key"]="costHpPercent",["type"]="Signed32",["msg"]="消耗生命百分比"},
			{["key"]="costEp",["type"]="Signed32",["msg"]="消耗能量"},
			{["key"]="targetAoiId",["type"]="Signed64",["msg"]="目标AoiId"},
			{["key"]="targetHeroId",["type"]="Signed32",["msg"]="目标英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["120110"] = { --停止技能
		["module_name"] = "battle", --技能模块
		["socket_type"] = "pvp",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["req_func"] = "req_stop_skill",
		["resp_func"] = "resp_stop_skill",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
		}
	},

	["120200"] = { --选择主机
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_select_host",
		["resp_func"] = "resp_select_host",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
		},
		["resp_args"] =
		{
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
		}
	},

	["120201"] = { --技能伤害
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 64", --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 64", --未包含协议头部长度
		["req_func"] = "req_get_damage",
		["resp_func"] = "resp_get_damage",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GetDamageInfo
				["msg"]="伤害列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="当前血量"},
					{["key"]="spCurrent",["type"]="Signed32",["msg"]="当前硬直/霸体"},
					{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
					{["key"]="attackUid",["type"]="Signed64",["msg"]="攻击者UID"},
					{["key"]="attackAoiId",["type"]="Signed64",["msg"]="攻击者aoiId"},
					{["key"]="attackHeroId",["type"]="Signed32",["msg"]="攻击者英雄ID"},
					{["key"]="damageValue",["type"]="Signed32",["msg"]="伤害血量"},
					{["key"]="suckBloodValue",["type"]="Signed32",["msg"]="吸血值"},
					{["key"]="type",["type"]="Signed8",["msg"]="类型:0普通、1闪避、2无敌、3免疫、4无效、5暴击、6反伤"},
					{["key"]="property",["type"]="Signed8",["msg"]="属性:冰、火、雷、毒"},
					{["key"]="isBuffer",["type"]="Signed8",["msg"]="是否为BUFF"},
					{["key"]="isPassive",["type"]="Signed8",["msg"]="是否为被动"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GetDamageInfo
				["msg"]="伤害列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="当前血量"},
					{["key"]="spCurrent",["type"]="Signed32",["msg"]="当前硬直/霸体"},
					{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
					{["key"]="attackUid",["type"]="Signed64",["msg"]="攻击者UID"},
					{["key"]="attackAoiId",["type"]="Signed64",["msg"]="攻击者aoiId"},
					{["key"]="attackHeroId",["type"]="Signed32",["msg"]="攻击者英雄ID"},
					{["key"]="damageValue",["type"]="Signed32",["msg"]="伤害血量"},
					{["key"]="suckBloodValue",["type"]="Signed32",["msg"]="吸血值"},
					{["key"]="type",["type"]="Signed8",["msg"]="类型:0普通、1闪避、2无敌、3免疫、4无效、5暴击、6反伤"},
					{["key"]="property",["type"]="Signed8",["msg"]="属性:冰、火、雷、毒"},
					{["key"]="isBuffer",["type"]="Signed8",["msg"]="是否为BUFF"},
					{["key"]="isPassive",["type"]="Signed8",["msg"]="是否为被动"},
				}
			},
		}
	},

	["120202"] = { --增加BUFF
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 48", --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 48", --未包含协议头部长度
		["req_func"] = "req_add_buffer",
		["resp_func"] = "resp_add_buffer",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--AddBufferInfo
				["msg"]="Buffer列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="buffId",["type"]="Signed32",["msg"]="bufferId"},
					{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
					{["key"]="rank",["type"]="Signed32",["msg"]="叠加层数"},
					{["key"]="time",["type"]="Signed32",["msg"]="剩余时间"},
					{["key"]="attackProperty",["type"]="Signed32",["msg"]="攻击属性"},
					{["key"]="damageValuePercent",["type"]="Signed32",["msg"]="伤害值百分比"},
					{["key"]="sendUid",["type"]="Signed64",["msg"]="施放者UID"},
					{["key"]="sendType",["type"]="Signed32",["msg"]="施放者类型"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--AddBufferInfo
				["msg"]="Buffer列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="buffId",["type"]="Signed32",["msg"]="bufferId"},
					{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
					{["key"]="rank",["type"]="Signed32",["msg"]="叠加层数"},
					{["key"]="time",["type"]="Signed32",["msg"]="剩余时间"},
					{["key"]="attackProperty",["type"]="Signed32",["msg"]="攻击属性"},
					{["key"]="damageValuePercent",["type"]="Signed32",["msg"]="伤害值百分比"},
					{["key"]="sendUid",["type"]="Signed64",["msg"]="施放者UID"},
					{["key"]="sendType",["type"]="Signed32",["msg"]="施放者类型"},
				}
			},
		}
	},

	["120203"] = { --刷新被动
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 20", --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 20", --未包含协议头部长度
		["req_func"] = "req_refresh_passive",
		["resp_func"] = "resp_refresh_passive",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--RefreshPassiveInfo
				["msg"]="被动状态列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="nodeId",["type"]="Signed32",["msg"]="被动节点ID"},
					{["key"]="usingCount",["type"]="Signed32",["msg"]="触发次数"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--RefreshPassiveInfo
				["msg"]="被动状态列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="nodeId",["type"]="Signed32",["msg"]="被动节点ID"},
					{["key"]="usingCount",["type"]="Signed32",["msg"]="触发次数"},
				}
			},
		}
	},

	["120204"] = { --被动技能
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "36 + num * 16", --未包含协议头部长度
		["resp_socket_size"] = "44 + num * 16", --未包含协议头部长度
		["req_func"] = "req_passive_skill",
		["resp_func"] = "resp_passive_skill",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
			{["key"]="targetCheck",["type"]="Signed32",["msg"]="目标检测"},
			{["key"]="delay",["type"]="Signed32",["msg"]="延迟"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ObjInfo
				["msg"]="被动列表",
				["struct"]=
				{
					{["key"]="objId",["type"]="Signed32",["msg"]="对象ID"},
					{["key"]="posX",["type"]="Signed32",["msg"]="坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="坐标z"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
			{["key"]="targetCheck",["type"]="Signed32",["msg"]="目标检测"},
			{["key"]="delay",["type"]="Signed32",["msg"]="延迟"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ObjInfo
				["msg"]="被动列表",
				["struct"]=
				{
					{["key"]="objId",["type"]="Signed32",["msg"]="对象ID"},
					{["key"]="posX",["type"]="Signed32",["msg"]="坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="坐标z"},
				}
			},
		}
	},

	["120205"] = { --状态改变
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 42", --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 42", --未包含协议头部长度
		["req_func"] = "req_change_state",
		["resp_func"] = "resp_change_state",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChangeStateInfo
				["msg"]="状态列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="state",["type"]="Signed16",["msg"]="状态"},
					{["key"]="time",["type"]="Signed32",["msg"]="持续时间"},
					{["key"]="startPosX",["type"]="Signed32",["msg"]="开始坐标x"},
					{["key"]="startPosY",["type"]="Signed32",["msg"]="开始坐标y"},
					{["key"]="startPosZ",["type"]="Signed32",["msg"]="开始坐标z"},
					{["key"]="endPosX",["type"]="Signed32",["msg"]="结束坐标x"},
					{["key"]="endPosY",["type"]="Signed32",["msg"]="结束坐标y"},
					{["key"]="endPosZ",["type"]="Signed32",["msg"]="结束坐标z"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChangeStateInfo
				["msg"]="属性列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="state",["type"]="Signed16",["msg"]="状态"},
					{["key"]="time",["type"]="Signed32",["msg"]="持续时间"},
					{["key"]="startPosX",["type"]="Signed32",["msg"]="开始坐标x"},
					{["key"]="startPosY",["type"]="Signed32",["msg"]="开始坐标y"},
					{["key"]="startPosZ",["type"]="Signed32",["msg"]="开始坐标z"},
					{["key"]="endPosX",["type"]="Signed32",["msg"]="结束坐标x"},
					{["key"]="endPosY",["type"]="Signed32",["msg"]="结束坐标y"},
					{["key"]="endPosZ",["type"]="Signed32",["msg"]="结束坐标z"},
				}
			},
		}
	},

	["120206"] = { --更新角色
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "8 + num * 24", --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 24", --未包含协议头部长度
		["req_func"] = "req_update_role",
		["resp_func"] = "resp_update_role",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--UpdateRoleInfo
				["msg"]="属性列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
					{["key"]="epCurrent",["type"]="Signed32",["msg"]="能量"},
					{["key"]="spCurrent",["type"]="Signed32",["msg"]="硬直/霸体"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--UpdateRoleInfo
				["msg"]="陷阱列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
					{["key"]="epCurrent",["type"]="Signed32",["msg"]="能量"},
					{["key"]="spCurrent",["type"]="Signed32",["msg"]="硬直/霸体"},
				}
			},
		}
	},

	["120207"] = { --召唤随从
		["module_name"] = "battle", --战斗指令
		["socket_type"] = "pvp",
		["req_socket_size"] = "32 + num * 28", --未包含协议头部长度
		["resp_socket_size"] = "40 + num * 28", --未包含协议头部长度
		["req_func"] = "req_call_retinue",
		["resp_func"] = "resp_call_retinue",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="callerAoiId",["type"]="Signed64",["msg"]="召唤者aoiId"},
			{["key"]="callerHeroId",["type"]="Signed32",["msg"]="召唤者英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
			{["key"]="lifeTime",["type"]="Signed32",["msg"]="持续时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--CallRetinueInfo
				["msg"]="随从列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="retinueId",["type"]="Signed32",["msg"]="随从ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
					{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="hostId",["type"]="Signed64",["msg"]="主机ID"},
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="callerAoiId",["type"]="Signed64",["msg"]="召唤者aoiId"},
			{["key"]="callerHeroId",["type"]="Signed32",["msg"]="召唤者英雄ID"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="skillLevel",["type"]="Signed32",["msg"]="技能等级"},
			{["key"]="lifeTime",["type"]="Signed32",["msg"]="持续时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--CallRetinueInfo
				["msg"]="随从列表",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="retinueId",["type"]="Signed32",["msg"]="随从ID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
					{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
				}
			},
		}
	},

	["120302"] = { --激活传送阵
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_active_station",
		["resp_func"] = "resp_active_station",
		["req_args"] =
		{
			{["key"]="stationId",["type"]="Signed32",["msg"]="需要激活的传送阵ID"},
		},
		["resp_args"] =
		{
			{["key"]="errCode",["type"]="Signed32",["msg"]="ErrorCode:0表示成功"},
			{["key"]="result",["type"]="Signed32",["msg"]="0-激活成功  1-直接传送"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
		}
	},

	["120303"] = { --离开大地图回城
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_back_to_city",
		["resp_func"] = "resp_back_to_city",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["120304"] = { --在大地图中切换场景
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_change_scene",
		["resp_func"] = "resp_change_scene",
		["req_args"] =
		{
			{["key"]="targetMap",["type"]="Signed32",["msg"]="切换的目标地图"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["120305"] = { --PVP服大地图任务状态改变（领取、失败、放弃）
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 17, --未包含协议头部长度
		["req_func"] = "req_task_status_change",
		["resp_func"] = "resp_task_status_change",
		["req_args"] =
		{
			{["key"]="mainTaskId",["type"]="Signed32",["msg"]="主任务ID（任务链ID）"},
			{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务ID"},
			{["key"]="childTaskStatus",["type"]="Signed32",["msg"]="子任务状态    @see  StatusTask"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="地图ID"},
		},
		["resp_args"] =
		{
			{["key"]="errCode",["type"]="Signed32",["msg"]="ErrorCode:0表示成功"},
			{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务ID"},
			{["key"]="childTaskStatus",["type"]="Signed32",["msg"]="子任务状态    @see  StatusTask"},
			{["key"]="reward",["type"]="Signed32",["msg"]="0-默认状态  1-体力值不足  2-发奖励"},
			{["key"]="isCycle",["type"]="Bool",["msg"]="是否可以循环接取（childTaskStatus值为完成状态2时有效）"},
		}
	},

	["120307"] = { --玩家点击ui界面完成任务，发放奖励，奖励根据队长的掉落发放
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 8", --未包含协议头部长度
		["req_func"] = "req_map_task_send_reward",
		["resp_func"] = "resp_map_task_send_reward",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="玩家uid"},
			{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务Id"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="errCode",["type"]="Signed32",["msg"]="ErrorCode:0表示成功"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="奖励物品",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["120308"] = { --任务完成条件为触发某个ui或者是对话的请求
		["module_name"] = "map", --大地图
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_map_task_u_i_click",
		["req_args"] =
		{
		},
	},

	["120401"] = { --激活cell
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = 48, --未包含协议头部长度
		["resp_socket_size"] = 48, --未包含协议头部长度
		["req_func"] = "req_active_cell",
		["resp_func"] = "resp_active_cell",
		["req_args"] =
		{
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
		},
		["resp_args"] =
		{
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
		}
	},

	["120402"] = { --大地图刷怪
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = 100, --未包含协议头部长度
		["resp_socket_size"] = 108, --未包含协议头部长度
		["req_func"] = "req_create_world_monster",
		["resp_func"] = "resp_create_world_monster",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
			{["key"]="monsterId",["type"]="Signed32",["msg"]="怪物ID"},
			{["key"]="sceneName",["type"]="UTF8String[16]",["msg"]="场景名"},
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
			{["key"]="spawnIndex",["type"]="Signed32",["msg"]="出生序号"},
			{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="出生坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="出生坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="出生坐标z"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
			{["key"]="monsterId",["type"]="Signed32",["msg"]="怪物ID"},
			{["key"]="sceneName",["type"]="UTF8String[16]",["msg"]="场景名"},
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
			{["key"]="spawnIndex",["type"]="Signed32",["msg"]="出生序号"},
			{["key"]="camp",["type"]="Signed32",["msg"]="阵营"},
			{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="出生坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="出生坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="出生坐标z"},
		}
	},

	["120403"] = { --地图怪物回收
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = 60, --未包含协议头部长度
		["resp_socket_size"] = 64, --未包含协议头部长度
		["req_func"] = "req_recycle_world_monster",
		["resp_func"] = "resp_recycle_world_monster",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
		},
		["resp_args"] =
		{
			{["key"]="cellId",["type"]="UTF8String[48]",["msg"]="cellID"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
		}
	},

	["120404"] = { --拾取掉落
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = "4 + num * 4", --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 4", --未包含协议头部长度
		["req_func"] = "req_pick_up",
		["resp_func"] = "resp_pick_up",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="掉落的唯一id列表",
			},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="uid",["type"]="Signed64",["msg"]="拾取的玩家uid"},
			{
				["key"]="list",
				["type"]="Signed32[$num]",
				["msg"]="掉落的唯一id列表",
			},
		}
	},

	["120405"] = { --大地图战斗中使用物品
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_battle_use",
		["resp_func"] = "resp_battle_use",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品ID"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果"},
		}
	},

	["120406"] = { --大地图中购买回复类道具
		["module_name"] = "map", --大地图刷怪
		["socket_type"] = "pvp",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_buy_resu_item",
		["resp_func"] = "resp_buy_resu_item",
		["req_args"] =
		{
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果"},
			{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
			{["key"]="count",["type"]="Signed32",["msg"]="数量"},
		}
	},

	["120601"] = { --创建怪物
		["module_name"] = "battle", --组队PVE
		["socket_type"] = "pvp",
		["req_socket_size"] = 136, --未包含协议头部长度
		["resp_socket_size"] = 144, --未包含协议头部长度
		["req_func"] = "req_create_monster",
		["resp_func"] = "resp_create_monster",
		["req_args"] =
		{
			{["key"]="orderIndex",["type"]="Signed32",["msg"]="指令序号"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
			{["key"]="monsterId",["type"]="Signed32",["msg"]="怪物ID"},
			{["key"]="towerId",["type"]="Signed32",["msg"]="刷怪塔ID"},
			{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="出生坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="出生坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="出生坐标z"},
			{["key"]="passiveList",["type"]="UTF8String[100]",["msg"]="被动列表"},
		},
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="mid",["type"]="Signed64",["msg"]="怪物唯一ID"},
			{["key"]="monsterId",["type"]="Signed32",["msg"]="怪物ID"},
			{["key"]="towerId",["type"]="Signed32",["msg"]="刷怪塔ID"},
			{["key"]="camp",["type"]="Signed32",["msg"]="阵营"},
			{["key"]="hpCurrent",["type"]="Signed32",["msg"]="血量"},
			{["key"]="posX",["type"]="Signed32",["msg"]="出生坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="出生坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="出生坐标z"},
			{["key"]="passiveList",["type"]="UTF8String[100]",["msg"]="被动列表"},
		}
	},

	["120611"] = { --显示伤害排行信息
		["module_name"] = "battle", --组队PVE
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 20", --未包含协议头部长度
		["req_func"] = "req_team_show_top",
		["resp_func"] = "resp_team_show_top",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TeamShowInfo
				["msg"]="成员信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="hpCurrent",["type"]="Signed32",["msg"]="当前血量"},
					{["key"]="hpMax",["type"]="Signed32",["msg"]="血量上限"},
					{["key"]="hurtValue",["type"]="Signed32",["msg"]="伤害值"},
				}
			},
		}
	},

	["120613"] = { --结算所有的拾取金币及物品
		["module_name"] = "battle", --组队PVE
		["socket_type"] = "pvp",
		["req_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_battle_drop_all",
		["resp_func"] = "resp_battle_drop_all",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="拾取的物品列表",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果1成功0失败"},
		}
	},

	["120701"] = { --游戏服的玩家数据
		["module_name"] = "test", --压测相关协议
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_player_data",
		["resp_func"] = "resp_player_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="战斗场景唯一标识"},
		}
	},

	["120801"] = { --BS远程执行代码
		["module_name"] = "monitor", --远程执行代码
		["socket_type"] = "pvp",
		["req_socket_size"] = "43 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = 500, --未包含协议头部长度
		["req_func"] = "req_remote_code_execute",
		["resp_func"] = "resp_remote_execute_result",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="remoteIP",["type"]="UTF8String[39]",["msg"]="来源服务器IP"},
			{
				["key"]="remoteCode",
				["type"]="Signed8[$num]",
				["msg"]="远程代码编译后产生的class文件的字节数组",
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="UTF8String[500]",["msg"]="远程代码的执行结果"},
		}
	},

	["120901"] = { --检查服务器连接状态
		["module_name"] = "system", --系统
		["socket_type"] = "pvp",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 21, --未包含协议头部长度
		["req_func"] = "req_check_connect_status",
		["resp_func"] = "resp_check_connect_status",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="form",["type"]="UTF8String[10]",["msg"]="起始服务器"},
			{["key"]="to",["type"]="UTF8String[10]",["msg"]="终止服务器"},
			{["key"]="status",["type"]="Signed8",["msg"]="状态 1:正常 "},
		}
	},

	["130001"] = { --登录到聊天服
		["module_name"] = "chat", --聊天服登入、登出模块
		["socket_type"] = "chat",
		["req_socket_size"] = 433, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_login",
		["resp_func"] = "resp_4_login",
		["req_args"] =
		{
			{["key"]="platId",["type"]="UTF8String[32]",["msg"]="平台ID, 即帐号"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="选择大区ID"},
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="组队id"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="工会id"},
			{["key"]="guildname",["type"]="UTF8String[32]",["msg"]="工会名称"},
			{["key"]="heroIcon",["type"]="Signed32",["msg"]="头像icon"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
			{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
			{["key"]="time",["type"]="Signed32",["msg"]="时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
			{["key"]="isMute",["type"]="Bool",["msg"]="禁言"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="登录成功1，失败0"},
		}
	},

	["130002"] = { --登出
		["module_name"] = "chat", --聊天服登入、登出模块
		["socket_type"] = "chat",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_logout",
		["resp_func"] = "resp_4_logout",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
		}
	},

	["130003"] = { --保持心跳
		["module_name"] = "chat", --聊天服登入、登出模块
		["socket_type"] = "chat",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_keep_online",
		["resp_func"] = "resp_4_keep_online",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
		}
	},

	["130004"] = { --聊天服数据同步
		["module_name"] = "chat", --聊天服登入、登出模块
		["socket_type"] = "chat",
		["req_socket_size"] = 116, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_data_sync",
		["resp_func"] = "resp_4_data_sync",
		["req_args"] =
		{
			{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
			{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
			{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
			{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
			{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
			{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
			{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
			{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
			{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
			{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
			{["key"]="arenaWinQuick",["type"]="Signed32",["msg"]="快速匹配胜利次数"},
			{["key"]="arenaRankTeam",["type"]="Signed32",["msg"]="3v3最高排名"},
			{["key"]="arenaRank",["type"]="Signed32",["msg"]="个人排位"},
			{["key"]="guildLevel",["type"]="Signed32",["msg"]="公会等级"},
			{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
		},
		["resp_args"] =
		{
		}
	},

	["130101"] = { --私聊
		["module_name"] = "chat", --聊天模块
		["socket_type"] = "chat",
		["req_socket_size"] = 264, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_send_private",
		["resp_func"] = "resp_4_send_private",
		["req_args"] =
		{
			{["key"]="target",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		},
		["resp_args"] =
		{
		}
	},

	["130102"] = { --队伍聊天
		["module_name"] = "chat", --聊天模块
		["socket_type"] = "chat",
		["req_socket_size"] = 256, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_send_team",
		["resp_func"] = "resp_4_send_team",
		["req_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		},
		["resp_args"] =
		{
		}
	},

	["130103"] = { --公会聊天
		["module_name"] = "chat", --聊天模块
		["socket_type"] = "chat",
		["req_socket_size"] = 256, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_send_guild",
		["resp_func"] = "resp_4_send_guild",
		["req_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		},
		["resp_args"] =
		{
		}
	},

	["130104"] = { --世界聊天
		["module_name"] = "chat", --聊天模块
		["socket_type"] = "chat",
		["req_socket_size"] = 296, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_send_world",
		["resp_func"] = "resp_4_send_world",
		["req_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
			{["key"]="time",["type"]="Signed64",["msg"]="时间戳(ms)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(游戏服扣除道具后，给的校验用的)"},
		},
		["resp_args"] =
		{
		}
	},

	["130105"] = { --私聊（按名字）
		["module_name"] = "chat", --聊天模块
		["socket_type"] = "chat",
		["req_socket_size"] = 296, --未包含协议头部长度
		["resp_socket_size"] = 296, --未包含协议头部长度
		["req_func"] = "req_send_private_by_name",
		["resp_func"] = "resp_4_send_private_by_name",
		["req_args"] =
		{
			{["key"]="targetName",["type"]="UTF8String[40]",["msg"]="目标名字"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		},
		["resp_args"] =
		{
			{["key"]="targetName",["type"]="UTF8String[40]",["msg"]="目标名字"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["130201"] = { --获得好友列表（等待返回）
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_friend_list",
		["resp_func"] = "resp_4_friend_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
		}
	},

	["130202"] = { --获得申请好友列表（等待返回）
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 503", --未包含协议头部长度
		["req_func"] = "req_apply_friend_list",
		["resp_func"] = "resp_4_apply_friend_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--FriendInfo
				["msg"]="好友列表",
				["struct"]=
				{
					{["key"]="uId",["type"]="Signed64",["msg"]="好友ID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
					{["key"]="icon",["type"]="Signed32",["msg"]="icon"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed8",["msg"]="等级"},
					{["key"]="vipLevel",["type"]="Signed8",["msg"]="Vip等级"},
					{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
					{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
					{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
					{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
					{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
					{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
					{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
					{["key"]="arenaWinQuick",["type"]="Signed32",["msg"]="快速匹配胜利次数"},
					{["key"]="arenaRankTeam",["type"]="Signed32",["msg"]="3v3最高排名"},
					{["key"]="arenaRank",["type"]="Signed32",["msg"]="个人排位"},
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="公会名称"},
					{["key"]="guildLevel",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
					{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于赠送验证"},
					{["key"]="offLineTime",["type"]="Signed32",["msg"]="下线时间"},
				}
			},
		}
	},

	["130203"] = { --添加好友
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 48, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_add_friend",
		["resp_func"] = "resp_4_add_friend",
		["req_args"] =
		{
			{["key"]="uId",["type"]="Signed64",["msg"]="玩家ID"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="1成功，0失败"},
			{["key"]="uid",["type"]="Signed64",["msg"]="玩家ID"},
		}
	},

	["130204"] = { --删除好友
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_delete_friend",
		["resp_func"] = "resp_4_delete_friend",
		["req_args"] =
		{
			{["key"]="uId",["type"]="Signed64",["msg"]="玩家ID"},
		},
		["resp_args"] =
		{
		}
	},

	["130205"] = { --处理申请好友
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 49, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_deal_with_apply_friend",
		["resp_func"] = "resp_4_deal_with_apply_friend",
		["req_args"] =
		{
			{["key"]="uId",["type"]="Signed64",["msg"]="玩家ID"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
			{["key"]="addOrDel",["type"]="Signed8",["msg"]="添加还是删除，0删除，1添加"},
		},
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="玩家ID"},
		}
	},

	["130206"] = { --搜索好友（等待返回）
		["module_name"] = "friend", --好友模块
		["socket_type"] = "chat",
		["req_socket_size"] = 40, --未包含协议头部长度
		["resp_socket_size"] = 386, --未包含协议头部长度
		["req_func"] = "req_search_friend",
		["resp_func"] = "resp_4_search_friend",
		["req_args"] =
		{
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
		},
		["resp_args"] =
		{
			{["key"]="uId",["type"]="Signed64",["msg"]="好友ID"},
			{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
			{["key"]="icon",["type"]="Signed32",["msg"]="icon"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
			{["key"]="level",["type"]="Signed8",["msg"]="等级"},
			{["key"]="vipLevel",["type"]="Signed8",["msg"]="Vip等级"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
			{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
			{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
			{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
			{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
			{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
			{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
			{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
			{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
		}
	},

	["130301"] = { --邀请好友帮忙
		["module_name"] = "oracle", --神谕
		["socket_type"] = "chat",
		["req_socket_size"] = 24, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_oracle_friend_invite",
		["resp_func"] = "resp_4_oracle_friend_invite",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="stage",["type"]="Signed32",["msg"]="神谕的等阶"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="神谕的触发时间"},
		},
		["resp_args"] =
		{
		}
	},

	["130302"] = { --邀请世界帮忙
		["module_name"] = "oracle", --神谕
		["socket_type"] = "chat",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_oracle_world_invite",
		["resp_func"] = "resp_4_oracle_world_invite",
		["req_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="stage",["type"]="Signed32",["msg"]="神谕的等阶"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="神谕的触发时间"},
		},
		["resp_args"] =
		{
		}
	},

	["130401"] = { --世界聊天邀请加入公会
		["module_name"] = "guild", --公会
		["socket_type"] = "chat",
		["req_socket_size"] = 66, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_guild_world_invite",
		["resp_func"] = "resp_4_guild_world_invite",
		["req_args"] =
		{
			{["key"]="userId",["type"]="Signed64",["msg"]="公会邀请者"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="inviteM",["type"]="UTF8String[50]",["msg"]="邀请消息"},
		},
		["resp_args"] =
		{
		}
	},

	["130501"] = { --邀请好友
		["module_name"] = "team", --组队邀请
		["socket_type"] = "chat",
		["req_socket_size"] = 20, --未包含协议头部长度
		["resp_socket_size"] = 328, --未包含协议头部长度
		["req_func"] = "req_team_friend_invite",
		["resp_func"] = "resp_4_team_friend_invite",
		["req_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="senderId",["type"]="Signed64",["msg"]="邀请者uid"},
			{["key"]="senderName",["type"]="UTF8String[40]",["msg"]="邀请者昵称"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="邀请者头像"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="邀请者头像URL"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="邀请发起时间"},
		}
	},

	["130502"] = { --邀请世界
		["module_name"] = "team", --组队邀请
		["socket_type"] = "chat",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 328, --未包含协议头部长度
		["req_func"] = "req_team_world_invite",
		["resp_func"] = "resp_4_team_world_invite",
		["req_args"] =
		{
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="senderId",["type"]="Signed64",["msg"]="邀请者uid"},
			{["key"]="senderName",["type"]="UTF8String[40]",["msg"]="邀请者昵称"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="邀请者头像"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="邀请者头像URL"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="邀请发起时间"},
		}
	},

	["130503"] = { --邀请公会
		["module_name"] = "team", --组队邀请
		["socket_type"] = "chat",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 328, --未包含协议头部长度
		["req_func"] = "req_team_guild_invite",
		["resp_func"] = "resp_4_team_guild_invite",
		["req_args"] =
		{
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="senderId",["type"]="Signed64",["msg"]="邀请者uid"},
			{["key"]="senderName",["type"]="UTF8String[40]",["msg"]="邀请者昵称"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="邀请者头像"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="邀请者头像URL"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="邀请发起时间"},
		}
	},

	["130601"] = { --检查服务器连接状态
		["module_name"] = "system", --系统
		["socket_type"] = "chat",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 21, --未包含协议头部长度
		["req_func"] = "req_check_connect_status",
		["resp_func"] = "resp_4_check_connect_status",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="form",["type"]="UTF8String[10]",["msg"]="起始服务器"},
			{["key"]="to",["type"]="UTF8String[10]",["msg"]="终止服务器"},
			{["key"]="status",["type"]="Signed8",["msg"]="状态 1:正常 "},
		}
	},

	["139901"] = { --测试:登录
		["module_name"] = "test", --测试模块，正式服需删除！！！
		["socket_type"] = "chat",
		["req_socket_size"] = 272, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_login",
		["resp_func"] = "resp_4_test_login",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="platId",["type"]="UTF8String[256]",["msg"]="platId同时也是nickName"},
			{["key"]="guildId",["type"]="Signed32",["msg"]="工会id"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="id"},
		},
		["resp_args"] =
		{
		}
	},

	["139902"] = { --测试:发送世界聊天
		["module_name"] = "test", --测试模块，正式服需删除！！！
		["socket_type"] = "chat",
		["req_socket_size"] = 256, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_send_world",
		["resp_func"] = "resp_4_test_send_world",
		["req_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="聊天内容"},
		},
		["resp_args"] =
		{
		}
	},

	["139903"] = { --测试:发送系统广播
		["module_name"] = "test", --测试模块，正式服需删除！！！
		["socket_type"] = "chat",
		["req_socket_size"] = 256, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_send_broadcast",
		["resp_func"] = "resp_4_test_send_broadcast",
		["req_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="聊天内容"},
		},
		["resp_args"] =
		{
		}
	},

	["139904"] = { --测试:Redis在线判断
		["module_name"] = "test", --测试模块，正式服需删除！！！
		["socket_type"] = "chat",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_online",
		["resp_func"] = "resp_4_test_online",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="id"},
		},
		["resp_args"] =
		{
		}
	},

	["140001"] = { --进入游戏
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_enter_game",
		["resp_func"] = "resp_enter_game_result",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="mapType",["type"]="Signed32",["msg"]="玩家当前所在的地图类型"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="玩家当前所在的场景ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="玩家当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="玩家当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="玩家当前坐标z"},
		}
	},

	["140002"] = { --玩家离线
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_logout",
		["req_args"] =
		{
			{["key"]="playerCtxId",["type"]="Signed32",["msg"]="玩家连接id"},
		},
	},

	["140005"] = { --场景传送
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["req_func"] = "req_transfer_scene",
		["resp_func"] = "resp_transfer_result",
		["req_args"] =
		{
			{["key"]="mapType",["type"]="Signed32",["msg"]="目标地图类型"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="目标地图ID"},
		},
		["resp_args"] =
		{
			{["key"]="mapType",["type"]="Signed32",["msg"]="玩家当前所在的地图类型"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="玩家当前所在的场景ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="玩家当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="玩家当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="玩家当前坐标z"},
		}
	},

	["140101"] = { --获得公会列表（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 97", --未包含协议头部长度
		["req_func"] = "req_guild_list",
		["resp_func"] = "resp_guild_list",
		["req_args"] =
		{
			{["key"]="pageNum",["type"]="Signed8",["msg"]="第几页"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="pageAcount",["type"]="Signed32",["msg"]="总页数"},
			{["key"]="currApplyCount",["type"]="Signed32",["msg"]="当前已申请公会的次数"},
			{["key"]="currJoinCount",["type"]="Signed32",["msg"]="当前已加入公会的次数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildInfo
				["msg"]="公会列表",
				["struct"]=
				{
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="num",["type"]="Signed32",["msg"]="人数"},
					{["key"]="maxNum",["type"]="Signed32",["msg"]="当前等级最大人数"},
					{["key"]="icon",["type"]="Signed32",["msg"]="图标ID"},
					{["key"]="chairman",["type"]="UTF8String[40]",["msg"]="会长名称"},
					{["key"]="applyState",["type"]="Signed8",["msg"]="该公会的申请状态"},
				}
			},
		}
	},

	["140102"] = { --获得公会信息列表（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "300 + num * 330", --未包含协议头部长度
		["req_func"] = "req_my_guild_info",
		["resp_func"] = "resp_my_guild_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="level",["type"]="Signed32",["msg"]="公会等级"},
			{["key"]="icon",["type"]="Signed32",["msg"]="图标ID"},
			{["key"]="buildpoint",["type"]="Signed32",["msg"]="建设度"},
			{["key"]="activity",["type"]="Signed32",["msg"]="公会活跃度"},
			{["key"]="money",["type"]="Signed32",["msg"]="公会资金"},
			{["key"]="mergeName",["type"]="UTF8String[28]",["msg"]="参与合并另一方名称"},
			{["key"]="mergeTime",["type"]="Signed32",["msg"]="合并申请时间"},
			{["key"]="notice",["type"]="UTF8String[200]",["msg"]="公告"},
			{["key"]="time",["type"]="Signed32",["msg"]="解散倒计时"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildMember
				["msg"]="公会成员列表(无序)",
				["struct"]=
				{
					{["key"]="icon",["type"]="Signed32",["msg"]="Icon"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="uId",["type"]="Signed64",["msg"]="角色ID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="等级"},
					{["key"]="position",["type"]="Signed8",["msg"]="职位"},
					{["key"]="status",["type"]="Signed8",["msg"]="上线状态"},
					{["key"]="contribute",["type"]="Signed32",["msg"]="历史贡献"},
					{["key"]="activity",["type"]="Signed32",["msg"]="当天活跃度"},
					{["key"]="vipLevel",["type"]="Signed32",["msg"]="等级"},
					{["key"]="onlineTime",["type"]="Signed32",["msg"]="最后在线时间"},
				}
			},
		}
	},

	["140103"] = { --申请公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_apply_guild",
		["req_args"] =
		{
			{["key"]="guildId",["type"]="Signed64",["msg"]="加入的公会ID"},
		},
	},

	["140104"] = { --获得申请列表（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 52", --未包含协议头部长度
		["req_func"] = "req_get_apply_list",
		["resp_func"] = "resp_get_apply_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ApplyMember
				["msg"]="公会列表",
				["struct"]=
				{
					{["key"]="uId",["type"]="Signed64",["msg"]="角色ID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="等级"},
				}
			},
		}
	},

	["140105"] = { --申请通过
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 9, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_allow_join",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="被审核的玩家ID"},
			{["key"]="pass",["type"]="Bool",["msg"]="是否通过"},
		},
	},

	["140106"] = { --退出公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["req_func"] = "req_exit_guild",
		["resp_func"] = "resp_exit_guild",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="退出的玩家ID"},
		},
		["resp_args"] =
		{
			{["key"]="guild",["type"]="Signed64",["msg"]="退出的玩家ID"},
		}
	},

	["140107"] = { --公会升降职
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 9, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 10", --未包含协议头部长度
		["req_func"] = "req_upgrade_position",
		["resp_func"] = "resp_upgrade_position",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="玩家ID"},
			{["key"]="newPosition",["type"]="Signed8",["msg"]="升降职标识"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="resInfos",
				["type"]="struct[$num]",	--UpgradePositionResInfo
				["msg"]="职位变动玩家列表",
				["struct"]=
				{
					{["key"]="uId",["type"]="Signed64",["msg"]="角色ID"},
					{["key"]="oldPosition",["type"]="Signed8",["msg"]="旧职位标识"},
					{["key"]="newPosition",["type"]="Signed8",["msg"]="新职位标识"},
				}
			},
		}
	},

	["140108"] = { --修改公会公告
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 200, --未包含协议头部长度
		["resp_socket_size"] = 200, --未包含协议头部长度
		["req_func"] = "req_edit_guild_info",
		["resp_func"] = "resp_guild_info",
		["req_args"] =
		{
			{["key"]="newInfo",["type"]="UTF8String[200]",["msg"]="公告信息"},
		},
		["resp_args"] =
		{
			{["key"]="newInfo",["type"]="UTF8String[200]",["msg"]="公告信息"},
		}
	},

	["140109"] = { --升级公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_upgrade_guild",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="建筑Type"},
		},
	},

	["140110"] = { --获得公会排行（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "104 + num * 97", --未包含协议头部长度
		["req_func"] = "req_guild_rank",
		["resp_func"] = "resp_guild_rank",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="level",["type"]="Signed32",["msg"]="公会等级"},
			{["key"]="memberNum",["type"]="Signed32",["msg"]="人数"},
			{["key"]="icon",["type"]="Signed32",["msg"]="图标ID"},
			{["key"]="chairman",["type"]="UTF8String[40]",["msg"]="会长名称"},
			{["key"]="buildpoint",["type"]="Signed32",["msg"]="建设度"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildInfo
				["msg"]="公会列表",
				["struct"]=
				{
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="num",["type"]="Signed32",["msg"]="人数"},
					{["key"]="maxNum",["type"]="Signed32",["msg"]="当前等级最大人数"},
					{["key"]="icon",["type"]="Signed32",["msg"]="图标ID"},
					{["key"]="chairman",["type"]="UTF8String[40]",["msg"]="会长名称"},
					{["key"]="applyState",["type"]="Signed8",["msg"]="该公会的申请状态"},
				}
			},
		}
	},

	["140111"] = { --解散工会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_disappear",
		["resp_func"] = "resp_disappear",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="time",["type"]="Signed32",["msg"]="解散公会倒计时"},
		}
	},

	["140112"] = { --会长让位
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_leader",
		["req_args"] =
		{
			{["key"]="newLeaderId",["type"]="Signed64",["msg"]="新会长ID"},
		},
	},

	["140113"] = { --搜索公会（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 97, --未包含协议头部长度
		["req_func"] = "req_search_guild",
		["resp_func"] = "resp_search_guild",
		["req_args"] =
		{
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
		},
		["resp_args"] =
		{
			{
				["key"]="guild",
				["type"]="struct",	--GuildInfo
				["msg"]="公会信息",
				["struct"]=
				{
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="name",["type"]="UTF8String[32]",["msg"]="公会名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="num",["type"]="Signed32",["msg"]="人数"},
					{["key"]="maxNum",["type"]="Signed32",["msg"]="当前等级最大人数"},
					{["key"]="icon",["type"]="Signed32",["msg"]="图标ID"},
					{["key"]="chairman",["type"]="UTF8String[40]",["msg"]="会长名称"},
					{["key"]="applyState",["type"]="Signed8",["msg"]="该公会的申请状态"},
				}
			},
		}
	},

	["140114"] = { --合并公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_merge_guild",
		["req_args"] =
		{
			{["key"]="guildId",["type"]="Signed32",["msg"]="公会ID"},
		},
	},

	["140115"] = { --合并公会回复
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_merge_answer",
		["req_args"] =
		{
			{["key"]="answer",["type"]="Bool",["msg"]="回复是拒绝还是同意"},
		},
	},

	["140116"] = { --获取公会日志（等待返回）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 75", --未包含协议头部长度
		["req_func"] = "req_guild_log",
		["resp_func"] = "resp_guild_log",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuiLdLog
				["msg"]="日志列表(无序)",
				["struct"]=
				{
					{["key"]="key",["type"]="UTF8String[20]",["msg"]="key值"},
					{["key"]="value",["type"]="UTF8String[50]",["msg"]="参数Value，多参数用#,#隔开"},
					{["key"]="date",["type"]="UTF8String[5]",["msg"]="日期"},
				}
			},
		}
	},

	["140117"] = { --取消公会解散
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_cancel_disappear",
		["req_args"] =
		{
		},
	},

	["140118"] = { --获得boss界面信息
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["req_func"] = "req_get_guild_boss_info",
		["resp_func"] = "resp_send_guild_boss_info",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="bossHp",["type"]="Signed32",["msg"]="BossHp"},
			{["key"]="hasBattledNum",["type"]="Signed32",["msg"]="已挑战次数"},
			{["key"]="progress",["type"]="Signed32",["msg"]="Boss进度"},
		}
	},

	["140119"] = { --开启boss
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_active_boss",
		["req_args"] =
		{
			{["key"]="bossId",["type"]="Signed32",["msg"]="BossId"},
		},
	},

	["140120"] = { --获得队伍列表
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 52", --未包含协议头部长度
		["req_func"] = "req_get_boss_battle_team_list",
		["resp_func"] = "resp_send_boss_battle_team_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--BossTeam
				["msg"]="队伍列表",
				["struct"]=
				{
					{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍编号"},
					{["key"]="leaderName",["type"]="UTF8String[40]",["msg"]="队长名称"},
					{["key"]="playerNum",["type"]="Signed32",["msg"]="人数"},
					{["key"]="BossId",["type"]="Signed32",["msg"]="BossId"},
				}
			},
		}
	},

	["140121"] = { --公会BOOS战创建队伍
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_create_boss_battle_team",
		["req_args"] =
		{
			{["key"]="bossId",["type"]="Signed32",["msg"]="bossId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄Id"},
			{["key"]="heroLevel",["type"]="Signed32",["msg"]="英雄等级"},
		},
	},

	["140122"] = { --公会BOOS战退出队伍
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_exit_boss_battle_team",
		["req_args"] =
		{
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍编号"},
			{["key"]="uid",["type"]="Signed64",["msg"]="Uid"},
		},
	},

	["140123"] = { --公会BOOS战更换英雄
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_hero",
		["req_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="heroLevel",["type"]="Signed32",["msg"]="英雄等级"},
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍编号"},
		},
	},

	["140124"] = { --邀请（快速邀请）
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_invite_player",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="邀请人的UID（快速邀请填）"},
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍编号"},
		},
	},

	["140125"] = { --公会BOOS战加入队伍
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_enter_team",
		["req_args"] =
		{
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍编号"},
			{["key"]="bossId",["type"]="Signed32",["msg"]="bossId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄Id"},
			{["key"]="heroLevel",["type"]="Signed32",["msg"]="英雄等级"},
		},
	},

	["140127"] = { --获得建筑列表
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 12", --未包含协议头部长度
		["req_func"] = "req_get_build_list",
		["resp_func"] = "resp_send_build_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--Building
				["msg"]="建筑列表",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="建筑类型"},
					{["key"]="level",["type"]="Signed32",["msg"]="等级"},
					{["key"]="upgradeTime",["type"]="Signed32",["msg"]="升级时间：-1表示可升级，0表示升级倒计时已满，大于0表示需要显示升级倒计时"},
				}
			},
		}
	},

	["140128"] = { --获得公会状态
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 5, --未包含协议头部长度
		["req_func"] = "req_get_guild_status",
		["resp_func"] = "resp_send_guild_status",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="status",["type"]="Signed8",["msg"]="状态，1解散，2合并"},
			{["key"]="timeCount",["type"]="Signed32",["msg"]="倒计时秒数"},
		}
	},

	["140129"] = { --获得申请公会记录
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_apply_record",
		["resp_func"] = "resp_apply_record",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="Signed64[$num]",
				["msg"]="公会id列表",
			},
		}
	},

	["140130"] = { --修改公会图标
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_change_guild_icon",
		["req_args"] =
		{
			{["key"]="icon",["type"]="Signed32",["msg"]="公会等级"},
		},
	},

	["140132"] = { --获得得可任命的公会成员
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 330", --未包含协议头部长度
		["req_func"] = "req_take_offer_list",
		["resp_func"] = "resp_take_offer_list",
		["req_args"] =
		{
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GuildMember
				["msg"]="可任命的公会成员列表",
				["struct"]=
				{
					{["key"]="icon",["type"]="Signed32",["msg"]="Icon"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="uId",["type"]="Signed64",["msg"]="角色ID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="名称"},
					{["key"]="level",["type"]="Signed32",["msg"]="等级"},
					{["key"]="position",["type"]="Signed8",["msg"]="职位"},
					{["key"]="status",["type"]="Signed8",["msg"]="上线状态"},
					{["key"]="contribute",["type"]="Signed32",["msg"]="历史贡献"},
					{["key"]="activity",["type"]="Signed32",["msg"]="当天活跃度"},
					{["key"]="vipLevel",["type"]="Signed32",["msg"]="等级"},
					{["key"]="onlineTime",["type"]="Signed32",["msg"]="最后在线时间"},
				}
			},
		}
	},

	["140133"] = { --世界聊天邀请加入公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_invite_player_in_to_guild_by_chat",
		["req_args"] =
		{
			{["key"]="reqInviterUid",["type"]="Signed64",["msg"]="邀请方玩家id"},
			{["key"]="inviteGuildId",["type"]="Signed64",["msg"]="邀请加入的公会id"},
		},
	},

	["140134"] = { --主城邀请加入公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 16, --未包含协议头部长度
		["resp_socket_size"] = 5, --未包含协议头部长度
		["req_func"] = "req_invite_player_in_to_guild_by_city",
		["resp_func"] = "resp_invite_player_in_to_guild_by_city",
		["req_args"] =
		{
			{["key"]="invitedUid",["type"]="Signed64",["msg"]="被邀请方玩家id"},
			{["key"]="inviteGuildId",["type"]="Signed64",["msg"]="邀请加入的公会id"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed8",["msg"]="结果：1：邀请成功 0：邀请失败(具体看msg)"},
			{["key"]="msg",["type"]="Signed32",["msg"]="邀请失败原因：1：对方已有公会,2:公会已满员,3:玩家等级不足，不能加入公会,4:玩家每日被邀请次数已达上限"},
		}
	},

	["140135"] = { --被邀请的玩家同意加入公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 25, --未包含协议头部长度
		["resp_socket_size"] = 9, --未包含协议头部长度
		["req_func"] = "req_agree_in_to_guild",
		["resp_func"] = "resp_agree_in_to_guild",
		["req_args"] =
		{
			{["key"]="reqInviterUid",["type"]="Signed64",["msg"]="邀请方玩家id"},
			{["key"]="invitedUid",["type"]="Signed64",["msg"]="被邀请方玩家id"},
			{["key"]="inviteGuildId",["type"]="Signed64",["msg"]="邀请加入的公会id"},
			{["key"]="isAgree",["type"]="Signed8",["msg"]="标识位,1:表示接受,0:表示拒绝"},
		},
		["resp_args"] =
		{
			{["key"]="res",["type"]="Signed8",["msg"]="邀请加入的公会操作结果"},
			{["key"]="inviteGuildId",["type"]="Signed64",["msg"]="邀请加入的公会id"},
		}
	},

	["140136"] = { --主城被邀请公会列表
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 52", --未包含协议头部长度
		["req_func"] = "req_take_invited_list",
		["resp_func"] = "resp_take_invited_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="invitedList",
				["type"]="struct[$num]",	--InvitedGuildList
				["msg"]="被邀请列表",
				["struct"]=
				{
					{["key"]="invitedId",["type"]="Signed64",["msg"]="邀请者ID"},
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="guildIcon",["type"]="Signed32",["msg"]="公会头像ID"},
					{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="公会名"},
				}
			},
		}
	},

	["140201"] = { --获取排行榜数据
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "72 + num * 68", --未包含协议头部长度
		["req_func"] = "req_top_list",
		["resp_func"] = "resp_top_list",
		["req_args"] =
		{
			{["key"]="start",["type"]="Signed32",["msg"]="起始排名(1开始)"},
			{["key"]="end",["type"]="Signed32",["msg"]="结束排名"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="myself",
				["type"]="struct",	--TopListInfo
				["msg"]="排行数据列表",
				["struct"]=
				{
					{["key"]="rank",["type"]="Signed32",["msg"]="排名(从1开始)，-1表示未上榜"},
					{["key"]="uid",["type"]="Signed64",["msg"]="uid，0表示从未参加过竞技场"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="win",["type"]="Signed32",["msg"]="胜次"},
					{["key"]="lose",["type"]="Signed32",["msg"]="败次"},
					{["key"]="score",["type"]="Signed32",["msg"]="积分"},
					{["key"]="grade",["type"]="Signed32",["msg"]="段位"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TopListInfo
				["msg"]="排行数据列表",
				["struct"]=
				{
					{["key"]="rank",["type"]="Signed32",["msg"]="排名(从1开始)，-1表示未上榜"},
					{["key"]="uid",["type"]="Signed64",["msg"]="uid，0表示从未参加过竞技场"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="win",["type"]="Signed32",["msg"]="胜次"},
					{["key"]="lose",["type"]="Signed32",["msg"]="败次"},
					{["key"]="score",["type"]="Signed32",["msg"]="积分"},
					{["key"]="grade",["type"]="Signed32",["msg"]="段位"},
				}
			},
		}
	},

	["140202"] = { --获取排行榜历史冠军
		["module_name"] = "arena", --竞技场
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 68", --未包含协议头部长度
		["req_func"] = "req_arena_history",
		["resp_func"] = "resp_arena_history",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ArenaHistoryInfo
				["msg"]="数据列表",
				["struct"]=
				{
					{["key"]="season",["type"]="Signed32",["msg"]="赛季"},
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="win",["type"]="Signed32",["msg"]="胜次"},
					{["key"]="lose",["type"]="Signed32",["msg"]="败次"},
					{["key"]="score",["type"]="Signed32",["msg"]="积分"},
					{["key"]="grade",["type"]="Signed32",["msg"]="段位"},
				}
			},
		}
	},

	["140501"] = { --查询目标信息
		["module_name"] = "system", --查询各种信息
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = 420, --未包含协议头部长度
		["req_func"] = "req_chat_target",
		["resp_func"] = "resp_chat_target",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="目标uid"},
		},
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="名称"},
			{["key"]="level",["type"]="Signed32",["msg"]="等级"},
			{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
			{["key"]="firstHero",["type"]="Signed32",["msg"]="主控英雄"},
			{["key"]="firstLevel",["type"]="Signed32",["msg"]="主英雄等级"},
			{["key"]="firstExp",["type"]="Signed32",["msg"]="主英雄当前等级经验"},
			{["key"]="firstStage",["type"]="Signed32",["msg"]="主英雄魂阶"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="副英雄"},
			{["key"]="secondLevel",["type"]="Signed32",["msg"]="副英雄等级"},
			{["key"]="secondExp",["type"]="Signed32",["msg"]="副英雄当前等级经验"},
			{["key"]="secondStage",["type"]="Signed32",["msg"]="副英雄魂阶"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
			{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
			{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
			{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
			{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
			{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
			{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
			{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
			{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
		}
	},

	["140502"] = { --游戏公告
		["module_name"] = "system", --查询各种信息
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 3218", --未包含协议头部长度
		["req_func"] = "req_game_notice",
		["resp_func"] = "resp_game_notice",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--NoticeInfo
				["msg"]="公告列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="自增的uid"},
					{["key"]="type",["type"]="Signed32",["msg"]="类型:1纯文本 2文本+按钮+链接 3图+链接"},
					{["key"]="title",["type"]="UTF8String[40]",["msg"]="标题"},
					{["key"]="content",["type"]="UTF8String[3000]",["msg"]="内容"},
					{["key"]="startTime",["type"]="Signed32",["msg"]="开始的时间戳"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="结束的时间戳"},
					{["key"]="order",["type"]="Signed32",["msg"]="排序字段"},
					{["key"]="eventId",["type"]="Signed32",["msg"]="跳转功能/触发事件id"},
					{["key"]="picId",["type"]="UTF8String[50]",["msg"]="显示图片id"},
					{["key"]="url",["type"]="UTF8String[100]",["msg"]="跳转url"},
				}
			},
		}
	},

	["140503"] = { --查看未处理的消息
		["module_name"] = "system", --查询各种信息
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_message_list",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="赠送的类型：1秘币2混沌之渊3黑暗之境4派遣5失落遗迹"},
		},
	},

	["140602"] = { --结算
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 144, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_end",
		["req_args"] =
		{
			{["key"]="battleId",["type"]="Signed32",["msg"]="战斗id"},
			{["key"]="myTeam",["type"]="UTF8String[70]",["msg"]="自己的攻击阵型"},
			{["key"]="targetTeam",["type"]="UTF8String[70]",["msg"]="目标防守阵型, 死亡的英雄id用负数"},
		},
	},

	["140603"] = { --查看战斗记录
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = "5 + num * 261", --未包含协议头部长度
		["req_func"] = "req_challenge_record",
		["resp_func"] = "resp_challenge_record",
		["req_args"] =
		{
			{["key"]="isAttack",["type"]="Bool",["msg"]="true:攻击记录, false:防守记录"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="isAttack",["type"]="Bool",["msg"]="true:攻击记录, false:防守记录"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChallengeRecord
				["msg"]="7天内的最近20条记录",
				["struct"]=
				{
					{["key"]="attacker",["type"]="Signed64",["msg"]="攻击方uid"},
					{["key"]="aName",["type"]="UTF8String[40]",["msg"]="攻击方名字"},
					{["key"]="aIcon",["type"]="Signed32",["msg"]="攻击方头像"},
					{["key"]="aLevel",["type"]="Signed32",["msg"]="攻击方角色等级"},
					{["key"]="aTeam",["type"]="UTF8String[70]",["msg"]="攻击方阵型, 负数表示阵亡"},
					{["key"]="defender",["type"]="Signed64",["msg"]="防守方uid"},
					{["key"]="dName",["type"]="UTF8String[40]",["msg"]="防守方名字"},
					{["key"]="dIcon",["type"]="Signed32",["msg"]="防守方头像"},
					{["key"]="dLevel",["type"]="Signed32",["msg"]="防守方角色等级"},
					{["key"]="dTeam",["type"]="UTF8String[70]",["msg"]="防守方阵型, 负数表示阵亡"},
					{["key"]="isAttackWin",["type"]="Bool",["msg"]="是否攻方胜利"},
					{["key"]="createTime",["type"]="Signed32",["msg"]="战斗开始时间"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="战斗结束时间"},
				}
			},
		}
	},

	["140604"] = { --查看阵型
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 1, --未包含协议头部长度
		["resp_socket_size"] = 71, --未包含协议头部长度
		["req_func"] = "req_challenge_team",
		["resp_func"] = "resp_challenge_team",
		["req_args"] =
		{
			{["key"]="isAttack",["type"]="Bool",["msg"]="true:攻击阵型, false:防守阵型"},
		},
		["resp_args"] =
		{
			{["key"]="isAttack",["type"]="Bool",["msg"]="true:攻击阵型, false:防守阵型"},
			{["key"]="teamInfo",["type"]="UTF8String[70]",["msg"]="阵型"},
		}
	},

	["140605"] = { --查看排行榜
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "146 + num * 142", --未包含协议头部长度
		["req_func"] = "req_challenge_rank_list",
		["resp_func"] = "resp_challenge_rank_list",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="myPlayer",
				["type"]="struct",	--ChallengeTopPlayer
				["msg"]="自己的信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="layer",["type"]="Signed32",["msg"]="层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="排行(从1开始)"},
					{["key"]="rewardType",["type"]="Signed32",["msg"]="排名奖励类型"},
					{["key"]="rewardNum",["type"]="Signed32",["msg"]="排名奖励"},
					{["key"]="teamDef",["type"]="UTF8String[70]",["msg"]="防守阵型布阵信息"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChallengeTopPlayer
				["msg"]="排名前20的玩家信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="layer",["type"]="Signed32",["msg"]="层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="排行(从1开始)"},
					{["key"]="rewardType",["type"]="Signed32",["msg"]="排名奖励类型"},
					{["key"]="rewardNum",["type"]="Signed32",["msg"]="排名奖励"},
					{["key"]="teamDef",["type"]="UTF8String[70]",["msg"]="防守阵型布阵信息"},
				}
			},
		}
	},

	["140606"] = { --领取池里面的奖励
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_challenge_reward",
		["req_args"] =
		{
		},
	},

	["140701"] = { --查看神谕
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 8, --未包含协议头部长度
		["resp_socket_size"] = "41 + num * 374", --未包含协议头部长度
		["req_func"] = "req_oracle_info",
		["resp_func"] = "resp_oracle_info",
		["req_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="creator",["type"]="Signed64",["msg"]="触发者uid"},
			{["key"]="stage",["type"]="Signed32",["msg"]="所处阶段"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="触发的时间"},
			{["key"]="isCompleted",["type"]="Bool",["msg"]="是否已经全部完成"},
			{["key"]="monster1",["type"]="Signed32",["msg"]="刷怪id"},
			{["key"]="monster2",["type"]="Signed32",["msg"]="刷怪id"},
			{["key"]="monster3",["type"]="Signed32",["msg"]="刷怪id"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OraclePlayer
				["msg"]="玩家信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid, 0表示此位置没有玩家"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="guildId",["type"]="Signed64",["msg"]="工会id"},
					{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="工会名"},
					{["key"]="firstHero",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstLevel",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="secondHero",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondLevel",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="isWin",["type"]="Bool",["msg"]="是否胜利了"},
					{["key"]="isReward",["type"]="Bool",["msg"]="是否已经领取奖励"},
					{["key"]="relation",["type"]="Signed32",["msg"]="与神谕触发者的关系(非即时的!!!!!!!!)"},
				}
			},
		}
	},

	["140702"] = { --查看神谕协助记录
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 81", --未包含协议头部长度
		["req_func"] = "req_oracle_record",
		["resp_func"] = "resp_oracle_record",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OracleRecord
				["msg"]="最近5条记录",
				["struct"]=
				{
					{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
					{["key"]="creator",["type"]="Signed64",["msg"]="uid"},
					{["key"]="pos",["type"]="Signed32",["msg"]="位置"},
					{["key"]="helper",["type"]="Signed64",["msg"]="uid"},
					{["key"]="helperName",["type"]="UTF8String[40]",["msg"]="协助者名字"},
					{["key"]="relation",["type"]="Signed32",["msg"]="与神谕触发者关系"},
					{["key"]="startTime",["type"]="Signed32",["msg"]="战斗开始时间"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="战斗结束时间"},
					{["key"]="isWin",["type"]="Bool",["msg"]="是否赢"},
				}
			},
		}
	},

	["140704"] = { --领取神谕奖励
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 12, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_oracle_reward",
		["req_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一ID"},
			{["key"]="pos",["type"]="Signed32",["msg"]="1, 2, 3"},
		},
	},

	["140801"] = { --新增反馈
		["module_name"] = "system", --玩家反馈
		["socket_type"] = "game",
		["req_socket_size"] = 696, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_add_feedback",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="反馈类型：1游戏异常 2建议"},
			{["key"]="content",["type"]="UTF8String[500]",["msg"]="反馈内容"},
			{["key"]="channel",["type"]="UTF8String[32]",["msg"]="客户端渠道"},
			{["key"]="phone",["type"]="UTF8String[32]",["msg"]="电话"},
			{["key"]="model",["type"]="UTF8String[32]",["msg"]="机型"},
			{["key"]="version",["type"]="UTF8String[32]",["msg"]="客户端版本"},
			{["key"]="gameAddress",["type"]="UTF8String[32]",["msg"]="玩家游戏所在场景"},
			{["key"]="lifeAddress",["type"]="UTF8String[32]",["msg"]="玩家现实生活当前所属地域"},
		},
	},

	["140802"] = { --查询反馈
		["module_name"] = "system", --玩家反馈
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_query_feedback",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="反馈类型：1游戏异常 2建议"},
		},
	},

	["140901"] = { --重连
		["module_name"] = "system", --重连
		["socket_type"] = "game",
		["req_socket_size"] = 52, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_reconnect",
		["resp_func"] = "resp_reconnect",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="角色ID"},
			{["key"]="time",["type"]="Signed32",["msg"]="时间"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
			{["key"]="psKey",["type"]="UTF8String[8]",["msg"]="代理服连接key"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0:失败, 1:成功"},
		}
	},

	["141001"] = { --查看NPCRank排行数据
		["module_name"] = "npcrank", --排行榜
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = "74 + num * 66", --未包含协议头部长度
		["req_func"] = "req_n_p_c_rank_list",
		["resp_func"] = "resp_n_p_c_rank_list",
		["req_args"] =
		{
			{["key"]="type",["type"]="Signed16",["msg"]="排行榜类型:1 熟练度"},
			{["key"]="page",["type"]="Signed16",["msg"]="页数"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="type",["type"]="Signed16",["msg"]="排行榜类型:1 熟练度"},
			{["key"]="page",["type"]="Signed16",["msg"]="页数"},
			{
				["key"]="myself",
				["type"]="struct",	--NPCRankListInfo
				["msg"]="当前玩家的排行信息",
				["struct"]=
				{
					{["key"]="rank",["type"]="Signed32",["msg"]="排名(从1开始)，-1表示未上榜"},
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="level",["type"]="Signed16",["msg"]="玩家等级"},
					{["key"]="rankScore",["type"]="Signed32",["msg"]="排行榜分数,对应排行榜类型显示"},
					{["key"]="additional",["type"]="Signed32",["msg"]="备用字段(当type=2,此字段表示黑暗之境通关时间,当type=4,表示段位分)"},
					{["key"]="additional2",["type"]="Signed32",["msg"]="备用字段"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--NPCRankListInfo
				["msg"]="排行数据列表",
				["struct"]=
				{
					{["key"]="rank",["type"]="Signed32",["msg"]="排名(从1开始)，-1表示未上榜"},
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="level",["type"]="Signed16",["msg"]="玩家等级"},
					{["key"]="rankScore",["type"]="Signed32",["msg"]="排行榜分数,对应排行榜类型显示"},
					{["key"]="additional",["type"]="Signed32",["msg"]="备用字段(当type=2,此字段表示黑暗之境通关时间,当type=4,表示段位分)"},
					{["key"]="additional2",["type"]="Signed32",["msg"]="备用字段"},
				}
			},
		}
	},

	["141002"] = { --获取所有类型排行榜中自己的位置
		["module_name"] = "npcrank", --排行榜
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["req_func"] = "req_players_n_p_c_rank_all",
		["resp_func"] = "resp_players_n_p_c_rank_all",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PlayerNPCRank
				["msg"]="排行数据列表",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="排行榜类型"},
					{["key"]="rank",["type"]="Signed32",["msg"]="排名(从1开始)，-1表示未上榜"},
				}
			},
		}
	},

	["141101"] = { --WS远程执行代码
		["module_name"] = "monitor", --远程执行代码
		["socket_type"] = "game",
		["req_socket_size"] = "43 + num * 1", --未包含协议头部长度
		["resp_socket_size"] = 500, --未包含协议头部长度
		["req_func"] = "req_remote_code_execute",
		["resp_func"] = "resp_remote_execute_result",
		["req_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="remoteIP",["type"]="UTF8String[39]",["msg"]="来源服务器IP"},
			{
				["key"]="remoteCode",
				["type"]="Signed8[$num]",
				["msg"]="远程代码编译后产生的class文件的字节数组",
			},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="UTF8String[500]",["msg"]="远程代码的执行结果"},
		}
	},

	["141201"] = { --获取兑换码功能开启状态
		["module_name"] = "cdkey", --兑换码
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_get_cdkey_open_status",
		["resp_func"] = "resp_get_cdkey_open_status",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1开启, 0未开启"},
		}
	},

	["141202"] = { --获取分享码、分享链接等信息
		["module_name"] = "cdkey", --兑换码
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 321, --未包含协议头部长度
		["req_func"] = "req_get_operate_act_extra_data",
		["resp_func"] = "resp_get_operate_act_extra_data",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="homeURL",["type"]="UTF8String[100]",["msg"]="社交平台首页链接"},
			{["key"]="shareURL",["type"]="UTF8String[100]",["msg"]="分享链接"},
			{["key"]="cdkey",["type"]="UTF8String[21]",["msg"]="分享码"},
			{["key"]="spare",["type"]="UTF8String[100]",["msg"]="备用字段"},
		}
	},

	["149901"] = { --测试：增加池里面的奖励
		["module_name"] = "test", --测试接口
		["socket_type"] = "game",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_add_cp_pool",
		["req_args"] =
		{
			{["key"]="count",["type"]="Signed32",["msg"]="点数"},
		},
	},

	["149902"] = { --测试：测试邮件
		["module_name"] = "test", --测试接口
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_test_system_mail",
		["req_args"] =
		{
		},
	},

	["160001"] = { --登录排队服
		["module_name"] = "queue", --排队
		["socket_type"] = "game",
		["req_socket_size"] = 44, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_login",
		["resp_func"] = "resp_login",
		["req_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="time",["type"]="Signed32",["msg"]="时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="登录成功1，失败0"},
		}
	},

	["160002"] = { --登出排队服
		["module_name"] = "queue", --排队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_logout",
		["req_args"] =
		{
		},
	},

	["170001"] = { --保持心跳
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_heart_beat",
		["resp_func"] = "resp_heart_beat",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="time",["type"]="Signed32",["msg"]="时间"},
		}
	},

	["170002"] = { --检查服务器连接状态
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 21, --未包含协议头部长度
		["req_func"] = "req_check_connect_status",
		["resp_func"] = "resp_check_connect_status",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="form",["type"]="UTF8String[10]",["msg"]="起始服务器"},
			{["key"]="to",["type"]="UTF8String[10]",["msg"]="终止服务器"},
			{["key"]="status",["type"]="Signed8",["msg"]="状态 1:正常 "},
		}
	},

	["180002"] = { --服务器列表
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 10, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 123", --未包含协议头部长度
		["req_func"] = "req_zone_list",
		["resp_func"] = "resp_zone_list",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark"},
		},
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ServerInfo
				["msg"]="服务器列表",
				["struct"]=
				{
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
		}
	},

	["180003"] = { --游戏公告
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4084, --未包含协议头部长度
		["resp_func"] = "resp_news",
		["resp_args"] =
		{
			{["key"]="newstitle",["type"]="UTF8String[80]",["msg"]="登录公告标题"},
			{["key"]="newspaper",["type"]="UTF8String[4000]",["msg"]="登录公告内容"},
			{["key"]="flag",["type"]="Signed32",["msg"]="1要显示公告0不用处理"},
		}
	},

	["180004"] = { --获取聊天服地址
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 80, --未包含协议头部长度
		["req_func"] = "req_chat_server",
		["resp_func"] = "resp_chat_server",
		["req_args"] =
		{
			{["key"]="zoneId",["type"]="Signed32",["msg"]="选择登陆的区"},
		},
		["resp_args"] =
		{
			{["key"]="backupDomain",["type"]="UTF8String[40]",["msg"]="备用聊天服 ip:port"},
			{["key"]="defaultDomain",["type"]="UTF8String[40]",["msg"]="默认聊天服 ip:port"},
		}
	},

	["180005"] = { --登录控制，需要延时登录的通知
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 104, --未包含协议头部长度
		["resp_func"] = "resp_busy",
		["resp_args"] =
		{
			{["key"]="waitSecond",["type"]="Signed32",["msg"]="等待x秒后才能再请求登录"},
			{["key"]="msg",["type"]="UTF8String[100]",["msg"]="提示信息"},
		}
	},

	["180006"] = { --检查是否可以登录
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 4, --未包含协议头部长度
		["resp_socket_size"] = 5, --未包含协议头部长度
		["req_func"] = "req_check_zone",
		["resp_func"] = "resp_check_zone",
		["req_args"] =
		{
			{["key"]="zoneId",["type"]="Signed32",["msg"]="选择登陆的区"},
		},
		["resp_args"] =
		{
			{["key"]="success",["type"]="Signed8",["msg"]="可以登录1，不可以0"},
			{["key"]="errCode",["type"]="Signed32",["msg"]="1:注册达到上限"},
		}
	},

	["180007"] = { --银汉日志相关协议 @Deprecated 20180104 by King
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 235, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_y_h_log_parm",
		["req_args"] =
		{
			{["key"]="operator",["type"]="UTF8String[4]",["msg"]="运营商"},
			{["key"]="net",["type"]="UTF8String[8]",["msg"]="网络环境，2g/3g/4g/wifi等"},
			{["key"]="modelType",["type"]="UTF8String[10]",["msg"]="终端型号"},
			{["key"]="ip",["type"]="UTF8String[15]",["msg"]="ip"},
			{["key"]="imei",["type"]="UTF8String[17]",["msg"]="IMEI"},
			{["key"]="mac",["type"]="UTF8String[17]",["msg"]="mac"},
			{["key"]="parm",["type"]="UTF8String[20]",["msg"]="预留参数：sdk版本,sdk_id"},
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型，1注册，2登陆"},
			{["key"]="clientVersion",["type"]="UTF8String[20]",["msg"]="客户端版本"},
			{["key"]="system",["type"]="UTF8String[100]",["msg"]="系统版本号"},
			{["key"]="adID",["type"]="UTF8String[20]",["msg"]="广告短链ID"},
		},
	},

	["180008"] = { --新登录验证
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 2310, --未包含协议头部长度
		["resp_socket_size"] = 262, --未包含协议头部长度
		["req_func"] = "req_login_check",
		["resp_func"] = "resp_login_check_new",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道"},
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="平台账号userid"},
			{["key"]="password",["type"]="UTF8String[64]",["msg"]="密码(游客登录时需要)"},
			{["key"]="sid",["type"]="UTF8String[64]",["msg"]="token值"},
			{["key"]="version",["type"]="UTF8String[20]",["msg"]="sdk版本"},
			{["key"]="accessToken",["type"]="UTF8String[2048]",["msg"]="token值(第三方登录时用)"},
		},
		["resp_args"] =
		{
			{["key"]="zoneId",["type"]="Signed32",["msg"]="默认登陆区"},
			{["key"]="time",["type"]="Signed32",["msg"]="登陆时间"},
			{["key"]="zoneCount",["type"]="Signed32",["msg"]="总服务器数量"},
			{["key"]="zoneName",["type"]="UTF8String[24]",["msg"]="默认登陆区名称"},
			{["key"]="backupDomain",["type"]="UTF8String[40]",["msg"]="备用游戏PS服 ip:port"},
			{["key"]="defaultDomain",["type"]="UTF8String[40]",["msg"]="默计游戏PS服 ip:port"},
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="UserID/错误信息"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="sign"},
			{["key"]="status",["type"]="Bool",["msg"]="登陆状态"},
			{["key"]="zoneStatus",["type"]="Signed32",["msg"]="0正常1拥挤2爆满"},
			{["key"]="newHere",["type"]="Signed8",["msg"]="是否是新账号，0不是，1是"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="帐号创建时间"},
			{["key"]="preRegAward",["type"]="Signed64",["msg"]="预注册奖励(客户端在登录游戏服时(110011)将此数据发到ss)"},
			{["key"]="param",["type"]="UTF8String[32]",["msg"]="预留字段"},
		}
	},

	["180101"] = { --心跳
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_heart_beat",
		["resp_func"] = "resp_heart_beat",
		["req_args"] =
		{
		},
		["resp_args"] =
		{
			{["key"]="time",["type"]="Signed32",["msg"]="时间"},
		}
	},

	["180201"] = { --请求分配游客帐号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 100, --未包含协议头部长度
		["resp_socket_size"] = 80, --未包含协议头部长度
		["req_func"] = "req_create_visitor",
		["resp_func"] = "resp_create_visitor",
		["req_args"] =
		{
			{["key"]="uuid",["type"]="UTF8String[100]",["msg"]="IMEI/UUID之类的可以唯一标识机器的id"},
		},
		["resp_args"] =
		{
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="随机生成的帐号"},
			{["key"]="password",["type"]="UTF8String[16]",["msg"]="随机密码"},
		}
	},

	["180202"] = { --绑定游客帐号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 2242, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_bind_visitor",
		["resp_func"] = "resp_bind_visitor",
		["req_args"] =
		{
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="游客帐号"},
			{["key"]="pwd",["type"]="UTF8String[16]",["msg"]="游客密码"},
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark/Hydra"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道:fb, google"},
			{["key"]="platformId",["type"]="UTF8String[64]",["msg"]="第三方帐号唯一标识"},
			{["key"]="accessToken",["type"]="UTF8String[2048]",["msg"]="token值(用于第三方登录验证)"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["180203"] = { --再次绑定已绑定的帐号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 4314, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["req_func"] = "req_re_bind_visitor",
		["resp_func"] = "resp_re_bind_visitor",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark/Hydra"},
			{["key"]="oldChannel",["type"]="UTF8String[40]",["msg"]="已经登录的渠道:fb, google"},
			{["key"]="oldPlatformId",["type"]="UTF8String[64]",["msg"]="已经登录的第三方帐号"},
			{["key"]="oldToken",["type"]="UTF8String[2048]",["msg"]="已经登录的token值(用于第三方登录验证)"},
			{["key"]="platformId",["type"]="UTF8String[64]",["msg"]="新绑定的第三方帐号"},
			{["key"]="token",["type"]="UTF8String[2048]",["msg"]="新绑定的token值(用于第三方登录验证)"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道:fb, google"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["180204"] = { --创建自有账号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 134, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["req_func"] = "req_create_account",
		["resp_func"] = "resp_create_account",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="客户端所属平台:YH/Dark/Hydra"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="客户端所属渠道:fb, google"},
			{["key"]="username",["type"]="UTF8String[64]",["msg"]="用户名"},
			{["key"]="password",["type"]="UTF8String[20]",["msg"]="密码"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="登录时的userId"},
			{["key"]="token",["type"]="UTF8String[32]",["msg"]="登录时的token值(用于第三方登录验证)"},
		}
	},

	["180205"] = { --校验自有账号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 134, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["req_func"] = "req_login_account",
		["resp_func"] = "resp_login_account",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="客户端所属平台:YH/Dark/Hydra"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="客户端所属渠道:fb, google"},
			{["key"]="username",["type"]="UTF8String[64]",["msg"]="用户名"},
			{["key"]="password",["type"]="UTF8String[20]",["msg"]="密码"},
		},
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
			{["key"]="userId",["type"]="UTF8String[64]",["msg"]="登录时的userId"},
			{["key"]="token",["type"]="UTF8String[32]",["msg"]="登录时的token值(用于第三方登录验证)"},
		}
	},

	["180206"] = { --通知客户端登录成功的帐号已绑定的所有第三方帐号
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 204", --未包含协议头部长度
		["resp_func"] = "resp_bind_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--AccountInfo
				["msg"]="服务器列表",
				["struct"]=
				{
					{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道:如fb, google,dark"},
					{["key"]="platformId",["type"]="UTF8String[64]",["msg"]="唯一识别码"},
					{["key"]="nick",["type"]="UTF8String[100]",["msg"]="昵称"},
				}
			},
		}
	},

	["180207"] = { --设置第三方帐号昵称
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 214, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_set_user_name",
		["req_args"] =
		{
			{["key"]="platform",["type"]="UTF8String[10]",["msg"]="平台:YH/Dark/Hydra"},
			{["key"]="channel",["type"]="UTF8String[40]",["msg"]="渠道:fb, google"},
			{["key"]="platformId",["type"]="UTF8String[64]",["msg"]="新绑定的第三方帐号"},
			{["key"]="nick",["type"]="UTF8String[100]",["msg"]="昵称"},
		},
	},

	["180208"] = { --设备信息(在LoginCheck前发)
		["module_name"] = "login", --登录模块
		["socket_type"] = "login",
		["req_socket_size"] = 604, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["req_func"] = "req_t_x_device_info",
		["req_args"] =
		{
			{["key"]="PlatID",["type"]="Signed32",["msg"]="(必填)ios 0 /android 1"},
			{["key"]="ClientVersion",["type"]="UTF8String[64]",["msg"]="(可选)客户端版本"},
			{["key"]="SystemSoftware",["type"]="UTF8String[64]",["msg"]="(可选)移动终端操作系统版本"},
			{["key"]="SystemHardware",["type"]="UTF8String[64]",["msg"]="(可选)移动终端机型"},
			{["key"]="TelecomOper",["type"]="UTF8String[64]",["msg"]="(必填)运营商"},
			{["key"]="Network",["type"]="UTF8String[64]",["msg"]="(可选)3G/WIFI/2G"},
			{["key"]="ScreenWidth",["type"]="Signed32",["msg"]="(可选)显示屏宽度"},
			{["key"]="ScreenHight",["type"]="Signed32",["msg"]="(可选)显示屏高度"},
			{["key"]="Density",["type"]="Signed32",["msg"]="(可选)像素密度 *1000"},
			{["key"]="Channel",["type"]="Signed32",["msg"]="(必填)注册渠道/登陆渠道"},
			{["key"]="CpuHardware",["type"]="UTF8String[64]",["msg"]="(可选)cpu类型|频率|核数"},
			{["key"]="Memory",["type"]="Signed32",["msg"]="(可选)内存信息单位M"},
			{["key"]="GLRender",["type"]="UTF8String[64]",["msg"]="(可选)opengl render信息"},
			{["key"]="GLVersion",["type"]="UTF8String[64]",["msg"]="(可选)opengl版本信息"},
			{["key"]="DeviceId",["type"]="UTF8String[64]",["msg"]="(可选)设备ID"},
			{["key"]="platformType",["type"]="Signed32",["msg"]="(必填)平台类型:0:QQ,1:微信"},
		},
	},

	["210001"] = { --玩家信息
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 514, --未包含协议头部长度
		["resp_func"] = "resp_user_mine",
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="角色id"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
			{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
			{["key"]="firstHero",["type"]="Signed32",["msg"]="主控英雄id"},
			{["key"]="secondHero",["type"]="Signed32",["msg"]="副控英雄id"},
			{["key"]="weaponId",["type"]="Signed32",["msg"]="武器类型"},
			{["key"]="level",["type"]="Signed32",["msg"]="玩家等级"},
			{["key"]="exp",["type"]="Signed32",["msg"]="当前等级累积经验"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="钻石(使用人民币购买获得)"},
			{["key"]="gold",["type"]="Signed32",["msg"]="金币"},
			{["key"]="mana",["type"]="Signed32",["msg"]="魔力值"},
			{["key"]="heraldry",["type"]="Signed32",["msg"]="竞技场纹章"},
			{["key"]="areaScore",["type"]="Signed32",["msg"]="竞技场积分"},
			{["key"]="pveScore",["type"]="Signed32",["msg"]="推图积分"},
			{["key"]="socialScore",["type"]="Signed32",["msg"]="社交积分"},
			{["key"]="challengePoint",["type"]="Signed32",["msg"]="混沌点数"},
			{["key"]="guildID",["type"]="Signed64",["msg"]="公会ID"},
			{["key"]="guildname",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="contributeCoin",["type"]="Signed32",["msg"]="公会贡献币"},
			{["key"]="chip",["type"]="Signed32",["msg"]="铜币数（赌博）"},
			{["key"]="areaGrade",["type"]="Signed32",["msg"]="竞技场段位"},
			{["key"]="coin",["type"]="Signed32",["msg"]="当前累积可领取秘币"},
			{["key"]="nextCoinTime",["type"]="Signed32",["msg"]="下次领取秘币的时间"},
			{["key"]="coinInteval",["type"]="Signed32",["msg"]="领取秘币的间隔"},
			{["key"]="coinAdd",["type"]="Signed32",["msg"]="每次间隔可领取秘币数"},
			{["key"]="time",["type"]="Signed32",["msg"]="当前时间(秒)"},
			{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
			{["key"]="vipLevel",["type"]="Signed32",["msg"]="vip等级"},
			{["key"]="buyBagNum",["type"]="Signed32",["msg"]="购买的背包格子数"},
			{["key"]="buyBagCount",["type"]="Signed32",["msg"]="已经购买背包格子的次数"},
			{["key"]="talentPoint",["type"]="Signed32",["msg"]="天赋点"},
			{["key"]="boundIngot",["type"]="Signed32",["msg"]="18 绑定灵核"},
			{["key"]="goldCoin",["type"]="Signed32",["msg"]="19 金币卷"},
			{["key"]="doorCdEndTime",["type"]="Signed32",["msg"]="传送门CD结束时的时间戳"},
			{["key"]="outfitList",["type"]="UTF8String[150]",["msg"]="装备列表(装备物品id,用逗号隔开)"},
			{["key"]="activateFashionList",["type"]="UTF8String[100]",["msg"]="当前激活时装列表(时装物品id,用逗号隔开)"},
		}
	},

	["210101"] = { --玩家进入
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 346", --未包含协议头部长度
		["resp_func"] = "resp_unit_enter",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--UnitEnterStruct
				["msg"]="角色id",
				["struct"]=
				{
					{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
					{["key"]="heroId",["type"]="Signed64",["msg"]="英雄ID/MonsterFactory怪物总表ID"},
					{["key"]="heroType",["type"]="Signed8",["msg"]="主英雄1 副英雄2"},
					{["key"]="unitType",["type"]="Signed8",["msg"]="unit类型 玩家1 怪物2 NPC3"},
					{["key"]="uid",["type"]="Signed64",["msg"]="Uid"},
					{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
					{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
					{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
					{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
					{["key"]="weaponId",["type"]="Signed32",["msg"]="武器ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="玩家等级"},
					{["key"]="stage",["type"]="Signed32",["msg"]="魂阶"},
					{["key"]="camp",["type"]="Signed32",["msg"]="阵营"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="名称"},
					{["key"]="outfitList",["type"]="UTF8String[150]",["msg"]="装备列表(装备物品id,用逗号隔开)"},
					{["key"]="activateFashionList",["type"]="UTF8String[100]",["msg"]="当前激活时装列表(时装物品id,用逗号隔开)"},
				}
			},
		}
	},

	["210102"] = { --玩家移动
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 22, --未包含协议头部长度
		["resp_func"] = "resp_unit_move",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["210103"] = { --玩家离开
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_unit_leave",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="aoiId"},
		}
	},

	["210105"] = { --玩家停止
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 22, --未包含协议头部长度
		["resp_func"] = "resp_unit_stop",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["210106"] = { --玩家转向
		["module_name"] = "player", --玩家基础
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 22, --未包含协议头部长度
		["resp_func"] = "resp_unit_turn",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配unitId"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="direction",["type"]="Signed16",["msg"]="方向"},
		}
	},

	["210201"] = { --通知客户端可触发的剧情
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["resp_func"] = "resp_plot_progress",
		["resp_args"] =
		{
			{["key"]="playerMission",["type"]="Signed32",["msg"]="主线剧情的进度"},
			{["key"]="playerStatus",["type"]="Signed32",["msg"]="主线剧情任务的状态0初始, 2已对话副本未完成, 5全部完成"},
			{["key"]="heroMission",["type"]="Signed32",["msg"]="英雄剧情的进度(当前主控英雄)"},
			{["key"]="heroStatus",["type"]="Signed32",["msg"]="主线剧情任务的状态0初始, 2已对话副本未完成, 5全部完成"},
		}
	},

	["210202"] = { --通知客户端当前关卡中场景物件及其奖励
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 19", --未包含协议头部长度
		["resp_func"] = "resp_scene_object",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SceneObjectInfo
				["msg"]="物件列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="唯一id, 对应于CSceneObject.id"},
					{["key"]="monsterId",["type"]="Signed32",["msg"]="怪物id, 对应于CMonsterChain.id, 普通掉落则为0"},
					{["key"]="seq",["type"]="Signed8",["msg"]="同一怪物id数量大于1时，序列号, 普通掉落则为0"},
					{["key"]="gold",["type"]="Signed32",["msg"]="奖励金币, 可能为0, 表示没有金币奖励"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="奖励物品id, 可能为0, 表示没有物品奖励"},
					{["key"]="count",["type"]="Signed16",["msg"]="奖励物品数量, 可能为0, 表示没有物品奖励"},
				}
			},
		}
	},

	["210203"] = { --通知客户端有新的邮件
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_new_mail",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="1系统邮件2GM邮件3玩家邮件"},
		}
	},

	["210206"] = { --黑暗之境的boss数据
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "1012 + num * 8", --未包含协议头部长度
		["resp_func"] = "resp_diablo_boss",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="bossIdList",["type"]="UTF8String[1000]",["msg"]="最终大boss的id列表"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="掉落钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="掉落金币"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="怪物掉落数据, 包括大boss",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["210207"] = { --赠送派遣
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["resp_func"] = "resp_dispatch_give",
		["resp_args"] =
		{
			{["key"]="friendId",["type"]="Signed64",["msg"]="好友uid"},
			{["key"]="nextTime",["type"]="Signed32",["msg"]="下一次可赠送的时间"},
			{["key"]="result",["type"]="Signed32",["msg"]="0失败1成功"},
		}
	},

	["210210"] = { --查看他人所有英雄
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 116", --未包含协议头部长度
		["resp_func"] = "resp_message_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MessageInfo
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="唯一自增id"},
					{["key"]="type",["type"]="Signed32",["msg"]="赠送类型"},
					{["key"]="targetId",["type"]="Signed64",["msg"]="接收者uid"},
					{["key"]="target",["type"]="UTF8String[40]",["msg"]="接收者昵称"},
					{["key"]="actorId",["type"]="Signed64",["msg"]="赠送者uid"},
					{["key"]="actor",["type"]="UTF8String[40]",["msg"]="赠送者昵称"},
					{["key"]="value1",["type"]="Signed32",["msg"]="保留字段(秘币、黑暗之境钥匙goodsId, 混沌之渊0, 派遣任务id)"},
					{["key"]="value2",["type"]="Signed32",["msg"]="保留字段(秘币、钥匙数量，混沌挑战次数，派遣任务奖励金币)"},
				}
			},
		}
	},

	["210301"] = { --通知客户端英雄售卖信息
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_shop_hero_sell_info",
		["resp_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄Id"},
			{["key"]="outTime",["type"]="Signed32",["msg"]="英雄外出时间戳"},
		}
	},

	["210401"] = { --发送系统聊天
		["module_name"] = "chat", --系统聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 256, --未包含协议头部长度
		["resp_func"] = "resp_send_system_msg",
		["resp_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["210501"] = { --通知客户端成就完成（提示用）
		["module_name"] = "achievement", --成就
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_achievement",
		["resp_args"] =
		{
			{["key"]="achId",["type"]="Signed32",["msg"]="成就Id"},
		}
	},

	["210601"] = { --通知客户端技能解锁（提示用）
		["module_name"] = "skill", --技能
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 5, --未包含协议头部长度
		["resp_func"] = "resp_skill_un_lock",
		["resp_args"] =
		{
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄Id"},
			{["key"]="index",["type"]="Signed8",["msg"]="解锁的技能index"},
		}
	},

	["210701"] = { --通知客户端每日任务完成（提示用）
		["module_name"] = "dailytask", --每日任务
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_daily_task",
		["resp_args"] =
		{
			{["key"]="taskId",["type"]="Signed32",["msg"]="任务id"},
		}
	},

	["210801"] = { --通知客户端章节收集完成（提示用）
		["module_name"] = "collect", --收集
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_collect",
		["resp_args"] =
		{
			{["key"]="phase",["type"]="Signed32",["msg"]="章节"},
		}
	},

	["210901"] = { --通知客户端抽奖列表
		["module_name"] = "draw", --抽奖
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "9 + num * 4", --未包含协议头部长度
		["resp_func"] = "resp_draw_gold_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="freeNum",["type"]="Signed8",["msg"]="已使用的免费刷新次数"},
			{["key"]="nextFreeRefreshTime",["type"]="Signed32",["msg"]="下一次免费刷新时间"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DrawItem
				["msg"]="奖励列表",
				["struct"]=
				{
					{["key"]="canGet",["type"]="Signed32",["msg"]="是否可用,0可用，大于0该参数为rewardID"},
				}
			},
		}
	},

	["211001"] = { --通知客户端功能开放
		["module_name"] = "system", --功能开放
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_open_flag",
		["resp_args"] =
		{
			{["key"]="flag",["type"]="Signed32",["msg"]="每一个bit代表一个功能"},
		}
	},

	["211101"] = { --通知客户端boss挂了
		["module_name"] = "guild", --公会Boss
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "104 + num * 12", --未包含协议头部长度
		["resp_func"] = "resp_boss_over",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PlayerHurt
				["msg"]="伤害列表",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="hurtValue",["type"]="Signed32",["msg"]="伤害值"},
				}
			},
			{["key"]="reward",["type"]="UTF8String[100]",["msg"]="战斗过程中产生的公会公共奖品（json格式）"},
		}
	},

	["211102"] = { --同步血量
		["module_name"] = "guild", --公会Boss
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 12", --未包含协议头部长度
		["resp_func"] = "resp_sync_boss_hurt",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="otherHurtValue",["type"]="Signed32",["msg"]="其他玩家伤害的Boss的伤害总量"},
			{["key"]="uidTarget",["type"]="Signed64",["msg"]="boss的仇恨目标玩家ID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OtherHP
				["msg"]="玩家血量同步列表",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家Id"},
					{["key"]="hpValue",["type"]="Signed32",["msg"]="血量值"},
				}
			},
		}
	},

	["211103"] = { --同步boss技能
		["module_name"] = "guild", --公会Boss
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["resp_func"] = "resp_sync_guild_boss_skill_to_others",
		["resp_args"] =
		{
			{["key"]="bossSkillId",["type"]="Signed32",["msg"]="怪物的技能Id"},
			{["key"]="uid",["type"]="Signed64",["msg"]="施放的目标Uid"},
		}
	},

	["211104"] = { --同步英雄技能
		["module_name"] = "guild", --公会Boss
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 28, --未包含协议头部长度
		["resp_func"] = "resp_sync_hero_skill_to_others",
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能Id"},
			{["key"]="time",["type"]="Signed32",["msg"]="施放的时间戳"},
			{["key"]="posX",["type"]="Signed32",["msg"]="posX"},
			{["key"]="posY",["type"]="Signed32",["msg"]="posY"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="posZ"},
		}
	},

	["211105"] = { --公会捐献
		["module_name"] = "guild", --公会Boss
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 20, --未包含协议头部长度
		["resp_func"] = "resp_member2_guild_donated",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="捐献结果,1:成功,0:失败"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="捐献的钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="捐献的金币"},
			{["key"]="donated",["type"]="Signed32",["msg"]="获得的捐献币"},
			{["key"]="guildMoney",["type"]="Signed32",["msg"]="获得的公会资金"},
		}
	},

	["211201"] = { --通知客户端触发了神谕
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 13, --未包含协议头部长度
		["resp_func"] = "resp_oracle_notice",
		["resp_args"] =
		{
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一id"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="触发时间"},
			{["key"]="isComplete",["type"]="Bool",["msg"]="是否已经完成"},
		}
	},

	["211202"] = { --领取奖励
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 8", --未包含协议头部长度
		["resp_func"] = "resp_oracle_reward",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="金币"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="物品",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["211203"] = { --战斗中怪物奖励
		["module_name"] = "oracle", --神谕
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 20", --未包含协议头部长度
		["resp_func"] = "resp_oracle_battle_enter",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["211302"] = { --通知充值成功
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_recharge_ok",
		["resp_args"] =
		{
			{["key"]="rechargeNum",["type"]="Signed32",["msg"]="充值的钻石数"},
		}
	},

	["211303"] = { --通知自动鉴定的结果
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 762, --未包含协议头部长度
		["resp_func"] = "resp_auto_identify",
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--OutfitInfo
				["msg"]="装备",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["211304"] = { --通知信息板数据
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "9 + num * 21", --未包含协议头部长度
		["resp_func"] = "resp_board_info_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="navigationType",["type"]="Signed8",["msg"]="导航的类型, 0表示无导航"},
			{["key"]="navigationId",["type"]="Signed32",["msg"]="导航的id如每日成就的id,0表示不需要,如混沌之渊"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--BoardInfo
				["msg"]="数据列表",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed8",["msg"]="类型"},
					{["key"]="id",["type"]="Signed32",["msg"]="id(可能为主线剧情、日常任务、运营活动等)"},
					{["key"]="num",["type"]="Signed32",["msg"]="当前进度"},
					{["key"]="max",["type"]="Signed32",["msg"]="最大进度"},
					{["key"]="time",["type"]="Signed32",["msg"]="(派遣任务完成、混沌之渊整顿完毕)时间"},
					{["key"]="reserve",["type"]="Signed32",["msg"]="预留"},
				}
			},
		}
	},

	["211305"] = { --游戏触发公告
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 300, --未包含协议头部长度
		["resp_func"] = "resp_system_notice",
		["resp_args"] =
		{
			{["key"]="text",["type"]="UTF8String[300]",["msg"]="提示信息"},
		}
	},

	["211306"] = { --装备赌博的彩蛋奖励通知
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_lottery_reward",
		["resp_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="彩蛋奖励表唯一id"},
		}
	},

	["211307"] = { --英雄激活时通知前端增加新装备
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 762", --未包含协议头部长度
		["resp_func"] = "resp_add_hero_outfit",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OutfitInfo
				["msg"]="装备列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["211308"] = { --通知购买特权卡成功
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 16", --未包含协议头部长度
		["resp_func"] = "resp_buy_privilege_card_success",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PrivilegeCard
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="唯一id"},
					{["key"]="buyTime",["type"]="Signed32",["msg"]="购买时间（若卡升级，此购买时间即升级时间）"},
					{["key"]="endTime",["type"]="Signed32",["msg"]="到期时间"},
					{["key"]="rewardCount",["type"]="Signed32",["msg"]="领取数量:注意！！可累计（可升级）的特权卡：返回的是可领取奖励的“个数”（例钻石10个，则返回10），不可累计的特权卡：返回的是可领取奖励的“次数”（因为不可累计，所以最大只可能返回1）"},
				}
			},
		}
	},

	["211309"] = { --通知有新母矿
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 69", --未包含协议头部长度
		["resp_func"] = "resp_gem_container_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GemContainerInfo
				["msg"]="母矿列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="母矿唯一id"},
					{["key"]="outfitId",["type"]="Signed64",["msg"]="装备id(0表示没有镶嵌到任何装备)"},
					{["key"]="isIdentified",["type"]="Signed8",["msg"]="是否鉴定    1:已鉴定   0:未鉴定"},
					{["key"]="templeteId",["type"]="Signed32",["msg"]="母矿模板id(GemContainer._id)"},
					{["key"]="stage",["type"]="Signed32",["msg"]="阶"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间 时间戳(-1表示永久)"},
					{
						["key"]="gemList",
						["type"]="Signed32[10]",
						["msg"]="小宝石列表(存放小宝石的物品id(GoodsData._id))",
					},
				}
			},
		}
	},

	["211310"] = { --通知客户端下载回调连接
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 112, --未包含协议头部长度
		["resp_func"] = "resp_notice_call_back_link",
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="zoneId"},
			{["key"]="url",["type"]="UTF8String[100]",["msg"]="登录回调链接"},
		}
	},

	["211311"] = { --通知客户端批量鉴定的结果
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 762", --未包含协议头部长度
		["resp_func"] = "resp_identify_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OutfitInfo
				["msg"]="装备数据列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed64",["msg"]="装备唯一id"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="wearHero",["type"]="Signed32",["msg"]="穿着的英雄id， 0表示在背包中"},
					{["key"]="grade",["type"]="Signed32",["msg"]="强化等级"},
					{
						["key"]="attr",
						["type"]="Signed64[10]",
						["msg"]="装备属性(不可重铸，受强化影响)",
					},
					{
						["key"]="randAttr",
						["type"]="Signed64[10]",
						["msg"]="装备随机属性(可重铸，受强化影响)",
					},
					{
						["key"]="specialAttr",
						["type"]="Signed64[10]",
						["msg"]="装备特殊属性(不可重铸，不受强化影响)",
					},
					{["key"]="isIdentified",["type"]="Signed16",["msg"]="是否已鉴定"},
					{["key"]="overdueTime",["type"]="Signed32",["msg"]="过期时间（时间戳，-1表示永久有效）"},
					{["key"]="fillValue",["type"]="Signed32",["msg"]="当前填充值(用于打孔)"},
					{["key"]="hole",["type"]="Signed32",["msg"]="装备已开孔数(出生孔数+手动开孔数)(总数不能超过outfit表的hole_totle)"},
					{["key"]="punched",["type"]="Signed32",["msg"]="手动开孔次数(不能超过outfit表的hole_canOpenNum)"},
					{
						["key"]="gem",
						["type"]="struct[10]",	--OutfitGemInfo
						["msg"]="宝石信息",
						["struct"]=
						{
							{["key"]="gemId",["type"]="Signed64",["msg"]="宝石id(小宝石:高32位全为1,取低32转为int即为小宝石的物品id;母矿:64位的唯一id)"},
							{["key"]="time",["type"]="Signed32",["msg"]="镶嵌时间(世界标准时间)"},
						}
					},
					{["key"]="magicSlotSize",["type"]="Signed32",["msg"]="魔法槽位总数"},
					{
						["key"]="magicSlotGoodsId",
						["type"]="Signed32[10]",
						["msg"]="魔法槽位上填充物品(物品id，有序)",
					},
					{
						["key"]="magicSlotAttr",
						["type"]="Signed64[10]",
						["msg"]="魔法槽位上填充的属性(有序，属性不叠加)",
					},
					{
						["key"]="magicAttr",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性(有条件，不可重铸，不受强化影响)",
					},
					{
						["key"]="magicAttrCond",
						["type"]="Signed64[10]",
						["msg"]="装备魔法属性条件(与魔法属性一一对应)(高32位为属性类型，低32位为条件数值)",
					},
					{
						["key"]="selectAttr",
						["type"]="Signed64[10]",
						["msg"]="选择属性",
					},
				}
			},
		}
	},

	["211312"] = { --通知客户端物品过期销毁
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 12", --未包含协议头部长度
		["resp_func"] = "resp_item_overdue",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--OverdueItemInfo
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id"},
					{["key"]="uniqueId",["type"]="Signed64",["msg"]="物品唯一id(如果是装备，表示装备唯一id，如果是母矿，表示母矿唯一id)"},
				}
			},
		}
	},

	["211401"] = { --活动奖励可领取通知
		["module_name"] = "activity", --活动
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["resp_func"] = "resp_activity_notice",
		["resp_args"] =
		{
			{["key"]="aid",["type"]="Signed32",["msg"]="活动ID"},
			{["key"]="aType",["type"]="Signed32",["msg"]="活动类型"},
			{["key"]="value",["type"]="Signed32",["msg"]="活动临界值"},
		}
	},

	["211601"] = { --竞技场匹配结果
		["module_name"] = "arena", --pvp快速匹配
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_arena_match",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0正常1正在匹配中2已经匹配成功在创建场景3正在进入场景4有未结束的战斗"},
		}
	},

	["211602"] = { --取消匹配结果
		["module_name"] = "arena", --pvp快速匹配
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_cancel_match",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="取消结果：0表示已经匹配成功并创建战斗,不能再取消; 1表示成功"},
		}
	},

	["211603"] = { --匹配成功，通知登录bs
		["module_name"] = "arena", --pvp快速匹配
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "120 + num * 60", --未包含协议头部长度
		["resp_func"] = "resp_arena_success",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="type",["type"]="Signed32",["msg"]=""},
			{["key"]="ip",["type"]="UTF8String[40]",["msg"]="战斗服地址"},
			{["key"]="port",["type"]="Signed32",["msg"]="端口"},
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="地图场景唯一标识"},
			{["key"]="mapType",["type"]="Signed32",["msg"]="场景类型"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="场景id"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="区"},
			{["key"]="time",["type"]="Signed32",["msg"]="生成sign的时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(对玩家信息生成的md5校验码, 用于防止伪造信息登录)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MatchUserInfo
				["msg"]="匹配成功的玩家列表：顺序为左一、左二、右一、右二",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="level",["type"]="Signed32",["msg"]="玩家等级"},
					{["key"]="firstHero",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="secondHero",["type"]="Signed32",["msg"]="副控英雄"},
				}
			},
		}
	},

	["211604"] = { --通知客户端竞技场战斗结果
		["module_name"] = "arena", --pvp快速匹配
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 25, --未包含协议头部长度
		["resp_func"] = "resp_arena_battle_end",
		["resp_args"] =
		{
			{["key"]="isWin",["type"]="Signed8",["msg"]="0负1胜"},
			{["key"]="level",["type"]="Signed32",["msg"]="竞技场等级"},
			{["key"]="exp",["type"]="Signed32",["msg"]="竞技场经验"},
			{["key"]="output",["type"]="Signed64",["msg"]="主+副英雄的输出"},
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="地图场景唯一标识"},
		}
	},

	["211605"] = { --匹配失败通知
		["module_name"] = "arena", --pvp快速匹配
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_arena_match_fail",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="战斗类型：0组队副本 1:1v1 2:2v2 3:3v3"},
		}
	},

	["211611"] = { --通知客户端排位赛战斗结果
		["module_name"] = "arena", --pvp排位赛
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 67, --未包含协议头部长度
		["resp_func"] = "resp_rank_battle_end",
		["resp_args"] =
		{
			{["key"]="isWin",["type"]="Signed8",["msg"]="0负1胜"},
			{["key"]="level",["type"]="Signed32",["msg"]="竞技场等级"},
			{["key"]="exp",["type"]="Signed32",["msg"]="竞技场经验"},
			{["key"]="stage",["type"]="Signed32",["msg"]="当前段位"},
			{["key"]="score",["type"]="Signed32",["msg"]="当前段位分"},
			{["key"]="score2",["type"]="Signed32",["msg"]="定位赛、晋级赛、降级赛的积分"},
			{["key"]="type",["type"]="Signed32",["msg"]="当前赛事类型TypeMatch:4定位赛5正赛6晋级赛7降级赛"},
			{["key"]="maxCount",["type"]="Signed32",["msg"]="当前赛事最大次数,正赛为0"},
			{["key"]="record",["type"]="UTF8String[30]",["msg"]="当前赛事胜负记录1胜0负,正赛为空"},
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="地图场景唯一标识"},
		}
	},

	["211707"] = { --队伍操作通知
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["resp_func"] = "resp_team_notice",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型:2减少队员, 3队员准备, 4队员取消准备, 5队长更改 6准备倒计时  (1增加队员 另外协议通知 )"},
			{["key"]="memberId",["type"]="Signed64",["msg"]="目标uid(解散时为队长uid)"},
		}
	},

	["211708"] = { --增加队员
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 313, --未包含协议头部长度
		["resp_func"] = "resp_team_member_add",
		["resp_args"] =
		{
			{
				["key"]="info",
				["type"]="struct",	--TeamMemberMessage
				["msg"]="目标uid",
				["struct"]=
				{
					{["key"]="memberId",["type"]="Signed64",["msg"]="目标uid"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="玩家等级"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="isReady",["type"]="Bool",["msg"]="是否已经准备好"},
				}
			},
		}
	},

	["211709"] = { --组队pve结算信息
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "13 + num * 61", --未包含协议头部长度
		["resp_func"] = "resp_team_battle_end",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="isWin",["type"]="Signed8",["msg"]="1胜0负"},
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="地图场景唯一标识"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TeamMemberResult
				["msg"]="结算成员信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="status",["type"]="Signed32",["msg"]="玩家状态"},
					{["key"]="currentRoleExp",["type"]="Signed32",["msg"]="角色当前经验"},
					{["key"]="addRoleExp",["type"]="Signed32",["msg"]="角色结算增加经验(任务)"},
					{["key"]="addHeroExp",["type"]="Signed32",["msg"]="英雄结算增加总经验(杀怪+任务)"},
					{["key"]="killMonsterExp",["type"]="Signed32",["msg"]="英雄杀怪增加经验"},
					{["key"]="top",["type"]="Signed8",["msg"]="排名"},
					{["key"]="hpPercent",["type"]="Signed16",["msg"]="伤害输出百份比(保留一位小数) 0-1000"},
					{["key"]="useHpBottle",["type"]="Signed16",["msg"]="使用血瓶数量"},
					{["key"]="deadCount",["type"]="Signed32",["msg"]="英雄死亡次数"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主英雄头像"},
					{["key"]="firstCurrentExp",["type"]="Signed32",["msg"]="主英雄当前等级经验"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主英雄等级"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副英雄头像"},
					{["key"]="secondCurrentExp",["type"]="Signed32",["msg"]="副英雄当前等级经验"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副英雄等级"},
				}
			},
		}
	},

	["211710"] = { --组队成功通知进入战斗服
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 124, --未包含协议头部长度
		["resp_func"] = "resp_team_success",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]=""},
			{["key"]="ip",["type"]="UTF8String[40]",["msg"]="战斗服地址"},
			{["key"]="port",["type"]="Signed32",["msg"]="端口"},
			{["key"]="mapObjId",["type"]="Signed64",["msg"]="地图场景唯一标识"},
			{["key"]="mapType",["type"]="Signed32",["msg"]="场景类型"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="场景id"},
			{["key"]="posX",["type"]="Signed32",["msg"]="当前坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="当前坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="当前坐标z"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="区"},
			{["key"]="time",["type"]="Signed32",["msg"]="生成sign的时间戳(秒)"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(对玩家信息生成的md5校验码, 用于防止伪造信息登录)"},
			{["key"]="missionId",["type"]="Signed32",["msg"]="任务id"},
			{["key"]="useCoin",["type"]="Signed32",["msg"]="最终的秘币消耗"},
		}
	},

	["211711"] = { --队伍名字改变通知
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_team_name_notice",
		["resp_args"] =
		{
			{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
		}
	},

	["211712"] = { --队伍私有状态改变通知
		["module_name"] = "team", --组队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_team_private_notice",
		["resp_args"] =
		{
			{["key"]="isPrivate",["type"]="Signed32",["msg"]="队伍房间是否为私有的1是0否"},
		}
	},

	["211801"] = { --返回:分解所得道具
		["module_name"] = "decompose", --分解
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 8", --未包含协议头部长度
		["resp_func"] = "resp_decompose_item",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="获得的钻石"},
			{["key"]="gold",["type"]="Signed32",["msg"]="获得的金币"},
			{["key"]="mana",["type"]="Signed32",["msg"]="获得的魔力值"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="分解获得的物品",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["211901"] = { --获取队伍列表
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 432", --未包含协议头部长度
		["resp_func"] = "resp_world_team_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamInfo
				["msg"]="队伍列表",
				["struct"]=
				{
					{["key"]="teamId",["type"]="Signed64",["msg"]="队伍唯一id"},
					{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
					{["key"]="curNum",["type"]="Signed32",["msg"]="队伍当前人数"},
					{["key"]="leaderId",["type"]="Signed64",["msg"]="队长UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="队长名字"},
					{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
					{["key"]="groupId",["type"]="Signed32",["msg"]="区域组ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="队伍等级"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队伍头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队伍图标地址"},
				}
			},
		}
	},

	["211902"] = { --通知队长有玩家申请入队
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 345, --未包含协议头部长度
		["resp_func"] = "resp_apply_join_world_team_notice",
		["resp_args"] =
		{
			{
				["key"]="info",
				["type"]="struct",	--WorldTeamMemberMessage
				["msg"]="申请的玩家信息",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211903"] = { --队伍名字改变通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_world_team_name_notice",
		["resp_args"] =
		{
			{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
		}
	},

	["211904"] = { --获取申请入队的玩家列表
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 345", --未包含协议头部长度
		["resp_func"] = "resp_apply_world_team_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="errCode",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamMemberMessage
				["msg"]="申请玩家列表",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211905"] = { --队长拒绝玩家入队申请通知（通知申请者）
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 40, --未包含协议头部长度
		["resp_func"] = "resp_refuse_apply_world_team_notice",
		["resp_args"] =
		{
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="队长昵称"},
		}
	},

	["211906"] = { --玩家拒绝队长的入队邀请通知（通知队长）
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 40, --未包含协议头部长度
		["resp_func"] = "resp_refuse_invite_world_team_notice",
		["resp_args"] =
		{
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="被邀请玩家昵称"},
		}
	},

	["211907"] = { --增加队员
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "436 + num * 345", --未包含协议头部长度
		["resp_func"] = "resp_world_team_member_add",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="teamInfo",
				["type"]="struct",	--WorldTeamInfo
				["msg"]="队伍信息",
				["struct"]=
				{
					{["key"]="teamId",["type"]="Signed64",["msg"]="队伍唯一id"},
					{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
					{["key"]="curNum",["type"]="Signed32",["msg"]="队伍当前人数"},
					{["key"]="leaderId",["type"]="Signed64",["msg"]="队长UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="队长名字"},
					{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
					{["key"]="groupId",["type"]="Signed32",["msg"]="区域组ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="队伍等级"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队伍头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队伍图标地址"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamMemberMessage
				["msg"]="队员列表",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211908"] = { --队长踢人结果
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_world_team_kick",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["211909"] = { --退出队伍结果
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_world_team_cancel",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["211910"] = { --委任队长的结果
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_world_team_change_leader",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="返回结果：@see ErrorCode"},
		}
	},

	["211911"] = { --通知被邀请者有队伍邀请
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 56, --未包含协议头部长度
		["resp_func"] = "resp_invite_add_world_team_notice",
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="邀请人UID"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="邀请人昵称"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="邀请人所在队伍ID"},
		}
	},

	["211912"] = { --查看队伍详情
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "12 + num * 345", --未包含协议头部长度
		["resp_func"] = "resp_query_world_team_details_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍ID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamMemberMessage
				["msg"]="队员列表",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211913"] = { --传送门、传送阵、传送点通用的给客户端的通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 133, --未包含协议头部长度
		["resp_func"] = "resp_transfer_result",
		["resp_args"] =
		{
			{["key"]="errCode",["type"]="Signed32",["msg"]="ErrorCode"},
			{["key"]="type",["type"]="Signed32",["msg"]="传送的类型TypeTransfer"},
			{["key"]="mapType",["type"]="Signed32",["msg"]="地图类型"},
			{["key"]="mapId",["type"]="Signed32",["msg"]="目标地图id"},
			{["key"]="status",["type"]="Signed32",["msg"]="目标地图状态"},
			{["key"]="sceneId",["type"]="Signed32",["msg"]="场景ID  @see CSceneData"},
			{["key"]="worldId",["type"]="Signed64",["msg"]="目标世界id，若是回主城，则为0"},
			{["key"]="doorId",["type"]="Signed64",["msg"]="传送门id，若不是传送门传送，则为0"},
			{["key"]="isLeader",["type"]="Bool",["msg"]="是否是队长，true:是、false:否"},
			{["key"]="x",["type"]="Signed32",["msg"]="目标位置x坐标"},
			{["key"]="y",["type"]="Signed32",["msg"]="目标位置y坐标"},
			{["key"]="z",["type"]="Signed32",["msg"]="目标位置z坐标"},
			{["key"]="ip",["type"]="UTF8String[40]",["msg"]="世界所在战斗服地址，如果是回城，这个字段无效"},
			{["key"]="port",["type"]="Signed32",["msg"]="端口"},
			{["key"]="time",["type"]="Signed32",["msg"]="可以开始传送的时间，用于校验"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于传送时防止伪造传送信息的校验码"},
		}
	},

	["211914"] = { --队伍操作通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 12, --未包含协议头部长度
		["resp_func"] = "resp_world_team_notice",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型:2减少队员, 3队员准备, 4队员取消准备, 5队长更改 6准备倒计时  (1增加队员 另外协议通知 )"},
			{["key"]="memberId",["type"]="Signed64",["msg"]="目标uid(解散时为队长uid)"},
		}
	},

	["211915"] = { --登录时队伍信息推送
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "436 + num * 345", --未包含协议头部长度
		["resp_func"] = "resp_team_info_notice",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="teamInfo",
				["type"]="struct",	--WorldTeamInfo
				["msg"]="队伍信息",
				["struct"]=
				{
					{["key"]="teamId",["type"]="Signed64",["msg"]="队伍唯一id"},
					{["key"]="teamName",["type"]="UTF8String[100]",["msg"]="队伍名称"},
					{["key"]="curNum",["type"]="Signed32",["msg"]="队伍当前人数"},
					{["key"]="leaderId",["type"]="Signed64",["msg"]="队长UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="队长名字"},
					{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
					{["key"]="groupId",["type"]="Signed32",["msg"]="区域组ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="队伍等级"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队伍头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队伍图标地址"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--WorldTeamMemberMessage
				["msg"]="队员列表",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211916"] = { --修改队伍所属区域通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_world_team_area_notice",
		["resp_args"] =
		{
			{["key"]="groupId",["type"]="Signed32",["msg"]="组ID"},
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
		}
	},

	["211917"] = { --通知玩家已经被剔出队伍
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_world_team_kick_notice",
		["resp_args"] =
		{
			{["key"]="leaderName",["type"]="UTF8String[100]",["msg"]="操作者昵称  提示：xxx已经将您移除队伍"},
		}
	},

	["211918"] = { --队员反馈组队出发请求通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["resp_func"] = "resp_deal_with_start_together_notice",
		["resp_args"] =
		{
			{["key"]="memberId",["type"]="Signed64",["msg"]="队员UID"},
			{["key"]="typeTeamDealWith",["type"]="Signed32",["msg"]="处理请求类型  @see TypeTeamDealWith"},
			{["key"]="typeStartOff",["type"]="Signed32",["msg"]="一起出发类型  @see TypeStartOff"},
		}
	},

	["211919"] = { --倒计时到了之后，进行全员广播。
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_start_together_result_notice",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果返回1:大地图中提示队长二次确认是否出发   2:酒馆必须所有队员同意才能进入"},
		}
	},

	["211920"] = { --主副英雄改变时通知队伍
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 353, --未包含协议头部长度
		["resp_func"] = "resp_hero_appoint_notice",
		["resp_args"] =
		{
			{["key"]="memberId",["type"]="Signed64",["msg"]="目标uid"},
			{
				["key"]="info",
				["type"]="struct",	--WorldTeamMemberMessage
				["msg"]="玩家信息",
				["struct"]=
				{
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="memberId",["type"]="Signed64",["msg"]="玩家UID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="玩家名称"},
					{["key"]="firstHeroId",["type"]="Signed32",["msg"]="主控英雄"},
					{["key"]="firstHeroLevel",["type"]="Signed32",["msg"]="主控英雄等级"},
					{["key"]="firstDamage",["type"]="Signed32",["msg"]="主控英雄输出能力"},
					{["key"]="firstViability",["type"]="Signed32",["msg"]="主控英雄生存能力"},
					{["key"]="secondHeroId",["type"]="Signed32",["msg"]="副控英雄"},
					{["key"]="secondHeroLevel",["type"]="Signed32",["msg"]="副控英雄等级"},
					{["key"]="secondDamage",["type"]="Signed32",["msg"]="副控英雄输出能力"},
					{["key"]="secondViability",["type"]="Signed32",["msg"]="副控英雄生存能力"},
					{["key"]="icon",["type"]="Signed32",["msg"]="队员头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="队员头像图标地址"},
					{["key"]="level",["type"]="Signed32",["msg"]="队员等级"},
				}
			},
		}
	},

	["211921"] = { --大地图刷新的时候通知主城的队员
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_world_map2_city_notice",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="世界内通知玩家回城类型  @see TypeBack2City"},
		}
	},

	["211922"] = { --队长发起组队出发通知
		["module_name"] = "map", --大地图相关
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["resp_func"] = "resp_start_together_notice",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="操作类型:14 酒馆通知玩家一起出发  15 大地图通知玩家一起出发"},
			{["key"]="memberId",["type"]="Signed64",["msg"]="目标uid"},
			{["key"]="areaId",["type"]="Signed32",["msg"]="区域ID"},
		}
	},

	["212001"] = { --通知抽奖宝箱打开结果
		["module_name"] = "chest", --抽奖宝箱
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 12", --未包含协议头部长度
		["resp_func"] = "resp_get_chest_award",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="group",["type"]="Signed32",["msg"]="宝箱是购买的，group=ChestShop.group宝箱是免费领取的，group=ChectData._id"},
			{["key"]="type",["type"]="Signed32",["msg"]="宝箱来源： 1-购买  2-免费宝箱"},
			{["key"]="count",["type"]="Signed32",["msg"]="打开个数"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChestAwardItem
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="itemId",["type"]="Signed32",["msg"]="物品ID"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
					{["key"]="heroExist",["type"]="Signed32",["msg"]="(如果奖励的是整个英雄)此英雄是否已存在  1：已存在(转换为灵魂石) 0：未存在"},
				}
			},
		}
	},

	["310101"] = { --通知客户端准备N秒后开战
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_ready_start",
		["resp_args"] =
		{
			{["key"]="readyTime",["type"]="Signed32",["msg"]="倒计时时间：秒"},
			{["key"]="totalTime",["type"]="Signed32",["msg"]="战斗持续时间"},
		}
	},

	["310206"] = { --技能失败
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 48, --未包含协议头部长度
		["resp_func"] = "resp_skill_fail",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
			{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
			{["key"]="errorInfo",["type"]="UTF8String[32]",["msg"]="错误信息"},
		}
	},

	["310307"] = { --同步英雄属性
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "20 + num * 8", --未包含协议头部长度
		["resp_func"] = "resp_sys_hero_attr",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="目标aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="stiff",["type"]="Signed32",["msg"]="硬直值"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--AttrInfo
				["msg"]="属性列表",
				["struct"]=
				{
					{["key"]="key",["type"]="Signed32",["msg"]="属性类型"},
					{["key"]="value",["type"]="Signed32",["msg"]="属性值"},
				}
			},
		}
	},

	["310308"] = { --同步英雄技能
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "16 + num * 16", --未包含协议头部长度
		["resp_func"] = "resp_sys_hero_skill",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="aoiId",["type"]="Signed64",["msg"]="目标aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--SkillInfo
				["msg"]="技能列表",
				["struct"]=
				{
					{["key"]="skillId",["type"]="Signed32",["msg"]="技能ID"},
					{["key"]="level",["type"]="Signed32",["msg"]="等级"},
					{["key"]="index",["type"]="Signed32",["msg"]="下标"},
					{["key"]="branch",["type"]="Signed32",["msg"]="分支"},
				}
			},
		}
	},

	["310401"] = { --使用血瓶
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 16, --未包含协议头部长度
		["resp_func"] = "resp_use_bottle",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="heroId",["type"]="Signed32",["msg"]="英雄ID"},
			{["key"]="hpValue",["type"]="Signed32",["msg"]="血量"},
		}
	},

	["310402"] = { --复活英雄
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 24, --未包含协议头部长度
		["resp_func"] = "resp_rescue_hero",
		["resp_args"] =
		{
			{["key"]="aoiId",["type"]="Signed64",["msg"]="场景分配aoiId"},
			{["key"]="currentHero",["type"]="Signed32",["msg"]="当前英雄ID"},
			{["key"]="posX",["type"]="Signed32",["msg"]="坐标x"},
			{["key"]="posY",["type"]="Signed32",["msg"]="坐标y"},
			{["key"]="posZ",["type"]="Signed32",["msg"]="坐标z"},
		}
	},

	["311501"] = { --进入组队关卡
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 20", --未包含协议头部长度
		["resp_func"] = "resp_team_copy_enter",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--MonsterRewardInfo
				["msg"]="字段未有注解",
				["struct"]=
				{
					{["key"]="monsterId",["type"]="Signed64",["msg"]="怪物的唯一id, 冗余字段,可能存在多个相同id的记录"},
					{["key"]="gold",["type"]="Signed32",["msg"]="这只怪奖励的金币总数, 冗余字段,相同id对应的金币数全都一样,只需处理其中一个就可以"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id, 可能为0表示这个怪只掉金币, 不掉物品"},
					{["key"]="count",["type"]="Signed32",["msg"]="物品数量, 可能为0表示这个怪只掉金币, 不掉物品"},
				}
			},
		}
	},

	["311507"] = { --mvp额外奖励
		["module_name"] = "battle", --战斗
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 8", --未包含协议头部长度
		["resp_func"] = "resp_team_m_v_p_reward",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--GoodsInfo
				["msg"]="奖励内容，可能包括金币、钻石等",
				["struct"]=
				{
					{["key"]="goodsDataId",["type"]="Signed32",["msg"]="物品配置id"},
					{["key"]="num",["type"]="Signed32",["msg"]="数量"},
				}
			},
		}
	},

	["312101"] = { --当前世界可用传送门列表
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 84", --未包含协议头部长度
		["resp_func"] = "resp_door_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="ssTime",["type"]="Signed32",["msg"]="服务器时间戳（用来校验）"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--DoorInfo
				["msg"]="传送门列表",
				["struct"]=
				{
					{["key"]="owner",["type"]="Signed64",["msg"]="开启者uid"},
					{["key"]="ownerName",["type"]="UTF8String[40]",["msg"]="开启者昵称"},
					{["key"]="worldId",["type"]="Signed64",["msg"]="所属世界的唯一id"},
					{["key"]="pos",["type"]="Signed32",["msg"]="在主城的位置"},
					{["key"]="mapId",["type"]="Signed32",["msg"]="目标地图"},
					{["key"]="sceneId",["type"]="Signed32",["msg"]="目标场景ID  @see CSceneData"},
					{["key"]="x",["type"]="Signed32",["msg"]="目标位置x坐标"},
					{["key"]="y",["type"]="Signed32",["msg"]="目标位置y坐标"},
					{["key"]="z",["type"]="Signed32",["msg"]="目标位置z坐标"},
					{["key"]="cdTime",["type"]="Signed32",["msg"]="门cd时间戳"},
				}
			},
		}
	},

	["312102"] = { --通知当前世界中的玩家回到主城
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_world_map2_city_notice",
		["resp_args"] =
		{
			{["key"]="type",["type"]="Signed32",["msg"]="世界内通知玩家回城类型  @see TypeBack2City"},
		}
	},

	["312103"] = { --进场景时通知玩家当前场景的任务进度
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 68", --未包含协议头部长度
		["resp_func"] = "resp_task_data_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--TaskDataInfo
				["msg"]="任务进度信息列表",
				["struct"]=
				{
					{["key"]="taskId",["type"]="Signed32",["msg"]="子任务id"},
					{["key"]="status",["type"]="Signed32",["msg"]="0:已接,1:已完成,2:失败"},
					{
						["key"]="type",
						["type"]="Signed32[5]",
						["msg"]="条件类型@TypeTaskCond, -1不用处理",
					},
					{
						["key"]="id",
						["type"]="Signed32[5]",
						["msg"]="怪物、道具id",
					},
					{
						["key"]="count",
						["type"]="Signed32[5]",
						["msg"]="数量",
					},
				}
			},
		}
	},

	["312104"] = { --任务进度改变通知
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 68, --未包含协议头部长度
		["resp_func"] = "resp_task_data",
		["resp_args"] =
		{
			{
				["key"]="data",
				["type"]="struct",	--TaskDataInfo
				["msg"]="任务进度信息",
				["struct"]=
				{
					{["key"]="taskId",["type"]="Signed32",["msg"]="子任务id"},
					{["key"]="status",["type"]="Signed32",["msg"]="0:已接,1:已完成,2:失败"},
					{
						["key"]="type",
						["type"]="Signed32[5]",
						["msg"]="条件类型@TypeTaskCond, -1不用处理",
					},
					{
						["key"]="id",
						["type"]="Signed32[5]",
						["msg"]="怪物、道具id",
					},
					{
						["key"]="count",
						["type"]="Signed32[5]",
						["msg"]="数量",
					},
				}
			},
		}
	},

	["312105"] = { --掉落通知
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 32", --未包含协议头部长度
		["resp_func"] = "resp_monster_drop",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--PlayerRewardInfo
				["msg"]="掉落列表",
				["struct"]=
				{
					{["key"]="id",["type"]="Signed32",["msg"]="唯一id，用于拾取同步"},
					{["key"]="uid",["type"]="Signed64",["msg"]="所属玩家uid"},
					{["key"]="goodsId",["type"]="Signed32",["msg"]="物品id，也可能是金币、钻石等@TypeAward"},
					{["key"]="count",["type"]="Signed32",["msg"]="数量"},
					{["key"]="x",["type"]="Signed32",["msg"]="坐标x"},
					{["key"]="y",["type"]="Signed32",["msg"]="坐标y"},
					{["key"]="z",["type"]="Signed32",["msg"]="坐标z"},
				}
			},
		}
	},

	["312106"] = { --任务失败通知
		["module_name"] = "map", --大地图
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_task_failure",
		["resp_args"] =
		{
			{["key"]="childTaskId",["type"]="Signed32",["msg"]="子任务ID"},
			{["key"]="mainTaskId",["type"]="Signed32",["msg"]="主任务ID"},
		}
	},

	["410001"] = { --发给目标的私聊信息
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 568, --未包含协议头部长度
		["resp_func"] = "resp_send_private",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="发送者装备收集数量"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["410002"] = { --发给目标的队伍聊天
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 568, --未包含协议头部长度
		["resp_func"] = "resp_send_team",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="发送者装备收集数量"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["410003"] = { --发给目标的公会聊天
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 568, --未包含协议头部长度
		["resp_func"] = "resp_send_guild",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="发送者装备收集数量"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["410004"] = { --发给目标的世界聊天
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 568, --未包含协议头部长度
		["resp_func"] = "resp_send_world",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="发送者装备收集数量"},
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["410005"] = { --系统广播
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 256, --未包含协议头部长度
		["resp_func"] = "resp_send_broadcast",
		["resp_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["410101"] = { --发送消息目标不在线
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_send_msg_result",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="0目标已下线, 1成功"},
		}
	},

	["410102"] = { --邀请好友打神谕
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 328, --未包含协议头部长度
		["resp_func"] = "resp_oracle_invite_friend",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一id"},
			{["key"]="stage",["type"]="Signed64",["msg"]="神谕的等阶"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="神谕的触发时间"},
		}
	},

	["410103"] = { --邀请世界打神谕
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 328, --未包含协议头部长度
		["resp_func"] = "resp_oracle_invite_world",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="发送者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="senderNick",["type"]="UTF8String[40]",["msg"]="发送者名字"},
			{["key"]="oracleId",["type"]="Signed64",["msg"]="唯一id"},
			{["key"]="stage",["type"]="Signed64",["msg"]="神谕的等阶"},
			{["key"]="createTime",["type"]="Signed32",["msg"]="神谕的触发时间"},
		}
	},

	["410104"] = { --离线神谕好友邀请
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 368", --未包含协议头部长度
		["resp_func"] = "resp_chat_record",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChatRecord
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="senderId",["type"]="Signed64",["msg"]="玩家ID"},
					{["key"]="senderIcon",["type"]="Signed32",["msg"]="发送者icon"},
					{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
					{["key"]="sender",["type"]="UTF8String[40]",["msg"]="昵称"},
					{["key"]="target",["type"]="Signed64",["msg"]="目标"},
					{["key"]="createTime",["type"]="Signed32",["msg"]="消息时间"},
					{["key"]="msg",["type"]="UTF8String[32]",["msg"]="消息内容"},
					{["key"]="oracleId",["type"]="Signed64",["msg"]="ID"},
					{["key"]="stage",["type"]="Signed32",["msg"]="神谕的等阶"},
					{["key"]="oracleTime",["type"]="Signed32",["msg"]="神谕触发时间"},
				}
			},
		}
	},

	["410105"] = { --好友列表
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "36 + num * 503", --未包含协议头部长度
		["resp_func"] = "resp_friend_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于好友助战验证"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--FriendInfo
				["msg"]="好友列表",
				["struct"]=
				{
					{["key"]="uId",["type"]="Signed64",["msg"]="好友ID"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="好友名称"},
					{["key"]="icon",["type"]="Signed32",["msg"]="icon"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed8",["msg"]="等级"},
					{["key"]="vipLevel",["type"]="Signed8",["msg"]="Vip等级"},
					{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
					{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
					{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
					{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
					{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
					{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
					{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
					{["key"]="isOnline",["type"]="Bool",["msg"]="是否在线"},
					{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
					{["key"]="arenaWinQuick",["type"]="Signed32",["msg"]="快速匹配胜利次数"},
					{["key"]="arenaRankTeam",["type"]="Signed32",["msg"]="3v3最高排名"},
					{["key"]="arenaRank",["type"]="Signed32",["msg"]="个人排位"},
					{["key"]="guildId",["type"]="Signed64",["msg"]="公会ID"},
					{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="公会名称"},
					{["key"]="guildLevel",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
					{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于赠送验证"},
					{["key"]="offLineTime",["type"]="Signed32",["msg"]="下线时间"},
				}
			},
		}
	},

	["410106"] = { --返回邀请世界加入公会
		["module_name"] = "chat", --聊天
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 402, --未包含协议头部长度
		["resp_func"] = "resp_guild_invite_world",
		["resp_args"] =
		{
			{["key"]="sender",["type"]="Signed64",["msg"]="邀请者uid"},
			{["key"]="senderIcon",["type"]="Signed32",["msg"]="邀请者图标"},
			{["key"]="senderIconUrl",["type"]="UTF8String[256]",["msg"]="发送者头像URL"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="邀请公会ID"},
			{["key"]="guildName",["type"]="UTF8String[32]",["msg"]="邀请公会名字"},
			{["key"]="sendErName",["type"]="UTF8String[40]",["msg"]="邀请者名称"},
			{["key"]="outfitCollect",["type"]="Signed32",["msg"]="邀请者装备收集数量"},
			{["key"]="msg",["type"]="UTF8String[50]",["msg"]="邀请消息"},
		}
	},

	["540201"] = { --通知玩家公会
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 8, --未包含协议头部长度
		["resp_func"] = "resp_notice_guild",
		["resp_args"] =
		{
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会Id"},
		}
	},

	["540202"] = { --通知玩家队伍成员
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "4 + num * 321", --未包含协议头部长度
		["resp_func"] = "resp_boss_team_player",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--BossTeamPlayer
				["msg"]="队伍内玩家信息",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
					{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
					{["key"]="level",["type"]="Signed32",["msg"]="玩家等级"},
					{["key"]="icon",["type"]="Signed32",["msg"]="玩家Icon"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="玩家IconUrl"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄Id"},
					{["key"]="heroLevel",["type"]="Signed32",["msg"]="英雄等级"},
					{["key"]="isCaptain",["type"]="Bool",["msg"]="是否是队长"},
				}
			},
		}
	},

	["540203"] = { --邀请进入队伍
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 48, --未包含协议头部长度
		["resp_func"] = "resp_be_invite_into_team",
		["resp_args"] =
		{
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
			{["key"]="teamNo",["type"]="Signed32",["msg"]="队伍号"},
			{["key"]="bossId",["type"]="Signed32",["msg"]="bossId"},
		}
	},

	["540204"] = { --队伍解散
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["resp_func"] = "resp_team_disapper",
		["resp_args"] =
		{
		}
	},

	["540301"] = { --通知客户端登录聊天服
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 401, --未包含协议头部长度
		["resp_func"] = "resp_login_chat",
		["resp_args"] =
		{
			{["key"]="uid",["type"]="Signed64",["msg"]="uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="玩家昵称"},
			{["key"]="teamId",["type"]="Signed64",["msg"]="队伍id"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="公会id"},
			{["key"]="guildname",["type"]="UTF8String[32]",["msg"]="公会名称"},
			{["key"]="heroIcon",["type"]="Signed32",["msg"]="头像ID"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像地址"},
			{["key"]="level",["type"]="Signed32",["msg"]="等级"},
			{["key"]="time",["type"]="Signed32",["msg"]="生成sign的时间戳(秒), 用于验证其是否过期"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="校验值(对玩家信息生成的md5校验码, 用于防止伪造信息登录聊天服)"},
			{["key"]="zoneId",["type"]="Signed32",["msg"]="区"},
			{["key"]="isMute",["type"]="Bool",["msg"]="禁言"},
		}
	},

	["540501"] = { --给客户端发送系统消息
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 256, --未包含协议头部长度
		["resp_func"] = "resp_send_system_msg",
		["resp_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[256]",["msg"]="内容"},
		}
	},

	["540550"] = { --成功创建公会
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_create_guild",
		["resp_args"] =
		{
			{["key"]="result",["type"]="Signed32",["msg"]="结果：1成功, 0失败"},
		}
	},

	["540551"] = { --通知玩家有公会邀请你加入
		["module_name"] = "guild", --公会
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 52, --未包含协议头部长度
		["resp_func"] = "resp_notice_invite_player_in_to_guild",
		["resp_args"] =
		{
			{["key"]="reqInviterUid",["type"]="Signed64",["msg"]="邀请方玩家id"},
			{["key"]="inviteGuildId",["type"]="Signed64",["msg"]="邀请加入的公会id"},
			{["key"]="inviteGuildIcon",["type"]="Signed32",["msg"]="邀请加入的公会Icon"},
			{["key"]="inviteGuildName",["type"]="UTF8String[32]",["msg"]="邀请加入的公会名称"},
		}
	},

	["540601"] = { --返回查看自己混沌之渊相关信息
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 40, --未包含协议头部长度
		["resp_func"] = "resp_challenge_info",
		["resp_args"] =
		{
			{["key"]="layer",["type"]="Signed32",["msg"]="玩家当前所在层数"},
			{["key"]="rank",["type"]="Signed32",["msg"]="排行榜排名"},
			{["key"]="dayRewardIngot",["type"]="Signed32",["msg"]="每天可获得的钻石奖励"},
			{["key"]="dayRewardCp",["type"]="Signed32",["msg"]="每天可获得的混沌点数奖励"},
			{["key"]="ingot",["type"]="Signed32",["msg"]="可领取的钻石奖励"},
			{["key"]="challengePoint",["type"]="Signed32",["msg"]="可领取的混沌点数奖励"},
			{["key"]="remainChallengeCount",["type"]="Signed32",["msg"]="剩余进军次数"},
			{["key"]="coolDownTime",["type"]="Signed32",["msg"]="整顿完毕的时间戳(s)"},
			{["key"]="challengeBuyCount",["type"]="Signed32",["msg"]="今天已经购买次数"},
			{["key"]="remainBuyCount",["type"]="Signed32",["msg"]="今天剩余购买次数"},
		}
	},

	["540602"] = { --返回查看混沌之渊挑战目标信息
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "850 + num * 388", --未包含协议头部长度
		["resp_func"] = "resp_challenge_target",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="myTeamAtk",["type"]="UTF8String[70]",["msg"]="自己的攻击阵型"},
			{
				["key"]="self",
				["type"]="struct",	--ChallengePlayer
				["msg"]="自己",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid，或npc的id"},
					{["key"]="isPlayer",["type"]="Bool",["msg"]="是玩家还是npc"},
					{["key"]="isLock",["type"]="Bool",["msg"]="是否被锁定"},
					{["key"]="layer",["type"]="Signed32",["msg"]="层数"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="teamDef",["type"]="UTF8String[70]",["msg"]="防守阵型布阵信息"},
				}
			},
			{
				["key"]="target",
				["type"]="struct",	--ChallengePlayer
				["msg"]="下阶段的目标",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid，或npc的id"},
					{["key"]="isPlayer",["type"]="Bool",["msg"]="是玩家还是npc"},
					{["key"]="isLock",["type"]="Bool",["msg"]="是否被锁定"},
					{["key"]="layer",["type"]="Signed32",["msg"]="层数"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="teamDef",["type"]="UTF8String[70]",["msg"]="防守阵型布阵信息"},
				}
			},
			{
				["key"]="list",
				["type"]="struct[$num]",	--ChallengePlayer
				["msg"]="+1 ~ +20的目标",
				["struct"]=
				{
					{["key"]="uid",["type"]="Signed64",["msg"]="玩家的uid，或npc的id"},
					{["key"]="isPlayer",["type"]="Bool",["msg"]="是玩家还是npc"},
					{["key"]="isLock",["type"]="Bool",["msg"]="是否被锁定"},
					{["key"]="layer",["type"]="Signed32",["msg"]="层数"},
					{["key"]="name",["type"]="UTF8String[40]",["msg"]="角色名"},
					{["key"]="icon",["type"]="Signed32",["msg"]="头像"},
					{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像URL"},
					{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
					{["key"]="teamDef",["type"]="UTF8String[70]",["msg"]="防守阵型布阵信息"},
				}
			},
		}
	},

	["540603"] = { --返回出战
		["module_name"] = "challenge", --混沌之渊
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "17 + num * 68", --未包含协议头部长度
		["resp_func"] = "resp_challenge_attack",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="battleId",["type"]="Signed32",["msg"]="用来结算时发送给服务器"},
			{["key"]="stage",["type"]="Signed32",["msg"]="挑战目标的阶段, 如果是挑战npc要根据层数来生成数据"},
			{["key"]="layer",["type"]="Signed32",["msg"]="挑战目标的层数, 如果是挑战npc要根据层数来生成数据"},
			{["key"]="isPlayer",["type"]="Bool",["msg"]="挑战目标是否为玩家"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--HeroAttr
				["msg"]="目标",
				["struct"]=
				{
					{["key"]="pos",["type"]="Signed32",["msg"]="对应战场位置[1, 9]"},
					{["key"]="heroId",["type"]="Signed32",["msg"]="英雄id"},
					{["key"]="atk",["type"]="Signed32",["msg"]="攻击力"},
					{["key"]="hp",["type"]="Signed32",["msg"]="生命值"},
					{["key"]="armor",["type"]="Signed32",["msg"]="物理护甲"},
					{["key"]="magicDef",["type"]="Signed32",["msg"]="魔法抗性"},
					{["key"]="crit",["type"]="Signed32",["msg"]="暴击"},
					{["key"]="dodge",["type"]="Signed32",["msg"]="闪避"},
					{["key"]="iceDef",["type"]="Signed32",["msg"]="冰属性抗性"},
					{["key"]="fireDef",["type"]="Signed32",["msg"]="火属性抗性"},
					{["key"]="fulmDef",["type"]="Signed32",["msg"]="电属性抗性"},
					{["key"]="poisonDef",["type"]="Signed32",["msg"]="毒属性抗性"},
					{["key"]="skillLv1",["type"]="Signed32",["msg"]="技能1等级"},
					{["key"]="skillLv2",["type"]="Signed32",["msg"]="技能2等级"},
					{["key"]="skillLv3",["type"]="Signed32",["msg"]="技能3等级"},
					{["key"]="skillLv4",["type"]="Signed32",["msg"]="技能4等级"},
					{["key"]="skillLv5",["type"]="Signed32",["msg"]="技能5等级"},
				}
			},
		}
	},

	["540701"] = { --玩家反馈回复通知
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 204, --未包含协议头部长度
		["resp_func"] = "resp_reply_feedback",
		["resp_args"] =
		{
			{["key"]="id",["type"]="Signed32",["msg"]="反馈的id"},
			{["key"]="content",["type"]="UTF8String[200]",["msg"]="回复内容"},
		}
	},

	["540702"] = { --循环公告
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 1100, --未包含协议头部长度
		["resp_func"] = "resp_cycle_notice",
		["resp_args"] =
		{
			{["key"]="title",["type"]="UTF8String[100]",["msg"]="标题"},
			{["key"]="content",["type"]="UTF8String[1000]",["msg"]="内容"},
		}
	},

	["540703"] = { --系统通知
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_system_notice",
		["resp_args"] =
		{
			{["key"]="text",["type"]="UTF8String[100]",["msg"]="提示信息"},
		}
	},

	["540704"] = { --踢下线通知
		["module_name"] = "system", --系统
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_kick",
		["resp_args"] =
		{
			{["key"]="text",["type"]="UTF8String[100]",["msg"]="提示信息"},
		}
	},

	["540705"] = { --游戏进度
		["module_name"] = "system", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 116, --未包含协议头部长度
		["resp_func"] = "resp_game_schedule",
		["resp_args"] =
		{
			{
				["key"]="schedule",
				["type"]="struct",	--ScheduleInfo
				["msg"]="游戏进度",
				["struct"]=
				{
					{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
					{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
					{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
					{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
					{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
					{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
					{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
					{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
					{["key"]="arenaWinQuick",["type"]="Signed32",["msg"]="快速匹配胜利次数"},
					{["key"]="arenaRankTeam",["type"]="Signed32",["msg"]="3v3最高排名"},
					{["key"]="arenaRank",["type"]="Signed32",["msg"]="个人排位"},
					{["key"]="guildLevel",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
				}
			},
		}
	},

	["540706"] = { --查看目标信息
		["module_name"] = "system", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 630, --未包含协议头部长度
		["resp_func"] = "resp_target_schedule",
		["resp_args"] =
		{
			{["key"]="targetId",["type"]="Signed64",["msg"]="uid"},
			{["key"]="nick",["type"]="UTF8String[40]",["msg"]="角色名"},
			{["key"]="level",["type"]="Signed32",["msg"]="角色等级"},
			{["key"]="icon",["type"]="Signed32",["msg"]="角色头像"},
			{["key"]="heroList",["type"]="UTF8String[150]",["msg"]="英雄id列表(id1,id2..)"},
			{["key"]="iconUrl",["type"]="UTF8String[256]",["msg"]="头像地址"},
			{["key"]="iconFrame",["type"]="Signed32",["msg"]="头像外框"},
			{["key"]="pvpWin",["type"]="Signed32",["msg"]="快速匹配胜利场次"},
			{["key"]="rankStage",["type"]="Signed32",["msg"]="排位赛段位"},
			{["key"]="guildId",["type"]="Signed64",["msg"]="工会id"},
			{["key"]="guildname",["type"]="UTF8String[32]",["msg"]="工会名称"},
			{
				["key"]="schedule",
				["type"]="struct",	--ScheduleInfo
				["msg"]="游戏进度",
				["struct"]=
				{
					{["key"]="hero",["type"]="Signed32",["msg"]="英雄数"},
					{["key"]="totalHero",["type"]="Signed32",["msg"]="总英雄数"},
					{["key"]="achieveNum",["type"]="Signed32",["msg"]="成就数"},
					{["key"]="totalAchieve",["type"]="Signed32",["msg"]="总成总数"},
					{["key"]="collection",["type"]="Signed32",["msg"]="书页数"},
					{["key"]="totalCollect",["type"]="Signed32",["msg"]="书页总数"},
					{["key"]="diablo",["type"]="Signed32",["msg"]="黑暗之境层数"},
					{["key"]="challenge",["type"]="Signed32",["msg"]="混沌之渊层数"},
					{["key"]="rank",["type"]="Signed32",["msg"]="混沌之渊排名"},
					{["key"]="signature",["type"]="UTF8String[60]",["msg"]="个性签名"},
					{["key"]="arenaWinQuick",["type"]="Signed32",["msg"]="快速匹配胜利次数"},
					{["key"]="arenaRankTeam",["type"]="Signed32",["msg"]="3v3最高排名"},
					{["key"]="arenaRank",["type"]="Signed32",["msg"]="个人排位"},
					{["key"]="guildLevel",["type"]="Signed32",["msg"]="公会等级"},
					{["key"]="guildRank",["type"]="Signed32",["msg"]="公会排名"},
				}
			},
		}
	},

	["540707"] = { --红点提示
		["module_name"] = "system", --游戏进度
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = "8 + num * 17", --未包含协议头部长度
		["resp_func"] = "resp_red_point_tip_list",
		["resp_args"] =
		{
			{["key"]="num",["type"]="Signed32",["msg"]="列表数量"},
			{["key"]="noticeType",["type"]="Signed32",["msg"]="类型：1：所有红点数据，2：某个红点数据(有功能更新)"},
			{
				["key"]="list",
				["type"]="struct[$num]",	--RedPointTip
				["msg"]="列表",
				["struct"]=
				{
					{["key"]="type",["type"]="Signed32",["msg"]="类型"},
					{["key"]="canReward",["type"]="Signed8",["msg"]="当前是否可领奖(1:是,2:否)"},
					{["key"]="param1",["type"]="Signed32",["msg"]="参数1"},
					{["key"]="param2",["type"]="Signed32",["msg"]="参数2(预留)"},
					{["key"]="time",["type"]="Signed32",["msg"]="时间"},
				}
			},
		}
	},

	["720001"] = { --通知目标位置变化
		["module_name"] = "queue", --排队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 4, --未包含协议头部长度
		["resp_func"] = "resp_queue_pos",
		["resp_args"] =
		{
			{["key"]="count",["type"]="Signed32",["msg"]="排在前面的玩家数"},
		}
	},

	["720002"] = { --通知目标可以登录
		["module_name"] = "queue", --排队
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 36, --未包含协议头部长度
		["resp_func"] = "resp_notice_login",
		["resp_args"] =
		{
			{["key"]="expireTime",["type"]="Signed32",["msg"]="校验码过期时间，登录时一起发给服务器"},
			{["key"]="sign",["type"]="UTF8String[32]",["msg"]="用于登录游戏服的校验码"},
		}
	},

	["730101"] = { --通知客户端公告
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 500, --未包含协议头部长度
		["resp_func"] = "resp_otice",
		["resp_args"] =
		{
			{["key"]="content",["type"]="UTF8String[500]",["msg"]="公告内容"},
		}
	},

	["730102"] = { --通知客户端断线重新登录
		["module_name"] = "system", --系统通知
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 100, --未包含协议头部长度
		["resp_func"] = "resp_ogout",
		["resp_args"] =
		{
			{["key"]="msg",["type"]="UTF8String[100]",["msg"]="登出提示"},
		}
	},

	["2000"] = { --
		["module_name"] = "common", --通用协议
		["socket_type"] = "game",
		["req_socket_size"] = 68, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["resp_func"] = "resp_res_error",
		["resp_args"] =
		{
		}
	},

	["2001"] = { --
		["module_name"] = "common", --通用协议
		["socket_type"] = "game",
		["req_socket_size"] = 134, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["resp_func"] = "resp_res_success",
		["resp_args"] =
		{
		}
	},

	["2002"] = { --
		["module_name"] = "common", --通用协议
		["socket_type"] = "game",
		["req_socket_size"] = 132, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["resp_func"] = "resp_res_fail",
		["resp_args"] =
		{
		}
	},

	["2010"] = { --
		["module_name"] = "common", --通用协议
		["socket_type"] = "game",
		["req_socket_size"] = 0, --未包含协议头部长度
		["resp_socket_size"] = 0, --未包含协议头部长度
		["resp_func"] = "resp_req_no_param",
		["resp_args"] =
		{
		}
	},

}
return RPC_func_table