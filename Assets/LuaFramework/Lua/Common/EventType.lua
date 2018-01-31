--准备在lua中接收框架自带事件中心的事件消息--
EventType =
{
    --这几个是和NotiConst.cs对应的

    --解包要展示的相关参数
    EXTRACT_FILE_NAME = "EXTRACT_FILE_NAME",           --解包文件名
    EXTRACT_FINISH_ONE = "EXTRACT_FINISH_ONE",         --解包完一个文件
    EXTRACT_ALL_COUNT = "EXTRACT_ALL_COUNT",           --解包总文件数

    --更新要展示的相关参数
    UPDATE_SPEED = "UPDATE_SPEED",                     --下载速度
    UPDATE_FILE_NAME = "UPDATE_FILE_NAME",             --下载文件名
    UPDATE_FINISH_ONE = "UPDATE_FINISH_ONE",           --下载完一个文件
    UPDATE_ALL_COUNT = "UPDATE_ALL_COUNT",             --下载总文件数
}
