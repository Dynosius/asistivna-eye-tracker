extends HSlider

func _ready():
	self.value = VolumeScript.volume;

func _on_VolumeSlider_value_changed(value):
	VolumeScript.setVolume(value);
