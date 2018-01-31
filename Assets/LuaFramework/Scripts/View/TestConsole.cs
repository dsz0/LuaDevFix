/**
 * Copyright (c) 2018,广州Indra软件有限公司
 * All rights reserved.
 * 文件名称：TestConsole.cs
 * 简    述：[使用情形]在设备上直接查看Log各种输出，主要方便lua调试。
 * [使用方法]：场景中选一个指定的GameObject挂上即可。上面有几个按钮，清理log,关闭界面，折叠相同的输出。
 * 关闭console之后，在手机上摇动可以让console重新显示。在电脑上点击指定按键即可（默认：KeyCode.BackQuote）。
 * 创建标识：Lorry 2018/1/26
 **/
#define USE_TESTCONSOLE  
using System.Collections.Generic;
using UnityEngine;
using System.IO;

namespace Consolation
{
    /// <summary>  
    /// 用于在游戏中显示Unity's debug logs的Console  
    /// </summary>  
    class TestConsole : MonoBehaviour
    {
#if USE_TESTCONSOLE
        struct Log
        {
            public string message;
            public string stackTrace;
            public LogType type;
        }

        #region Inspector Settings  

        /// <summary>  
        /// The hotkey to show and hide the console window.  
        /// </summary>  
        public KeyCode toggleKey = KeyCode.BackQuote;

        /// <summary>  
        /// Whether to open the window by shaking the device (mobile-only).  
        /// </summary>  
        public bool shakeToOpen = true;

        /// <summary>  
        /// The (squared) acceleration above which the window should open.  
        /// </summary>  
        public float shakeAcceleration = 3f;

        /// <summary>  
        /// 是否只保存特定数量的logs.  
        /// 主要是保存太多内存使用量太大，也不便于我们在Console上查找log。  
        /// </summary>  
        public bool restrictLogCount = true;

        /// <summary>  
        /// 最大保存log数量  
        /// </summary>  
        public int maxLogs = 1000;

        #endregion

        readonly List<Log> logs = new List<Log>();
        Vector2 scrollPosition;
        bool visible = false;
        bool collapse;

        // Visual elements:  

        static readonly Dictionary<LogType, Color> logTypeColors = new Dictionary<LogType, Color>
            {
                { LogType.Assert, Color.white },
                { LogType.Error, Color.red },
                { LogType.Exception, Color.red },
                { LogType.Log, Color.white },
                { LogType.Warning, Color.yellow },
            };

        const string windowTitle = "Console";
        const int margin = 30;
        static readonly GUIContent clearLabel = new GUIContent("Clear", "Clear the contents of the console.");
        static readonly GUIContent delLabel = new GUIContent("DelContent", "Delete UpdateContent.");

        static readonly GUIContent closeLabel = new GUIContent("Close", "Close TestConsole.");

        static readonly GUIContent collapseLabel = new GUIContent("Collapse", "Hide repeated messages.");

        readonly Rect titleBarRect = new Rect(0, 0, 10000, 30);
        Rect windowRect = new Rect(margin, margin, Screen.width - (margin * 2), Screen.height - (margin * 2));

        void OnEnable()
        {
#if UNITY_5
            Application.logMessageReceived += HandleLog;
#else
                Application.RegisterLogCallback(HandleLog);  
#endif
        }

        void OnDisable()
        {
#if UNITY_5
            Application.logMessageReceived -= HandleLog;
#else
                Application.RegisterLogCallback(null);  
#endif
        }

        void Update()
        {
            if (Input.GetKeyDown(toggleKey))
            {
                visible = !visible;
            }

            if (shakeToOpen && Input.acceleration.sqrMagnitude > shakeAcceleration)
            {
                visible = true;
            }
        }

        void OnGUI()
        {
            if (!visible)
            {
                return;
            }

            windowRect = GUILayout.Window(123456, windowRect, DrawConsoleWindow, windowTitle);
        }

        /// <summary>  
        /// Displays a window that lists the recorded logs.  
        /// </summary>  
        /// <param name="windowID">Window ID.</param>  
        void DrawConsoleWindow(int windowID)
        {
            DrawLogsList();
            DrawToolbar();

            // Allow the window to be dragged by its title bar.  
            GUI.DragWindow(titleBarRect);
        }

        /// <summary>  
        /// Displays a scrollable list of logs.  
        /// </summary>  
        void DrawLogsList()
        {
            scrollPosition = GUILayout.BeginScrollView(scrollPosition);
            GUIStyle _tempStyle = new GUIStyle(); 
            // Iterate through the recorded logs.  
            for (var i = 0; i < logs.Count; i++)
            {
                var log = logs[i];

                // Combine identical messages if collapse option is chosen.  
                if (collapse && i > 0)
                {
                    var previousMessage = logs[i - 1].message;

                    if (log.message == previousMessage)
                    {
                        continue;
                    }
                }
                _tempStyle.normal.textColor = logTypeColors[log.type];
                _tempStyle.fontSize = 25;
                //GUI.contentColor = logTypeColors[log.type];
                GUILayout.Label(log.message,_tempStyle);
            }

            GUILayout.EndScrollView();

            // Ensure GUI colour is reset before drawing other components.  
            GUI.contentColor = Color.white;
        }

        /// <summary>  
        /// Displays options for filtering and changing the logs list.  
        /// </summary>  
        void DrawToolbar()
        {
            GUILayout.BeginHorizontal();

            if (GUILayout.Button(clearLabel))
            {
                logs.Clear();
            }

            if (GUILayout.Button(delLabel))
            {
                string dataPath = LuaFramework.Util.DataPath;
                if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
            }


            if (GUILayout.Button(closeLabel))
            {
                visible = false;
            }

            collapse = GUILayout.Toggle(collapse, collapseLabel, GUILayout.ExpandWidth(false));

            GUILayout.EndHorizontal();
        }

        /// <summary>  
        /// Records a log from the log callback.  
        /// </summary>  
        /// <param name="message">Message.</param>  
        /// <param name="stackTrace">Trace of where the message came from.</param>  
        /// <param name="type">Type of message (error, exception, warning, assert).</param>  
        void HandleLog(string message, string stackTrace, LogType type)
        {
            logs.Add(new Log
            {
                message = message,
                stackTrace = stackTrace,
                type = type,
            });

            TrimExcessLogs();
        }

        /// <summary>  
        /// Removes old logs that exceed the maximum number allowed.  
        /// </summary>  
        void TrimExcessLogs()
        {
            if (!restrictLogCount)
            {
                return;
            }

            var amountToRemove = Mathf.Max(logs.Count - maxLogs, 0);

            if (amountToRemove == 0)
            {
                return;
            }

            logs.RemoveRange(0, amountToRemove);
        }
#endif
    }
}