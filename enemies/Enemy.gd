extends Character
class_name Enemy, "res://enemies/flying creature/fly_anim_f0.png"

var path: PoolVector2Array

onready var navigation: Navigation2D = get_tree().current_scene.get_node("Rooms")
onready var player: Character = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = $PathTimer
onready var status_display_ui: TextureProgress = $Position2D/mini_hp_bar

export(int) var exp_on_death = 0

func _update_mini_hp_bar_on_hp_changed(new_hp, max_hp):
	status_display_ui.value = int(100 * new_hp / max_hp)
	if status_display_ui.value == 100:
		status_display_ui.visible = false
	else:
		status_display_ui.visible = true
	if status_display_ui.value < 25:
		status_display_ui.tint_progress = Color(138/255.0,41/255.0,41/255.0,1) # red
	elif status_display_ui.value < 50:
		status_display_ui.tint_progress = Color(185/255.0,190/255.0,18/255.0,1) # yellow
	else:
		status_display_ui.tint_progress = Color(11/255.0,145/255.0,31/255.0,1) # green


func _ready():
	set_level(lv)
	_update_mini_hp_bar_on_hp_changed(hp, max_hp)
	var __ = connect("hp_changed", self, "_update_mini_hp_bar_on_hp_changed")
	#__ = connect("mouse_entered", self, "_on_Area2D_mouse_entered") == OK
	#__ = connect("mouse_exited", self, "_on_Area2D_mouse_exited") == OK


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

