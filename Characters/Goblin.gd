extends Enemy

const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://enemies/goblin/ThrowableKnife.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40


export(int) var projectile_speed: int = 150

var can_attack: bool = true

var distance_to_player: float

onready var attack_timer = $AttackTimer
onready var aim_raycast = $RayCast2D

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			if can_attack:
				aim_raycast.enabled = true
				aim_raycast.cast_to = player.position - global_position
				if state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
					can_attack = false
					aim_raycast.enabled = false
					_throw_knife()
					attack_timer.start()
	else:
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO


func _get_path_to_move_away_from_player():
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(self.global_position, global_position + dir*100)


func _throw_knife():
	var projectile: Area2D = THROWABLE_KNIFE_SCENE.instance()
	projectile.launch(global_position, (player.position-global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _on_AttackTimer_timeout():
	can_attack = true
