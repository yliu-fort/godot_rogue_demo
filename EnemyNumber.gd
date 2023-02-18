extends Label

onready var ss = get_tree().current_scene.get_node("Rooms").get_child(0)

func _physics_process(_delta):
	self.text = str(ss.get_child_count()-10)
