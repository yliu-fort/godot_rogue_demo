extends Button


onready var ss = get_tree().current_scene.get_node("Rooms").get_child(0)


func _on_Button_pressed():
	ss._spawn_enemies()
