/**
 * 文件名称：UtilEx.cs
 * 简    述：场景中的框架中额外功能进行封装，这样就不用把复杂类对象导入lua即可使用。
 * th,判断网络状态等等，方便Lua中使用。
 * 创建标识：Lorry 2018/1/26
 **/
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LuaFramework
{

    public class UtilEx
    {
        public static void SetMainCamaraEnable(bool vIsEnable)
        {
            //SceneManager.Instance.SetCurrentMainCamaraEnable(vIsEnable);
        }

        /// <summary>
        /// 对比版本号，0不用更新，1更新资源，2重新下载安装包
        /// </summary>
        /// <param name="oldVersionStr">旧版本号</param>
        /// <param name="newVersionStr">新版本号</param>
        /// <returns></returns>
        public static int VersionCompare(string oldVersionStr, string newVersionStr)
        {
            if (oldVersionStr.Equals(newVersionStr))
            {
                return 0;
            }
            else
            {
                string[] s1 = oldVersionStr.Split(new char[] { '.' });
                string[] s2 = newVersionStr.Split(new char[] { '.' });
                //0是大版本号  1 是主版本号，2 是热更小版本号
                if(int.Parse(s2[0]) !=  int.Parse(s1[0]))
                {//大版本号不同一定要下载安装包
                    return 2;
                }

                if (int.Parse(s2[1]) > int.Parse(s1[1]))
                {//主版本号不同，代表有C#代码修改，也需要下载安装包
                    return 2;
                }

                if (int.Parse(s2[2]) < int.Parse(s1[2]))
                {//如果出现自己的版本比服务器版本还新的情况。特殊处理,第一打开
                    if (IsFirstOpen())
                        return 1;
                    else
                        return 0;
                }
                return 1;
            }
        }
        /// <summary>
        /// 是否第一次打游戏(主要用于判断是否需要释放资源)。
        /// </summary>
        /// <returns></returns>
        public static bool IsFirstOpen()
        {
            bool hadExtractResource = Directory.Exists(Util.DataPath) &&
              Directory.Exists(Util.DataPath + "lua/") &&
              File.Exists(Util.DataPath + "files.txt");
            return !hadExtractResource;
        }
    }
}
