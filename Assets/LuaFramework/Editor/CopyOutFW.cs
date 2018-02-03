/**
 * Copyright (c) 2018
 * All rights reserved.
 * 文件名称：CopyOutFW.cs
 * 简述：将代码自动拷贝一份为LuaRaz,可以方便的插入游戏框架中。
 * 创建标识：Lorry 2018/02/03
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using LuaFramework;

public class CopyOutFW : EditorWindow
{
    List<string> paths = new List<string>();
    List<string> files = new List<string>();
    /// <summary>
    /// 框架存储路径
    /// </summary>
    private string pathToStoreFramework = "C:/HotFix/LuaRaz";
    //private string pathToStoreHotFix = "c:/LuaRazHotFix";

    static string[] exts = { ".txt", ".xml", ".lua", ".csv", ".json" };
    static bool CanCopy(string ext)
    {   //能不能复制
        foreach (string e in exts)
        {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    [MenuItem("LuaRaziel/CopyOutFrameWork", false, 10)]
    public static void CopyOutFrameWork()
    {
        EditorWindow.GetWindow(typeof(CopyOutFW));
    }
    /// <summary>
    /// 检查拷贝环境
    /// </summary>
    private void checkPath()
    {
        if (string.IsNullOrEmpty(pathToStoreFramework))
        {
            pathToStoreFramework = "c:/HotFix/LuaRaz";
        }
        if (!Directory.Exists(pathToStoreFramework))
        {
            Debug.LogWarning("创建框架目录:" + pathToStoreFramework);
            Directory.CreateDirectory(pathToStoreFramework);
        }
    }

    void OnGUI()
    {
        GUILayout.Label("目标路径(CopyTo)：" + pathToStoreFramework);
        if (GUILayout.Button("选择目录(CopyTo)"))
        {
            pathToStoreFramework = EditorUtility.OpenFolderPanel("选择你想拷贝到的目录", pathToStoreFramework, "LuaRaz");
        }
        GUILayout.Label("一般不用选择路径，本地实验完毕直接点目标路径(CopyTo)：" + pathToStoreFramework);
        if (GUILayout.Button("拷贝Frame"))
        {
            checkPath();
            CopyFrame();
        }

        if (GUILayout.Button("拷贝热更资源"))
        {
            checkPath();
            CopyHotFix();
        }
    }

    string basePath { get { return Application.dataPath + "/" + AppConst.AppName + "/"; } } 
    /// <summary>
    /// 将
    /// </summary>
    void CopyFrame()
    {
        string destPath = this.pathToStoreFramework + "/";  //目标路径

        //string editorPath = basePath + "Editor/";   //在develop版本不打包不用拷贝
        //string luajitPath = basePath + "Luajit/";   //在develop版本不打包这个也不用拷贝

        //string resourcesPath = basePath + "Resources/"; //暂无有用资源可以忽略
        //string scenesPath = basePath + "Scenes/";   //这个暂时只用于测试可不拷贝

        string scriptsPath = basePath + "Scripts/"; //
        string toLuaPath = basePath + "ToLua/";     //基本不会变除非Tolua升级

        string[] FrameworkPaths = { scriptsPath,
            //editorPath,luajitPath,
            //resourcesPath,scenesPath,
                               toLuaPath };
        for (int n = 0; n < FrameworkPaths.Length; n++)
        {
            paths.Clear(); files.Clear();
            string HotFixPath = FrameworkPaths[n];//.ToLower();
            Recursive(HotFixPath);
            for (int i = 0; i < files.Count; i++)
            {
                string newfile;
                string newpath;
                if (files[i].Contains("AppConst.cs"))
                {
                    Debug.LogWarning("特殊处理AppConst.cs:" + files[i]);
                    newfile = files[i].Substring(files[i].LastIndexOf("/")+1);
                    newpath = destPath + newfile;
                    if (File.Exists(newpath)) File.Delete(newpath);

                    //string[] codelines = File.ReadAllLines(files[i]);
                    //FileStream fs = new FileStream(newpath, FileMode.CreateNew);
                    //StreamWriter sw = new StreamWriter(fs);
                    //for (int j = 0; j < codelines.Length; j++)
                    //{
                    //    string codeline = codelines[j];
                    //    //string ext = Path.GetExtension(file);
                    //    if(codeline.Contains("\"LuaFramework\""))
                    //    {
                    //        codeline = codeline.Replace("LuaFramework", "LuaRaz");
                    //        Debug.LogWarning(newfile + ":LuaRaz 已替换 ");
                    //    }
                    //    sw.WriteLine(codeline);
                    //}
                    //sw.Close(); fs.Close();
                    string codes = File.ReadAllText(files[i]);
                    codes = codes.Replace("\"LuaFramework\"", "\"LuaRaz\"");
                    File.WriteAllText(newpath, codes);
                }
                else
                {
                    newfile = files[i].Replace(basePath, "");
                    newpath = destPath + newfile;
                    //Debug.Log("Try Copy:" + files[i] + "[to]" + newpath);
                    string path = Path.GetDirectoryName(newpath);
                    if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    File.Copy(files[i], newpath, true);
                }
                UpdateProgress(i, files.Count, newpath);
            }
        }

        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
        Debug.LogWarning("热更框架拷贝完毕：>>>" + pathToStoreFramework + "<<<");
    }

    /// <summary>
    /// 拷贝Assets下 HotRes和
    /// </summary>
    void CopyHotFix()
    {
        string destPath = this.pathToStoreFramework + "/";  //目标路径
        //if (Directory.Exists(destPath)) Directory.Delete(destPath, true);
        //Directory.CreateDirectory(destPath);
        //屏蔽删除，主要是考虑develop下的目录，不删老文件，免得meta文件出错。
        string luaPath = basePath + "Lua/";
        string ResPath = basePath + "HotRes/";
        //Debug.Log(luaPath + "|" + ResPath);
        string[] HotFixPaths = { luaPath,
                               ResPath };
        for(int n = 0; n< HotFixPaths.Length; n++)
        {
            paths.Clear(); files.Clear();
            string HotFixPath = HotFixPaths[n];//.ToLower();
            Recursive(HotFixPath);
            for (int i = 0; i < files.Count; i++)
            {
                //if (files[i].EndsWith(".meta")) continue;
                string newfile = files[i].Replace(basePath, "");
                string newpath = destPath + newfile;
                //Debug.Log("Try Copy:" + files[i] + "[to]" + newpath);
                string path = Path.GetDirectoryName(newpath);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                File.Copy(files[i], newpath, true);
                UpdateProgress(i, files.Count, newpath);
            }
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
        Debug.LogWarning("热更资源拷贝完毕：>>>" + pathToStoreFramework +"<<<");
    }

    /// <summary>
    /// 遍历目录及其子目录,存到files和paths两个成员变量中(剔除.meta文件)
    /// </summary>
    void Recursive(string path)
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
    /// 显示拷贝进度条
    /// </summary>
    static void UpdateProgress(int progress, int progressMax, string desc)
    {
        string title = "拷贝中Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }


}
