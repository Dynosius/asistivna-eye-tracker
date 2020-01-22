extends Node

var volume;
# Called when the node enters the scene tree for the first time.
func _ready():
	volume = -20;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setVolume(arg): 
	self.volume = arg;
