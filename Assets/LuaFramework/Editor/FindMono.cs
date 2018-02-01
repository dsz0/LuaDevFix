/**
 * Copyright (c) 2018,广州XXX软件有限公司
 * All rights reserved.
 * 文件名称：FindMono.cs
 * 简述：用于查找节点和其所有子节点中，是否有指定的脚本组件。
 * 创建标识：Lorry 2017/12/28
 */

using UnityEngine;
using System.Collections.Generic;
using UnityEditor;

/////////////////////////////////////////////////////////////////////////////  
//查找节点及所有子节点中,是否有指定的脚本组件  
/////////////////////////////////////////////////////////////////////////////
public class FindMono : EditorWindow
{
    Transform root = null;
    MonoScript scriptObj = null;
    int loopCount = 0;

    List<Transform> results = new List<Transform>();

    [MenuItem("LuaRaziel/Tools/针对节点FindMono", false,201)]
    static void Init()
    {
        EditorWindow.GetWindow(typeof(FindMono));
    }

    void OnGUI()
    {
        GUILayout.Label("目标节点:");
        root = (Transform)EditorGUILayout.ObjectField(root, typeof(Transform), true);
        GUILayout.Label("要查找的脚本:");
        scriptObj = (MonoScript)EditorGUILayout.ObjectField(scriptObj, typeof(MonoScript), true);
        if (GUILayout.Button("Find"))
        {
            results.Clear();
            loopCount = 0;
            Debug.Log("开始查找.");
            FindScript(root);
        }
        if (results.Count > 0)
        {
            foreach (Transform t in results)
            {
                EditorGUILayout.ObjectField(t, typeof(Transform), false);
            }
        }
        else
        {
            GUILayout.Label("无数据");
        }
    }

    void FindScript(Transform root)
    {
        if (root != null && scriptObj != null)
        {
            loopCount++;
            Debug.Log(".." + loopCount + ":" + root.gameObject.name);
            if (root.GetComponent(scriptObj.GetClass()) != null)
            {
                results.Add(root);
            }
            foreach (Transform t in root)
            {
                FindScript(t);
            }
        }
    }
}