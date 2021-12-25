using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



public class Script
{

    private static Manifold.Context Manifold;

    public static void Main()
    {
        // The current application context 
        Manifold.Application app = Manifold.Application;

        app.Log(MapFilePath());

        app.Log("VectorFun (re)loaded!");
        app.OpenLog();
    }

    public static string MapFilePath()
    {
        Manifold.Application app = Manifold.Application;
        using (Manifold.Database db = app.GetDatabaseRoot())
        {
            if (db == null)
            {
                return "No project open";
            }
            else
            {
                return MapFilePath(app, db);
            }
        }
    }

    public static string MapFilePath(Manifold.Application app, Manifold.Database db)
    {
        Manifold.PropertySet dbConnProps = app.CreatePropertySetParse(db.Connection);
        string path = dbConnProps.GetProperty("Source");
        return (path == "") ? "(New Project)" : path;
    }

}

