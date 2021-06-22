program queryeventpath;
{$APPTYPE CONSOLE}
uses
  inifiles,
  DB,
  Classes,
  DBISAMTb,
  XMLOUTPUT in 'modules\xmloutput.pas',
  SysUtils,
  CmdLineHelper in 'modules\cmdlinehelper.pas';

procedure exit_on_error(msg: string);
begin
    writeln(msg);
    ExitCode := 1;
    Halt(ExitCode);
end;

var
    EventPath: TDBISAMDatabase;
    EventsQuery: TDBISAMQuery;
    StrStream: TStringStream;
    IniFile: TIniFile;
    Query: String;
    DBPath: String; 
    DBName: String;

begin

    Query := CmdLineHelper.GetParamStr(1);
    {
      DBPath := CmdLineHelper.GetParamStr(2);
      DBName := CmdLineHelper.GetParamStr(3);
    }

    
    {
      Query := 'SELECT '+
      'Events.EventCode, '+
	    'Events.EventSubCode, '+
	    'Events.ShortDescription, '+
	    'Events.CompanySetupStartDate, '+
	    'Events.Note FROM Events '+
      'WHERE Events.CompanySetupStartDate '+
      'BETWEEN ''20131010'' AND ''20141010''';
    }


    IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'init.ini');

    EventPath := TDBISAMDatabase.Create(Nil);
    EventPath.DatabaseName := IniFile.ReadString('DB', 'database_name', DBName);

    EventPath.Directory := IniFile.ReadString('DB', 'directory', DBPath);
    EventPath.Connected := True;
    EventsQuery := TDBISAMQuery.Create(Nil);

     with EventsQuery do
     begin
        DatabaseName := DBName;
        SQL.Clear;
        SQL.Add(Query);
        try
            Prepare;
        except
            on E: EDBISAMEngineError do
            begin
                exit_on_error(E.Message);
            end;
        end;
        if SQLStatementType <> stSelect then
        begin
            exit_on_error('SELECT statements only');
        end;
        try
            Open;
        except
            on E: EDBISAMEngineError do
            begin
               Close;
               exit_on_error(E.Message);
            end;
        end;
     end;

     StrStream := TStringStream.Create('');
     DatasetToXML(EventsQuery, StrStream);
     writeln(StrStream.DataString);
     StrStream.Free;
     EventsQuery.Close;

end.
