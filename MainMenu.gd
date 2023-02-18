extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game waiting...")


func _on_GameStartButton_pressed():
	SavedData.reset_savedata()
	SceneTransistor.start_transition_to("res://Game.tscn")


func _on_ToTestSceneButton_pressed():
	SceneTransistor.start_transition_to("res://Test.tscn")
