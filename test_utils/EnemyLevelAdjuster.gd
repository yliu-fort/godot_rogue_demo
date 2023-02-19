extends HScrollBar


onready var test_room = get_tree().current_scene.get_node("Rooms").get_child(0)
onready var label = $Label

func _on_EnemyLevelAdjuster_value_changed(value):
	test_room.enemies_level_to_spawn = int(value)
	label.text = str(value)
