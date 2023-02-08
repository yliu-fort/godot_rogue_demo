extends Label

onready var ss = get_tree().current_scene.get_node("Rooms/StressTestRoom")

func _physics_process(_delta):
	self.text = str(ss.get_child_count()-7)
