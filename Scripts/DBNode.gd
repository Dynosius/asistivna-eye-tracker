extends Node

const SQLite = preload("res://lib/gdsqlite.gdns");
var db;
var questions = [];

func _ready():
	db = SQLite.new();
	
	# Try to open database file
	if (not db.open("res://godotEyetrackerDb.db")):
		print("Could not open database");
		return;
		
	var result = db.fetch_array("SELECT * FROM Question LEFT OUTER JOIN Answer ON Answer.id = answerId");
	
	if (not result or result.empty()):
		return;
		
	for res in result: 
		var item = {
			'id': res['id'],
			'questionText': res['questionText']	,
			'image': res['image']
		}
		questions.append(item);
	
	print(questions[0]);