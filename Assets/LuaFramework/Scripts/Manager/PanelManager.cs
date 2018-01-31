/**
 * 文件名称：PanelManager.cs
 * 简    述：主要是为了让lua中能方便的生成UIPanel面板。
 * 使用方法：在框架中基本上不需要对其进行调用。主要是在lua的XXXCtrl.Awake()中调用panelMgr:CreatePanel
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
        private Transform parent;

        Transform Parent
        {
            get
            {
                if (parent == null)
                {
                    GameObject go = GameObject.FindWithTag("GuiCamera");
                    if (go != null) parent = go.transform;
                }
                return parent;
            }
        }

        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, LuaFunction func = null)
        {
            string assetName = name + "Panel";
            string abName = name.ToLower() + AppConst.ExtName;
            if (Parent.FindChild(name) != null) return;

#if ASYNC_MODE
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs)
            {
                if (objs.Length == 0) return;
                GameObject prefab = objs[0] as GameObject;
                if (prefab == null) return;

                GameObject go = Instantiate(prefab) as GameObject;
                go.name = assetName;
                go.layer = LayerMask.NameToLayer("Default");
                go.transform.SetParent(Parent);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;
                go.AddComponent<LuaBehaviour>();

                if (func != null) func.Call(go);
                Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
            });
#else
            GameObject prefab = ResManager.LoadAsset<GameObject>(name, assetName);
            if (prefab == null) return;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.layer = LayerMask.NameToLayer("Default");
            go.transform.SetParent(Parent);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            go.AddComponent<LuaBehaviour>();

            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
#endif
        }

        /// <summary>
        /// 关闭面板
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name)
        {
            var panelName = name + "Panel";
            Transform panelObj = Parent.FindChild(panelName);
            if (panelObj == null) return;
            Destroy(panelObj.gameObject);
        }
    }
}