extends Node

const SQLite = preload("res://lib/gdsqlite.gdns");
var db;

func _ready():
	db = SQLite.new();
	
func freeResources():
	SQLite.free();
