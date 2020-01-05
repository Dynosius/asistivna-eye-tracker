extends Node

const SQLite = preload("res://lib/gdsqlite.gdns");
var db;

func _ready():
	db = SQLite.new();
	
	# Try to open database file
	if (not db.open_db("res://godotEyetrackerDb.db")):
		print("Could not open database");
		return;