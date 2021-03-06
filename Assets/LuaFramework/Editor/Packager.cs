﻿/**
 * 文件名称：Packager.cs
 * 简    述：生成指定设备的StreamAsset,注意在BuildSetting中切换对应的平台。
 * 使用方法：在编辑器Editor的,LuaRaziel菜单下点击对应运行平台构建资源即可。
 * 结束会输出"Build Res Finish!!"
 * 创建标识：Lorry 2018/1/26
 * 修改标识：打包可以指定打包根目录，在Files.txt中添加版本号。Lorry 2018/2/08
 **/
using UnityEditor;
using UnityEngine;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using LuaFramework;

public class Packager
{
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();
    ///-----------------------------------------------------------
    static string[] exts = { ".txt", ".xml", ".lua", ".assetbundle", ".json" };
    static bool CanCopy(string ext)
    {   //能不能复制
        foreach (string e in exts)
        {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    const string kDebugMode = "LuaRaziel/DebugMode";

    [MenuItem(kDebugMode,false,11)]
    public static void ToggleSimulationMode()
    {
        EditorUtil.DevelopMode = !EditorUtil.DevelopMode;
    }

    [MenuItem(kDebugMode, true, 11)]
    public static bool ToggleSimulationModeValidate()
    {
        Menu.SetChecked(kDebugMode, EditorUtil.DevelopMode);
        return true;
    }

//    [MenuItem("LuaRaziel/Build iPhone Resource", false, 100)]
//    public static void BuildiPhoneResource()
//    {
//        BuildTarget target;
//#if UNITY_5
//        target = BuildTarget.iOS;
//#else
//        target = BuildTarget.iPhone;
//#endif
//        BuildAssetResource(target);
//    }

//    [MenuItem("LuaRaziel/Build Android Resource", false, 101)]
//    public static void BuildAndroidResource()
//    {
//        BuildAssetResource(BuildTarget.Android);
//    }

//    [MenuItem("LuaRaziel/Build Windows Resource", false, 102)]
//    public static void BuildWindowsResource()
//    {
//        BuildAssetResource(BuildTarget.StandaloneWindows);
//    }

    /// <summary>
    /// 生成更新包的资源（素材）
    /// </summary>
    /// <param name="pResPath">当前打包资源的路径</param>
    public static bool BuildAssetResource(BuildTarget target, string pResPath = null)
    {
#if UNITY_EDITOR
        if (EditorUtil.DevelopMode)
        {
            if (EditorUtility.DisplayDialog("提示", "处于DebugMode不用打包也能运行！", "取消打包", "继续打包"))
            {
                return false;
            }
        }
#endif
        if (pResPath == null)
            pResPath = Application.dataPath.Replace("Assets", EditorUtil.BundlePath) + "/";

        UnityEngine.Debug.LogError("Build Res Start>>>" + System.DateTime.Now.ToString());

        if (Directory.Exists(pResPath))
        {//如果版本数据存放目录存在，先删除，莫名其妙的版本资源错误。
            Directory.Delete(pResPath, true);
            UnityEngine.Debug.LogWarning("Delete 目标 ResPath>>>" + pResPath);
        }
        //string streamPath = Application.streamingAssetsPath;
        //if (Directory.Exists(streamPath))
        //{//如果游戏包资源目录存在，也先删除(因为两次很可能是打包不同平台的资源，不删除也可能会出问题)
        //    Directory.Delete(streamPath, true);
        //}
        //Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh();
        //清理Assetbundle列表,待填充。
        maps.Clear();

#pragma warning disable 0162
        //打包lua代码
        if (AppConst.LuaBundleMode)
        {
            HandleLuaBundle(pResPath);
        }
        else
        {
            HandleLuaFile(pResPath);
        }
#pragma warning restore 0162
        //if (AppConst.ExampleMode)
        //{//打包例子的资源
        //    HandleExampleBundle();
        //}
        HandleCsvBundle();
        try
        {
            //string resPath = "Assets/" + AppConst.AssetDir;
            BuildPipeline.BuildAssetBundles(pResPath, maps.ToArray(), BuildAssetBundleOptions.None, target);
            //resPath = AppDataPath + "/" + AppConst.AssetDir + "/";
        }catch(System.Exception e)
        {
            UnityEngine.Debug.LogError(e.Message + "| Delete OutputPath:" + pResPath);
            Directory.Delete(pResPath, true);
            return false;
        }
        BuildFileIndex(pResPath);
        //打包完成了，干掉打包lua代码时生成的临时目录
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir))
        {
            UnityEngine.Debug.LogWarning("打包结束，删除临时目录：" + streamDir);
            Directory.Delete(streamDir, true);
        }
        AssetDatabase.Refresh();
        UnityEngine.Debug.LogError("Build Finish>>>" + pResPath +"|" + System.DateTime.Now.ToString());
        return true;
    }
    /// <summary>
    /// 将指定目录下所有对应扩展名的对象，打包到bundleName命名的AssetBundle包中。
    /// </summary>
    /// <param name="bundleName">包名</param>
    /// <param name="pattern">需要打包的类型文件格式</param>
    /// <param name="path">需要打包的目录</param>
    static void AddBuildMap(string bundleName, string pattern, string path)
    {
        string[] files = Directory.GetFiles(path, pattern);
        if (files.Length == 0) return;

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName;
        build.assetNames = files;
        maps.Add(build);
    }

    /// <summary>
    /// 处理Lua代码包
    /// </summary>
    static void HandleLuaBundle(string pNowResPath)
    {
        //首先创建临时目录，准备进行lua文件的处理。
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);
        UnityEngine.Debug.LogWarning("开始打包Lua,创建临时目录：" + streamDir);
        //首先将lua文件全部拷贝到临时目录中
        string[] srcDirs = { CustomSettings.luaDir, CustomSettings.toluaLuaDir };
        for (int i = 0; i < srcDirs.Length; i++)
        {
#pragma warning disable 0162
            if (AppConst.LuaByteMode)
            {
                string sourceDir = srcDirs[i];
                string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
                int len = sourceDir.Length;

                if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\')
                {
                    --len;
                }
                for (int j = 0; j < files.Length; j++)
                {
                    string str = files[j].Remove(0, len);
                    string dest = streamDir + str + ".bytes";
                    string dir = Path.GetDirectoryName(dest);
                    Directory.CreateDirectory(dir);
                    EncodeLuaFile(files[j], dest);
                }
            }
            else
            {
                ToLuaMenu.CopyLuaBytesFiles(srcDirs[i], streamDir);
            }
#pragma warning restore 0162
        }
        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++)
        {
            string name = dirs[i].Replace(streamDir, string.Empty);
            name = name.Replace('\\', '_').Replace('/', '_');
            name = "lua/lua_" + name.ToLower() + AppConst.ExtName;

            string path = "Assets" + dirs[i].Replace(Application.dataPath, "");
            AddBuildMap(name, "*.bytes", path);
        }//for循环中处理完所有子目录中的lua文件打包.下面把根目录的lua文件都打包到lua.unity3d文件中
        AddBuildMap("lua/lua" + AppConst.ExtName, "*.bytes", "Assets/" + AppConst.LuaTempDir);

        //-------------------------------处理非Lua文件----------------------------------
        string luaPath = pNowResPath + "/lua/";//AppDataPath + "/StreamingAssets/lua/";
        for (int i = 0; i < srcDirs.Length; i++)
        {
            paths.Clear(); files.Clear();
            string luaDataPath = srcDirs[i].ToLower();
            Recursive(luaDataPath);
            foreach (string f in files)
            {
                if (f.EndsWith(".meta") || f.EndsWith(".lua")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string path = Path.GetDirectoryName(luaPath + newfile);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                //先拷贝lua相关目录下非Lua文件到StreamingAssets/lua/文件夹
                string destfile = path + "/" + Path.GetFileName(f);
                File.Copy(f, destfile, true);
            }
        }
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 处理框架范例包，这是luaFrameWork的原始例子打包代码。现在已经不再使用。
    /// 请注意这里的打包粒度，下面的prompt_asset即使不单独打包，也没有问题。但是包的粒度会变大。
    /// 不利于内存管理和资源共用，还有可能出现重复打包的资源。
    /// </summary>
    static void HandleExampleBundle(string pNowResPath)
    {
        string resPath = pNowResPath;// AppDataPath + "/" + AppConst.AssetDir + "/";
        if (!Directory.Exists(resPath)) Directory.CreateDirectory(resPath);

        AddBuildMap("prompt" + AppConst.ExtName, "*.prefab", "Assets/LuaFramework/Examples/Builds/Prompt");
        AddBuildMap("message" + AppConst.ExtName, "*.prefab", "Assets/LuaFramework/Examples/Builds/Message");

        AddBuildMap("prompt_asset" + AppConst.ExtName, "*.png", "Assets/LuaFramework/Examples/Textures/Prompt");
        AddBuildMap("shared_asset" + AppConst.ExtName, "*.png", "Assets/LuaFramework/Examples/Textures/Shared");
    }

    /// <summary>
    /// 通过AddBuildMapUtil生成csv文件，来对资源进行打包。实际流程和上面也差不多。
    /// </summary>
    static void HandleCsvBundle()
    {
        string content = File.ReadAllText(Application.dataPath + "/" + AppConst.AppName + "/" + "HotRes" + "/AssetBundleInfo.csv");
        string[] contents = content.Split(new string[] { "\r\n" }, System.StringSplitOptions.RemoveEmptyEntries);
        for (int i = 0; i < contents.Length; i++)
        {
            string[] a = contents[i].Split(',');
            UnityEngine.Debug.Log("AddBundle：" + a[0] +"; " + a[1] + "; " + a[2]);  
            AddBuildMap(a[0], a[1], a[2]);
        }
    }

    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile(string pNowResPath)
    {
        //string resPath = AppDataPath + "/StreamingAssets/";
        string luaPath = pNowResPath + "/lua/";

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath))
        {
            Directory.CreateDirectory(luaPath);
        }
        //string[] luaPaths = { AppDataPath + "/LuaFramework/lua/",
        //                      AppDataPath + "/LuaFramework/Tolua/Lua/" };
        string[] luaPaths = { CustomSettings.luaDir,
                               CustomSettings.toluaLuaDir };

        for (int i = 0; i < luaPaths.Length; i++)
        {
            paths.Clear(); files.Clear();
            string luaDataPath = luaPaths[i].ToLower();
            Recursive(luaDataPath);
            int n = 0;
            foreach (string f in files)
            {
                if (f.EndsWith(".meta")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string newpath = luaPath + newfile;
                string path = Path.GetDirectoryName(newpath);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                if (File.Exists(newpath))
                {
                    File.Delete(newpath);
                }
#pragma warning disable 0162
                if (AppConst.LuaByteMode)
                {
                    EncodeLuaFile(f, newpath);
                }
                else
                {
                    File.Copy(f, newpath, true);
                }
#pragma warning restore 0162
                UpdateProgress(n++, files.Count, newpath);
            }
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 制作好的assetbundle目录创建文件索引，用于游戏更新时进行对比。
    /// </summary>
    static void BuildFileIndex(string resPath)
    {
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        paths.Clear(); files.Clear();
        Recursive(resPath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        sw.WriteLine(EditorUtil.luaPackVersion);
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            //string ext = Path.GetExtension(file);
            if (file.EndsWith(".meta") || file.Contains(".DS_Store") || file.EndsWith(".manifest")) continue;
            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            #region 增加读取文件大小的代码Lorry
            FileInfo fileInfo = null;
            try
            {
                fileInfo = new FileInfo(file);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                // 其他处理异常的代码
            }
            #endregion 
            sw.WriteLine(value + "|" + md5 +"|"+ fileInfo.Length);
        }
        sw.Close(); fs.Close();
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath
    {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
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

    static void UpdateProgress(int progress, int progressMax, string desc)
    {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    public static void EncodeLuaFile(string srcFile, string outFile)
    {
        if (!srcFile.ToLower().EndsWith(".lua"))
        {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true;
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor)
        {
            isWin = true;
            luaexe = "luajit.exe";
            args = "-b -g " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        }
        else if (Application.platform == RuntimePlatform.OSXEditor)
        {
            isWin = false;
            luaexe = "./luajit";
            args = "-b -g " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit_mac/";
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.UseShellExecute = isWin;
        info.ErrorDialog = true;
        Util.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }

    [MenuItem("LuaRaziel/Build Protobuf-lua-gen File(暂缓)")]
    public static void BuildProtobufFile()
    {
        if (!AppConst.ExampleMode)
        {
            UnityEngine.Debug.LogError("若使用编码Protobuf-lua-gen功能，需要自己配置外部环境！！");
            return;
        }
        string dir = AppDataPath + "/Lua/3rd/pblua";
        paths.Clear(); files.Clear(); Recursive(dir);

        string protoc = "d:/protobuf-2.4.1/src/protoc.exe";
        string protoc_gen_dir = "\"d:/protoc-gen-lua/plugin/protoc-gen-lua.bat\"";

        foreach (string f in files)
        {
            string name = Path.GetFileName(f);
            string ext = Path.GetExtension(f);
            if (!ext.Equals(".proto")) continue;

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = protoc;
            info.Arguments = " --lua_out=./ --plugin=protoc-gen-lua=" + protoc_gen_dir + " " + name;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = true;
            info.WorkingDirectory = dir;
            info.ErrorDialog = true;
            Util.Log(info.FileName + " " + info.Arguments);

            Process pro = Process.Start(info);
            pro.WaitForExit();
        }
        AssetDatabase.Refresh();
    }
}