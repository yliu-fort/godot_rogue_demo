extends CanvasLayer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func _on_MainMenuButton_pressed():
	SavedData.reset_savedata()
	SceneTransistor.start_transition_to("res://MainMenu.tscn")
