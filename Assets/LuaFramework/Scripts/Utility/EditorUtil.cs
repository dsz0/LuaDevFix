/**
 * 文件名称：EditorUtil.cs
 * 简    述：只在编辑器中需要的方便函数。
 * 现主要功能有
 * 1.开发模式的设置，
 * 2.各种打包路径的方便函数
 * 3.开发模式中模拟载入打包资源函数
 * 创建标识：Lorry 2018/1/26
 **/
using UnityEngine;
using System;
using System.IO;
using System.Collections.Generic;
using LuaInterface;
#if UNITY_EDITOR
using UnityEditor;
using UObject = UnityEngine.Object;
#endif
namespace LuaFramework
{

    public class EditorUtil 
    {

#if UNITY_EDITOR
        static int m_SimulateABInEditor = -1;
        const string k_SimulateInDevelop = "k_SimulateInDevelop";
        //开发模式-主要是为了编辑器开发调试(在没有真正打包时，模拟assetBundles的效果)。
        public static bool DevelopMode
        {
            get
            {
                if (m_SimulateABInEditor == -1)
                    m_SimulateABInEditor = EditorPrefs.GetBool(k_SimulateInDevelop, true) ? 1 : 0;

                return m_SimulateABInEditor != 0;
            }
            set
            {
                int newValue = value ? 1 : 0;
                if (newValue != m_SimulateABInEditor)
                {
                    m_SimulateABInEditor = newValue;
                    EditorPrefs.SetBool(k_SimulateInDevelop, value);
                }
            }
        }

        public const string AssetBundlesOutputPath = "ABHotFix";
        /// <summary>
        /// 打包的次数
        /// </summary>
        static int m_BuildBundleTimes = -1;
        const string k_BuildBundleTimes = "k_BuildBundleTimes";
        public static string luaPackVersion
        {
            get
            {
                return AppConst.Version + "." + BundleTime;
            }
        } 

        public static string  BundlePath
        {
            get
            {
                string path = Path.Combine(luaPackVersion, Util.GetPlatformName());
                return Path.Combine(AssetBundlesOutputPath, path);
            }
        }

        public static int BundleTime
        {
            get
            {
                if (m_BuildBundleTimes == -1)
                    m_BuildBundleTimes = EditorPrefs.GetInt(k_BuildBundleTimes, 0);
                return m_BuildBundleTimes;
            }
            set
            {
                m_BuildBundleTimes = value;
                EditorPrefs.SetInt(k_BuildBundleTimes, m_BuildBundleTimes);
            }
        }

        private static string HotResPath = "Assets/" + AppConst.AppName + "/HotRes/Builds/";
        /// <summary>
        /// 用于在Editor中处理模拟运行时的资源加载。
        /// </summary>
        public static void LoadAssetInEditor(string abName, string[] assetNames, Action<UObject[]> action, LuaFunction func)
        {
            //string assetName = assetNames[0];
            //string[] assetPaths = AssetDatabase.GetAssetPathsFromAssetBundleAndAssetName(abName, assetName);
            //Debug.Log("Editor LoadMainAssetAtPath:" + assetPaths[0]);
            //if (assetPaths.Length == 0)
            //{
            //    Debug.LogError("There is no asset with name \"" + assetName + "\" in " + abName);
            //}

            //按照打包的方法，这里应该提供更多的测试和实验来寻找HotRes目录下各个子目录的资源,并且适配.prefab和png等文件。
            //但是现在暂时没有时间写的那么有弹性，先快速实现一下，再根据需求来做细节。
            List<UObject> result = new List<UObject>();
            for (int i = 0; i < assetNames.Length; i++)
            {
                string assetPath = HotResPath + abName + "/" + assetNames[i] + ".prefab";
                UObject target = AssetDatabase.LoadMainAssetAtPath(assetPath);
                if (target == null)
                    Debug.LogError("LoadMainAssetAtPath失败:" + assetPath + "资源不存在？");
                result.Add(target);
            }
            if (action != null)
            {
                action(result.ToArray());
            }
            if (func != null)
            {
                func.Call((object)result.ToArray());
                func.Dispose();
            }
        }

#endif
    }
}
