/**
 * 文件名称：PanelManager.cs
 * 简    述：主要是为了让lua中能方便的生成UIPanel面板。
 * 使用方法：在框架中基本上不需要对其进行调用。
 * 主要是在lua的中XXXMediator的创建面板时()中调用panelMgr:CreatePanel，销毁面板时调用panelMgr:ClosePanel
 * 另外提供对于面板gameObject的ShowPanel和HidePanel函数。在这里实现，主要是方便调整。
 * 1.使用SetActive(bool)的方式进行设置。
 * 2.如果消耗太大，可以靠移动位置的方式隐藏。
 * 创建标识：Lorry 2018/1/26
 **/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

namespace LuaFramework
{
    public class PanelManager : Manager
    {
        //private Transform parent;

        Transform Parent
        {
            get
            {
                //if (parent == null)
                //{
                //    GameObject.Find("Camera");
                //    //GameObject go = GameObject.FindWithTag("GuiCamera");
                //    if (go != null) parent = go.transform;
                //}
                //return parent;
                return GameUICommand.GetCur_UICamera();
            }
        }

        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, LuaFunction func = null)
        {
            string assetName = name + "Panel";
            string abName = name.ToLower();// + AppConst.ExtName;
            if (Parent.Find(name) != null) return;

//#if ASYNC_MODE
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs)
            {
                if (objs.Length == 0) return;
                GameObject prefab = objs[0] as GameObject;
                if (prefab == null) return;

                GameObject go = Instantiate(prefab) as GameObject;
                go.name = assetName;
                go.layer = LayerMask.NameToLayer("UI");
                go.transform.SetParent(Parent);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;
                go.AddComponent<LuaBehaviour>();

                if (func != null) func.Call(go);
                //Debug.LogWarning("CreatePanel::>> " + name + ",Prfab:" + prefab);
            });
//#else
//            GameObject prefab = ResManager.LoadAsset<GameObject>(name, assetName);
//            if (prefab == null) return;

//            GameObject go = Instantiate(prefab) as GameObject;
//            go.name = assetName;
//            go.layer = LayerMask.NameToLayer("Default");
//            go.transform.SetParent(Parent);
//            go.transform.localScale = Vector3.one;
//            go.transform.localPosition = Vector3.zero;
//            go.AddComponent<LuaBehaviour>();

//            if (func != null) func.Call(go);
//            Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
//#endif
        }

        /// <summary>
        /// 关闭面板
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name)
        {
            var panelName = name + "Panel";
            Transform panelObj = Parent.Find(panelName);
            if (panelObj == null) return;
            Destroy(panelObj.gameObject);
        }

        public void ShowPanel(GameObject go)
        {
            go.SetActive(true);
        }
        public void HidePanel(GameObject go)
        {
            go.SetActive(false);
        }
    }
}