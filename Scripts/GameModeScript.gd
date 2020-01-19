extends TextureButton
export(int) var nQuestions;

func _ready():
	pass 

func _pressed():
	get_tree().change_scene("res://Scenes/" + str(nQuestions) + "QuestionPanel.tscn")