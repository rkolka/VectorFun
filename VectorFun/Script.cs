using System;
using System.IO;
using Manifold;



public class Script
{
    private static readonly string AddinName = "VectorFun";
    private static readonly string AddinCodeFolder = "Code\\VectorFun";

    private static readonly string[] CodeFiles = { "VectorFunBase.sql", "VectorFunGeom.sql", "VectorFunConstants.sql", "VectorFunTest.sql" };

    private static Context Manifold;

    public static void Main()
    {
        Application app = Manifold.Application;

        using (Database db = app.GetDatabaseRoot())
        {
            CreateQueries(app, db);
        }

        app.Log(DisplayHelp());
        app.OpenLog();
    }


    private static string DisplayHelp()
    {
        return "Use include directive:\r\n-- $include$ [VectorFunGeom.sql]";
    }


    public static void CreateQuery(Application app, Database db, string name, string text, string folder = "")
    {
        PropertySet propertyset = app.CreatePropertySet();
        propertyset.SetProperty("Text", text);
        if (folder != "")
        {
            propertyset.SetProperty("Folder", folder);

        }
        db.Insert(name, "query", null, propertyset);

    }

    public static void CreateQueries(Application app, Database db)
    {
        string AddinDir = System.IO.Path.GetDirectoryName(new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase).LocalPath);

        foreach (string fname in CodeFiles)
        {
            bool rewrite = true;

            if (db.GetComponentType(fname) == "")
            {
                rewrite = true;
            }
            else
            {
                rewrite = false;

                string message = $"{db.GetComponentType(fname).ToUpper()} {fname} already exists. DROP?";

                System.Windows.Forms.MessageBoxButtons buttons = System.Windows.Forms.MessageBoxButtons.YesNo;
                System.Windows.Forms.DialogResult result = System.Windows.Forms.MessageBox.Show(message, AddinName, buttons);
                if (result == System.Windows.Forms.DialogResult.Yes)
                {
                    db.Delete(fname);
                    rewrite = true;
                }
            }

            if (rewrite)
            {
                string text = File.ReadAllText(AddinDir + "\\" + fname);
                // TODO? check hash?

                // insert
                CreateQuery(app, db, fname, text, AddinCodeFolder);
            }
        }
    }


}

