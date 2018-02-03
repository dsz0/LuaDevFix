/**
 * 文件名称：UtilEx.cs
 * 简    述：场景中的框架中额外功能进行封装，这样就不用把复杂类对象导入lua即可使用。
 * th,判断网络状态等等，方便Lua中使用。
 * 创建标识：Lorry 2018/1/26
 **/

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
      
    }
}
