/**
 * Copyright (c) 2018,广州Indra软件有限公司
 * All rights reserved.
 * 文件名称：AddBuildMapUtil.cs
 * 简    述：针对HotRes中的资源,方便的生成cvs文件，让热更资源打包更加方便快捷。
 * 使用方法：点击LuaRaziel的AddBuildMapUtil菜单，首先点击读取文件(.csv),读取默认的AssetBundleInfo
 * 然后在HotRes中选中对应的目录，现在规定是Assets/XXXX/HotRes/下的Builds和Testures目录（将来可能还有模型、动画目录等）。
 * 创建标识：Lorry 2018/1/26
 **/
using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Text;
using LuaFramework;

/// <summary>
/// 后缀枚举
/// </summary>
public enum SuffixEnum
{
    Prefab,
    Png,
    Csv,
    Txt,
}

public class AddBuildMapUtil : EditorWindow
{

    int count = 0;
    List<string> bundleNameList = new List<string>();
    List<SuffixEnum> suffixList = new List<SuffixEnum>();
    List<string> pathList = new List<string>();

    Vector2 scrollValue = Vector2.zero;
    //定义一个GUI绘制的样式，便于编辑。 
    //GUIStyle tempStyle = new GUIStyle();


    [MenuItem("LuaRaziel/AddBuildMapUtil")]
    static void SetAssetBundleNameExtension()
    {
        EditorWindow.GetWindow<AddBuildMapUtil>();
    }

    void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("添加一组资源"))
        {
            AddItem();
        }
        if (GUILayout.Button("清除所有资源项"))
        {
            Clear();
        }
        if (GUILayout.Button("读取文件(.csv)"))
        {
            Clear();

            string path = EditorUtility.OpenFilePanel("", Application.dataPath + "\\" + AppConst.AppName + "\\" + "HotRes", "csv");
            string content = File.ReadAllText(path);
            string[] contents = content.Split(new string[] { "\r\n" }, System.StringSplitOptions.RemoveEmptyEntries);

            for (int i = 0; i < contents.Length; i++)
            {
                string[] a = contents[i].Split(',');
                AddItem(a[0], StringToEnum(a[1]), a[2]);
            }
        }
        if (GUILayout.Button("保存"))
        {
            string path = EditorUtility.SaveFilePanel("", Application.dataPath +"\\" + AppConst.AppName+"\\" + "HotRes", "AssetBundleInfo", "csv");
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < count; i++)
            {
                if (string.IsNullOrEmpty(bundleNameList[i])) break;
                sb.Append(bundleNameList[i] + ",");
                sb.Append(EnumToString(suffixList[i]) + ",");
                sb.Append(pathList[i] + "\r\n");
            }
            File.WriteAllText(path, sb.ToString());
            AssetDatabase.Refresh();
        }

        if (GUILayout.Button("自动填写(所有选中的)"))
        {//选中了对应的所有文件夹，分别进行生成。
            int startIndex = count;
            for (int i = 0; i < Selection.objects.Length; i++)
            {
                AddItem();
                AutoFill(startIndex, Selection.objects[i]);
                startIndex++;
            }
        }
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.LabelField("注意：必须以文件夹为单位进行选择！文件夹名即为包名。纹理资源目录加_asset区分！！");

        scrollValue = EditorGUILayout.BeginScrollView(scrollValue);

        for (int i = 0; i < count; i++)
        {
            //EditorGUILayout.BeginVertical();
            EditorGUILayout.BeginHorizontal();
            //控制宽度
            //EditorGUILayout.LabelField(i.ToString() + "AB包名");
            GUILayout.Label(i.ToString("d3") + "AB包名");
            //tempStyle.fixedWidth = 50;
            //tempStyle.stretchWidth = true;
            //填写
            //bundleNameList[i] = EditorGUILayout.TextField("", bundleNameList[i]);
            bundleNameList[i] = GUILayout.TextField(bundleNameList[i], GUILayout.Width(200));
            //suffixList[i] = (SuffixEnum)EditorGUILayout.EnumPopup("类型", suffixList[i]);// GUILayout.Width(150), GUILayout.ExpandWidth(true));
            GUILayout.Label("类型");
            suffixList[i] = (SuffixEnum)EditorGUILayout.EnumPopup(suffixList[i]);// GUILayout.Width(150), GUILayout.ExpandWidth(true));
            GUILayout.Label("路径");
            //pathList[i] = EditorGUILayout.TextField("", pathList[i]);
            pathList[i] = EditorGUILayout.TextField(pathList[i], GUILayout.Width(300));
            if (GUILayout.Button("自动填写(单个)"))
            {
                AutoFill(i, Selection.objects[0]);
            }
            if (GUILayout.Button("输出路径"))
            {
                Debug.Log(pathList[i]);
            }
            if (GUILayout.Button("删除该项"))
            {
                RemoveItem(i);
            }
            EditorGUILayout.EndHorizontal();
            //EditorGUILayout.EndVertical();
        }
        EditorGUILayout.EndScrollView();
    }

    void Clear()
    {
        count = 0;
        bundleNameList = new List<string>();
        suffixList = new List<SuffixEnum>();
        pathList = new List<string>();
    }

    void AddItem(string bundleName = "", SuffixEnum suffix = SuffixEnum.Prefab, string path = "")
    {
        count++;
        bundleNameList.Add(bundleName);
        suffixList.Add(suffix);
        pathList.Add(path);
    }

    void RemoveItem(int index)
    {
        count--;
        bundleNameList.Remove(bundleNameList[index]);
        suffixList.Remove(suffixList[index]);
        pathList.Remove(pathList[index]);
    }

    void AutoFill(int index, Object selectedObject)
    {
        string path = AssetDatabase.GetAssetPath(selectedObject);
        bundleNameList[index] = path.Remove(0, path.LastIndexOf("/") + 1).ToLower() + LuaFramework.AppConst.ExtName;

        string[] files = Directory.GetFiles(path);
        string[] temp = files[0].Split('.');
        suffixList[index] = StringToEnum("*." + temp[1]);

        pathList[index] = path;
    }

    public static string EnumToString(SuffixEnum se)
    {
        switch (se)
        {
            case SuffixEnum.Prefab:
                return "*.prefab";
            case SuffixEnum.Png:
                return "*.png";
            case SuffixEnum.Csv:
                return "*.csv";
            case SuffixEnum.Txt:
                return "*.txt";
            default:
                return "null";
        }
    }

    public static SuffixEnum StringToEnum(string s)
    {
        switch (s)
        {
            case "*.prefab":
                return SuffixEnum.Prefab;
            case "*.png":
                return SuffixEnum.Png;
            case "*.csv":
                return SuffixEnum.Csv;
            case "*.txt":
                return SuffixEnum.Txt;
            default:
                return SuffixEnum.Prefab;
        }
    }

}