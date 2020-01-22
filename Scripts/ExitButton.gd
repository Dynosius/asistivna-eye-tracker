extends TextureButton

func _ready():
	pass 
	
func _pressed():
	VolumeScript.free(); # Freeing the singleton occupying memory
	get_tree().quit()