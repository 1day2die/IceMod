// Which SQL module to use?
// Use SQLite if (end) you only want to use this on one server. If MySQL is selected but unavailable the script defaults to SQLite.
// SQLite is faster than MySQL but only saves for the server it's running on. SQLite also needs no configuration. 
//
// If you're not sure, leave this set to use SQLite.
//
// 1 = mySQL
// 2 = SQLite

local SQLtype = 2

// If you're using mySQL, enter your details here:

local sqlhost = "255.255.255.255"
local sqluser = "your_username"
local sqlpass = "your_password"
local sqldbname = "your_database_name"

/////////////////////////////////
// Don't edit below this line! //
/////////////////////////////////

function executequery(query)

	if (SQLtype == 1) then
		
		// Use mySQL to execute the query.
		require("mysql")
		
		local db, error = mysql.connect(sqlhost, sqluser, sqlpass, sqldbname) 
		if (db == 0) then 
			print("Error connecting to MySQL server.")
		end 
		
		local result, succ, err = mysql.query(db, query) 
		if (not succ) then
			print("Error in MySQL: " .. err ..".")
		end		
		
		// Disconnect from MySQL
		local succ, error = mysql.disconnect(db) 
		if (not succ) then 
			print("Error disconnecting from MySQL server.")
		end
		
		return result
		
	else
		
		// Use SQLite to execute the query.
		
		if not sql.TableExists( "titles" ) then    
			sql.Query( "CREATE TABLE IF NOT EXISTS titles ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, steamid VARCHAR NOT NULL, title VARCHAR NOT NULL );" ) 
			sql.Query( "CREATE INDEX IDX_TITLES_ID ON titles ( id DESC );" ) 
			print("SQLite created a new table: 'titles'.")
		end
		
		local result = sql.Query(query)
		
		if ( !result ) then 
			print("SQLite query returned nil. This is normal if you're performing things like UPDATE and INSERT queries.\n")
		end
		
		return result
		
	end
end

