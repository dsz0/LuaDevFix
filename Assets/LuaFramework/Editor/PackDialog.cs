/**
 * Copyright (c) 2018
 * All rights reserved.
 * 文件名称：PackDialog.cs
 * 简述：打包界面，可以显示热更新包的版本，及打包目录。开发打包点击最上按钮，版本验证后，可点击下方的按钮进行不同平台打包动作。
 * 创建标识：Lorry 2018/02/07
 */
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using LuaFramework;
public class PackDialog : EditorWindow
{

    [MenuItem("LuaRaziel/版本打包面板", false, 98)]
    public static void Init()
    {
        EditorWindow.GetWindow(typeof(PackDialog));
    }
    //pathBuildTo = EditorUtility.OpenFolderPanel("选择你想拷贝到的目录", pathBuildTo, "LuaRaz");
    string m_JustBundlePath = null;
    string m_Platform;
    private string pathToStoreAB = "C:/HotFix/Res";

    private void OnGUI()
    {
        GUILayout.Label("新包路径："+ Application.dataPath.Replace("Assets", EditorUtil.AssetBundlesOutputPath));
        if (GUILayout.Button("Build新包" + Util.GetPlatformName()))
        {
            EditorUtil.BundleTime += 1;
            string temp = Application.dataPath.Replace("Assets", EditorUtil.BundlePath);
            temp = temp.Replace("\\", "/");
            if (Packager.BuildAssetResource(EditorUserBuildSettings.activeBuildTarget, temp))
            {
                m_JustBundlePath = temp;
            }
        }
        GUILayout.Label("现在打包版本为当前Editor设置的平台");
        GUILayout.Label("注意，上面按钮打包会自动更新当前的小版本号！！");
        if (GUILayout.Button("还原当Version号"))
        {
            EditorUtil.BundleTime = 0;
        }
        GUILayout.Label("刚打包的目录：" + m_JustBundlePath);
        GUILayout.Label("游戏包资源目录：" + Application.streamingAssetsPath);
        if (GUILayout.Button("清理StreamingAssets并向其拷贝刚打包资源"))
        {
            if (m_JustBundlePath != null)
            {
                CopyDir(m_JustBundlePath, Application.streamingAssetsPath);
            }
            else
            {
                EditorUtility.DisplayDialog("提示", "还未进行打包！", "开始打包", "取消拷贝");
            }
        }
        GUILayout.Label("下面按钮会打包到路径：" + pathToStoreAB);
        GUILayout.Label("当前Lua包版本号：" + EditorUtil.luaPackVersion);
        if (GUILayout.Button("选择打包目录"))
        {
            pathToStoreAB = EditorUtility.OpenFolderPanel("选择你想拷贝到的目录", pathToStoreAB, "");
        }
        if (GUILayout.Button("Build iPhone Resource"))
        {
            BuildTarget target;
#if UNITY_5
            target = BuildTarget.iOS;
#else
        target = BuildTarget.iPhone;

#endif
            string path = pathToStoreAB + "/" + EditorUtil.luaPackVersion + "/iOS";
            Packager.BuildAssetResource(target, path);
        }
        if (GUILayout.Button("Build Android Resource"))
        {
            string path = pathToStoreAB + "/" + EditorUtil.luaPackVersion + "/Android";
            Packager.BuildAssetResource(BuildTarget.Android, path);
        }
        if (GUILayout.Button("Build Windows Resource"))
        {
            string path = pathToStoreAB + "/" + EditorUtil.luaPackVersion + "/Windows";
            Packager.BuildAssetResource(BuildTarget.StandaloneWindows, path);
        }
    }

    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    /// <summary>
    /// 遍历目录及其子目录,存到files和paths两个成员变量中(剔除.meta文件)
    /// </summary>
    static void Recursive(string path)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }
    /// <summary>
    /// 拷贝文件夹,配有Editor的进度条显示。
    /// </summary>
    public static void CopyDir(string sourceDir, string destDir)
    {
        paths.Clear(); files.Clear();
        if (!Directory.Exists(sourceDir))
        {
            return;
        }

        if (Directory.Exists(destDir))
        {
            Debug.LogWarning("删除Streaming目录：" + destDir);
            Directory.Delete(destDir,true);
        }
        Recursive(sourceDir);
        int len = sourceDir.Length;
        if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\')
        {
            --len;
        }
        for (int i = 0; i < files.Count; i++)
        {
            string str = files[i].Remove(0, len);
            string dest = destDir + "/" + str;
            string dir = Path.GetDirectoryName(dest);
            Directory.CreateDirectory(dir);
            File.Copy(files[i], dest, true);
        }
        Debug.LogWarning("拷贝完毕："+ sourceDir + "|To|" +destDir);
    }
}
