extends TextureButton

var isAnswerCorrect = false;
var controlNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _pressed():
	controlNode.randomizeButtons();
