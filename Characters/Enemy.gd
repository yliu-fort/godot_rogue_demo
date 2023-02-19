extends Character
class_name Enemy, "res://enemies/flying creature/fly_anim_f0.png"

var path: PoolVector2Array

onready var navigation: Navigation2D = get_tree().current_scene.get_node("Rooms")
onready var player: Character = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = $PathTimer

export(int) var exp_on_death = 0

func _ready():
	set_level(lv)
	
func chase() -> void:
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 3:
			path.remove(0)
			if not path:
				return
		mov_direction = vector_to_next_point
		
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true


func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO

func _get_path_to_player():
	path = navigation.get_simple_path(self.global_position, player.position)

func queue_free():
	if is_instance_valid(player):
		player.obtain_exp(exp_on_death)
	.queue_free()
