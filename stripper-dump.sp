ArrayList arr;
bool load;

public Plugin myinfo = 
{
    name        = "Stripper Dump",
    author      = "Kyle",
    description = "",
    version     = "1.0",
    url         = "https://kxnrl.com"
};

public void OnPluginStart()
{
    arr = new ArrayList(ByteCountToCells(256));

    File hFile;
    if((hFile = OpenFile("mapcycle.txt", "r")) != null)
    {
        char fileline[128];
        int c;
        while(hFile.ReadLine(fileline, 128))
        {
            if(fileline[0] == '\0')
                continue;
            
            c = strlen(fileline) - 1;
            fileline[c] = '\0';

            arr.PushString(fileline);
        }
        delete hFile;
    }
}

public void OnMapStart()
{
    if(arr.Length > 0)
        CreateTimer(5.0, Timer_Dump, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void OnMapEnd()
{
    load = false;
}

public Action Timer_Dump(Handle timer)
{
    if(!load)
    {
        load = true;
        ServerCommand("stripper_dump");
    }

    CreateTimer(5.0, Timer_Change, _, TIMER_FLAG_NO_MAPCHANGE);

    return Plugin_Stop;
}

public Action Timer_Change(Handle timer)
{
    char map[128];
    arr.GetString(0, map, 128);
    arr.Erase(0);
    ForceChangeLevel(map, "Stripper Dump");

    return Plugin_Stop;
}