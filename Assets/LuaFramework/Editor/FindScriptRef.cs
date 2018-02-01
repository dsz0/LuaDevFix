/**
 * Copyright (c) 2018,广州XXX软件有限公司
 * All rights reserved.
 * 文件名称：FindScriptRef.cs
 * 简    述：[使用情形]有时候我们需要找出项目中所有的引用到某个脚本的地方（比如Prefabs/Scene GameObjects等）。
 * 当项目比较大时，手工寻找非常费时费力。我们可以使用脚本来自动完成。
 * 
 * [基本思路]：首先筛选出项目中全部Prefab，加载每个Prefab并判断是否有挂载目标脚本。
 * 然后载入每个场景，判断场景中每个物体是否有挂载目标脚本，最后列出结果。
 * 
 * [操作方法]：在Project窗口选中一个scrpit，右键选择『Find All Reference』，在打开的窗口选择『Find』按钮，
 * 即可看到下面列出了所有引用了这个脚本的位置（如果项目庞大，可能需要等待一会儿）。
 * 创建标识：Lorry 2017/12/28
 **/
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using UnityEditor.SceneManagement;

///<summary>搜索指定脚本在整个项目中的引用
///<para>耗时较久，可能造成开发环境卡顿，请耐性等待，谨慎使用</para>
///</summary>
///<c>GUILayout.Label(name); </c>
///<c>bool click = GUILayout.Button("Find");</c>
///<c>GUILayout.EndHorizontal();
///GUILayout.Space(10);
/// Selection.activeObject == null
///</c>
public class FindScriptRef : EditorWindow
{
    //Transform root = null;
    //MonoScript scriptObj = null;
    //int loopCount = 0;

    //List<Transform> results = new List<Transform>();
    List<string> findResult;

    [MenuItem("LuaRaziel/Tools/查找选中脚本的全部Ref",false,202)]
    static void Init()
    {
        //Show
        EditorWindow.GetWindow(typeof(FindScriptRef));
    }
    void OnGUI()
    {
        if (Selection.activeObject == null)
        {
            GUILayout.Label("select a script file from Project Window.");
            return;
        }

        //判断选中项是否为脚本
        var name = Selection.activeObject.name;
        System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
        var dict = System.IO.Path.GetDirectoryName(assembly.Location);
        assembly = System.Reflection.Assembly.LoadFile(System.IO.Path.Combine(dict, "Assembly-CSharp.dll"));
        var selectType = assembly.GetType(name);
        if (string.IsNullOrEmpty(name) || selectType == null)
        {
            GUILayout.Label("select a script file from Project Window.");
            return;
        }

        GUILayout.BeginVertical();
        GUILayout.BeginHorizontal();

        //列出脚本名称和“Find”按钮
        GUILayout.Label(name);
        bool click = GUILayout.Button("Find");
        GUILayout.EndHorizontal();
        GUILayout.Space(10);

        //列出搜索结果
        if (findResult != null && findResult.Count > 0)
        {
            GUILayout.BeginScrollView(Vector2.zero, GUIStyle.none);
            foreach (string path in findResult)
            {
                GUILayout.Label(path);
            }
            GUILayout.EndScrollView();
        }

        if (click)
        {
            Find(selectType);
        }
        GUILayout.EndVertical();

    }

    ///<summary>1.搜索assets目录中的引用; 
    ///2.搜索场景scene中的引用</summary>
    void Find(System.Type type)
    {
        //step 1:find ref in assets

        //filter all GameObject from assets（so-called 'Prefab'）
        var guids = AssetDatabase.FindAssets("t:GameObject");

        findResult = new List<string>();

        var tp = typeof(GameObject);

        foreach (var guid in guids)
        {
            var path = AssetDatabase.GUIDToAssetPath(guid);

            //load Prefab
            var obj = AssetDatabase.LoadAssetAtPath(path, tp) as GameObject;

            //check whether prefab contains script with type 'type'
            if (obj != null)
            {
                var cmp = obj.GetComponent(type);
                if (cmp == null)
                {
                    cmp = obj.GetComponentInChildren(type);
                }
                if (cmp != null)
                {
                    findResult.Add(path);
                }
            }
        }

        //step 2: find ref in scenes

        //save current scene
        //string curScene = EditorApplication.currentScene;
        string curScene = EditorSceneManager.GetActiveScene().path;
        //EditorApplication.SaveScene();
        EditorSceneManager.SaveOpenScenes();

        //find all scenes from dataPath
        string[] scenes = Directory.GetFiles(Application.dataPath, "*.unity", System.IO.SearchOption.AllDirectories);

        //iterates all scenes 
        foreach (var scene in scenes)
        {
            EditorSceneManager.OpenScene(scene);
            //EditorApplication.OpenScene(scene);

            //iterates all gameObjects
            foreach (GameObject obj in FindObjectsOfType<GameObject>())
            {
                var cmp = obj.GetComponent(type);
                if (cmp == null)
                {
                    cmp = obj.GetComponentInChildren(type);
                }
                if (cmp != null)
                {
                    findResult.Add(scene.Substring(Application.dataPath.Length) + "Assets:" + obj.name);
                }
            }
        }

        //reopen current scene
        EditorSceneManager.OpenScene(curScene);
        //EditorApplication.OpenScene(curScene);
        Debug.Log("finish");
    }
}