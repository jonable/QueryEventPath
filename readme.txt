Query EventPath

Command line program to query EventPath's DBISAM (v1.0) Database. 

Takes a SQL string as it's argument and returns the results as an XML string.

:> queryeventpath.exe "SQL STATEMENT" 

Database path and database name can be set in an init.ini file

init.ini

[DB]
	database_name=EventPath
	directory=\Path\To\DB
