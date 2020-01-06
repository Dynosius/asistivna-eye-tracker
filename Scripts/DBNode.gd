extends Node

const SQLite = preload("res://lib/gdsqlite.gdns");

var db;
var questions = [];
var answerButtons = [];
onready var questionText = fetchNode("MainPanel/QuestionPanel/QuestionText");
var currentQuestion = 0;

func _ready():
	db = SQLite.new();
	# Try to open database file
	if (not db.open("res://godotEyetrackerDb.db")):
		print("Could not open database");
		return;
	fetchAllQuestions();
	parseSQLData();

func fetchAllQuestions():
	# Select all questions in random order
	var result = db.fetch_array("SELECT * FROM V_QUESTIONS ORDER BY RANDOM()");
	
	if (not result or result.empty()):
		return;
	# Fill questions array with db items
	for res in result: 
		var item = {
			'id': res['id'],
			'questionText': res['questionText']	,
			'image': res['image']
		}
		questions.append(item);
	
# For separation of logic from ready view. Method parses sql and sets button images and question text
func parseSQLData():
	var answerPanel = fetchNode("MainPanel/AnswerPanel");
	answerButtons = answerPanel.get_children();
	var texture = questions[currentQuestion].image
	questionText.text = questions[currentQuestion].questionText
	# Set middle button's texture
	setItemTexture(answerButtons[1], texture);

# Set passed poolByteArray as text and attempt to put it as a texture_normal of the passed item
func setItemTexture(item, poolByteArray):
	var img = Image.new();
	img.load_png_from_buffer(poolByteArray);
	var itex = ImageTexture.new();
	itex.create_from_image(img);
	
	item.texture_normal = itex;
	
# Cycle questions TODO: REPLACE LOGIC WITH SOMETHING MORE RANDOM
func _on_BackButton_pressed():
	currentQuestion = currentQuestion % (questions.size() - 1) + 1
	var texture = questions[currentQuestion].image
	setItemTexture(answerButtons[1], texture)
	questionText.text = questions[currentQuestion].questionText

# Fetch node from given path
func fetchNode(path):
	return get_parent().get_node(path)