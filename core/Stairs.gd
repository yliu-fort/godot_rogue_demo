extends Area2D


onready var collision_shape = $CollisionShape2D


func _on_Stairs_body_entered(_body: Character):
	collision_shape.set_deferred("disabled", true)
	if SavedData.num_floor > SavedData.max_floors:
		SceneTransistor.start_transition_to("res://GameClear.tscn")
	else:
		SceneTransistor.start_transition_to("res://Game.tscn")
