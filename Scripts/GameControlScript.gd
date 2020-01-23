extends Node
#################################
#	 Constants and variables 	#
#################################

onready var questionText = fetchNode("MainPanel/QuestionPanel/QuestionText");
onready var correctPanel = fetchNode("CorrectPanel");
onready var incorrectPanel = fetchNode("IncorrectPanel");
onready var correctPlayer = fetchNode("CorrectSound");
onready var incorrectPlayer = fetchNode("IncorrectSound");

var timer;
var timeout = 1;
var currentQuestion = 0;
var numberOfAnswers;
var db;
var questions = [];
var answerButtons = [];
var popupPanel;

#################################
#	 Signal handler methods 	#
#################################

func _ready():
	db = DBNode.db;
	timer = Timer.new();
	timer.connect("timeout", self, "_on_timer_timeout");
	add_child(timer);
	timer.set_wait_time(timeout);
	var answerPanel = fetchNode("MainPanel/AnswerPanel");
	answerButtons = answerPanel.get_children();
	numberOfAnswers = answerButtons.size();
	# Try to open database file
	if (not db.open("res://godotEyetrackerDb.db")):
		print("Could not open database");
		return;
	fetchAllQuestions();
	randomizeButtons();
	
	# Reference this node in each buttons to issue callbacks (on click events, etc)
	for btn in answerButtons:
		btn.controlNode = self;

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
		questions.append(item);

func fetchIncorrectAnswers():
	var currentShape = questions[currentQuestion].shape
	var currentColor = questions[currentQuestion].color
	var answerArray = []
	
	var query = "SELECT * FROM V_ANSWERS WHERE shape != '" + currentShape + "' ORDER BY RANDOM() LIMIT " + str(numberOfAnswers - 1);
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

func randomizeButtons():
	var answers = [];
		
	questionText.text = questions[currentQuestion].questionText;
	answers.append(questions[currentQuestion]);
	
	var tempArray = fetchIncorrectAnswers();
	for temp in tempArray:
		answers.append(temp);
	
	# Shuffle array for random location
	answers.shuffle();
	
	for i in range(answers.size()):
		if ('questionText' in answers[i]):
			answerButtons[i].isAnswerCorrect = true;
		else:
			answerButtons[i].isAnswerCorrect = false;
		var texture = answers[i].image;
		setItemTexture(answerButtons[i], texture);
	
	# Increment question. TODO: Put this in a separate function for later use
	currentQuestion = currentQuestion + 1;
	if (currentQuestion == questions.size()):
		currentQuestion = 0;

func popupPanel(isCorrect):
	timer.start();
	if(isCorrect):
		popupPanel = correctPanel;
	else:
		popupPanel = incorrectPanel;
	popupPanel.popup();

func _on_timer_timeout():
	timer.stop();
	popupPanel.hide();
	randomizeButtons();
	
func playSound(isCorrect):
	if (isCorrect):
		correctPlayer.play();
	else:
		incorrectPlayer.play();

# Fetch node from given path
func fetchNode(path):
	return get_parent().get_node(path)