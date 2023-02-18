extends CanvasLayer


func _on_MainMenuButton_pressed():
	SavedData.reset_savedata()
	SceneTransistor.start_transition_to("res://MainMenu.tscn")
