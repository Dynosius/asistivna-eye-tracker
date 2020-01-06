extends Node
#################################
#	 Constants and variables 	#
#################################

const SQLite = preload("res://lib/gdsqlite.gdns");
const numberOfAnswers = 3;
var db;
var questions = [];
var answerButtons = [];
onready var questionText = fetchNode("MainPanel/QuestionPanel/QuestionText");
var currentQuestion = 0;

func _ready():
	db = SQLite.new();
	var answerPanel = fetchNode("MainPanel/AnswerPanel");
	answerButtons = answerPanel.get_children();
	# Try to open database file
	if (not db.open("res://godotEyetrackerDb.db")):
		print("Could not open database");
		return;
	fetchAllQuestions();
	randomizeButtons();

#########################
#	 Utility methods 	#
#########################

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
			'image': res['image'],
			'color': res['color'],
			'shape': res['shape']
		}
		questions.append(item)

func fetchIncorrectAnswers():
	var currentShape = questions[currentQuestion].shape
	var currentColor = questions[currentQuestion].color
	var answerArray = []
	
	var query = "SELECT * FROM V_ANSWERS WHERE color != '" + currentColor + "' AND shape != '" + currentShape + "' ORDER BY RANDOM() LIMIT " + str(numberOfAnswers - 1);
	var result = db.fetch_array(query);
	
	for res in result: 
		var item = {
			'id': res['id'],
			'color': res['color'],
			'shape': res['shape'],
			'image': res['image']
		}
		answerArray.append(item);
	return answerArray;

# Set passed poolByteArray as text and attempt to put it as a texture_normal of the passed item
func setItemTexture(item, poolByteArray):
	var img = Image.new();
	img.load_png_from_buffer(poolByteArray);
	var itex = ImageTexture.new();
	itex.create_from_image(img);
	
	item.texture_normal = itex;
	
func _on_BackButton_pressed():
	randomizeButtons();

func randomizeButtons():
	var answers = []
	#Placeholder, 0 is correct answer at the moment
	currentQuestion = currentQuestion % (questions.size() - 1) + 1
	questionText.text = questions[currentQuestion].questionText
	answers.append(questions[currentQuestion]);
	
	var tempArray = fetchIncorrectAnswers();
	for temp in tempArray:
		answers.append(temp)
	
	for i in range(answers.size()):
		var texture = answers[i].image;
		setItemTexture(answerButtons[i], texture);

# Fetch node from given path
func fetchNode(path):
	return get_parent().get_node(path)