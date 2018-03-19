# Lua代码规范
##零、文件命名
目录，框架和自动生成的代码，小写加下划线命名
```
framework/core/base_cmd.lua
common/net_cmd/protocol_login.lua
```
手动编写的lua文件，为了配合代码模板生成，可以使用火箭命名法
```
framework/demo/InstanceMediator.lua
```


驼峰命名法(camel命名法)小写字母开头，大小写混合，每个单词第一个字母大写，如：doSomeThing <br>
火箭命名法(Pascal命名法)大写字母开头，大小写混合,每个单词第一个字母大写，如：DoSomeThing

## 一、通用命名规范
未说明对象一律用骆驼峰命名,
 lua目录下的文件夹名，使用小写加下划线 _ 命名，主要是为了避免不同系统的大小写问题。
 大小写错误，在windows下可以正常运行，但是到了手机系统就不行了。采用好的开发环境可以大大降低这种出错可能。
(其实如果大小写使用规范，也是可以使用驼峰命名法的)

## 二、类定义
类名称开头加上大写字符‘C’，必然让读者一眼就能理解到这是一个类，单词第一个字母用大写形式，例如：
定义一个名叫player的类，格式如下：CPlayer

###避免多方维护，以Tapd的Wiki为准

[程序员工作流程](https://www.tapd.cn/21091901/markdown_wikis/view/#1121091901001000597)
[lua编码规范](https://www.tapd.cn/21091901/markdown_wikis/view/#1121091901001000619)
[lua目录说明](https://www.tapd.cn/21091901/markdown_wikis/#1121091901001000395)

#针对 if 函数的编写建议

- 1.任何一个非Boolean型变量判断真假时，都要显示的写上条件， 禁止如下写法
```
if someNotBoolValue then
end
```
推荐写法如下：
```
if someNotBoolValue ~=nil then
end
```
- 2.Boolean判断真假写法推荐：
```
--真，推荐写法
if someBool == true then
    --do something
end
--真，（X）不推荐(错误写法)
if someBool then
    --do something
end

--假，推荐写法
if someBool ~= true then
    --do something
end
--假, （X）不推荐(错误写法)
if not someBool then
    --do something
end
--假, （X）不推荐（错误写法）
if someBool == false then
    --do something
end
```
- 3.Lua里没有continue关键字，用if else代替，不要发明各种怪异的写法

- 4.Lua里没有switch关键字，用if else代替

##附录：
###对toLua的修改

1. 将Tolua的import改为local,这样一来就可以使用PLoop的import了。
