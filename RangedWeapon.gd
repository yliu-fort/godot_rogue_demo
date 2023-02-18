extends Weapon
class_name RangedWeapon

const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://enemies/goblin/ThrowableKnife.tscn")
const THROWABLE_POWERKNIFE_SCENE: PackedScene = preload("res://enemies/goblin/ThrowablePowerKnife.tscn")

export(int) var projectile_speed: int = 200
onready var launch_direction: Vector2 = Vector2(0,0)
onready var launch_point = $ReleasePosition

func _set_launch_direction():
	launch_direction = (get_global_mouse_position() - global_position).normalized()

func _throw_arrow():
	_set_launch_direction()
	var projectile: Area2D = THROWABLE_KNIFE_SCENE.instance()
	projectile.self_exited = true
	projectile.set_collision_mask_bit(0, true)
	projectile.set_collision_mask_bit(1, false)
	projectile.set_collision_mask_bit(2, true)
	projectile.launch(launch_point.global_position, launch_direction, projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _throw_power_arrow():
	_throw_power_arrow_helper(launch_direction)
	_throw_power_arrow_helper(launch_direction.rotated(deg2rad(10)))
	_throw_power_arrow_helper(launch_direction.rotated(deg2rad(-10)))
	

func _throw_power_arrow_helper(dir: Vector2):
	var projectile: Area2D = THROWABLE_POWERKNIFE_SCENE.instance()
	projectile.self_exited = true
	projectile.set_collision_mask_bit(0, true)
	projectile.set_collision_mask_bit(1, false)
	projectile.set_collision_mask_bit(2, true)
	projectile.launch(launch_point.global_position, dir, projectile_speed*2)
	get_tree().current_scene.add_child(projectile)
