using UnityEngine;
using UnityEditor;
using NUnit.Framework;

/////////////////////////////////////////////////////////////////////////////  
//查找Missing的脚本，选中Hierarchy中对象，点击button，会输出到Console中进行显示
/////////////////////////////////////////////////////////////////////////////
public class FindMissingScriptRec : EditorWindow
{
    static int go_count = 0, components_count = 0, missing_count = 0;

    [MenuItem("LuaRaziel/Tools/遍历查找MissingScripts",false, 200)]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(FindMissingScriptRec));
    }

    public void OnGUI()
    {
        GUILayout.Label("请先选中1~n个GameObjects");
        if (GUILayout.Button("Start Find Missing Scripts"))
        {
            FindInSelected();
        }
    }

    private static void FindInSelected()
    {
        GameObject[] go = Selection.gameObjects;
        go_count = 0;
        components_count = 0;
        missing_count = 0;
        foreach (GameObject g in go)
        {
            FindInGO(g);
        }
        Debug.Log(string.Format("Searched {0} GameObjects, {1} components, found {2} missing", go_count, components_count, missing_count));
    }

    private static void FindInGO(GameObject g)
    {
        go_count++;
        Component[] components = g.GetComponents<Component>();
        for (int i = 0; i < components.Length; i++)
        {
            components_count++;
            if (components[i] == null)
            {
                missing_count++;
                string s = g.name;
                Transform t = g.transform;
                while (t.parent != null)
                {
                    s = t.parent.name + "/" + s;
                    t = t.parent;
                }
                Debug.Log(s + " has an empty script attached in position: " + i, g);
            }
        }
        // Now recurse through each child GO (if there are any):    
        foreach (Transform childT in g.transform)
        {
            //Debug.Log("Searching " + childT.name  + " " );    
            FindInGO(childT.gameObject);
        }
    }
}
