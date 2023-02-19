extends Weapon
class_name MagicWeapon


const FIREBALL_SCENE: PackedScene = preload("res://weapons/FireBall.tscn")

export(int) var projectile_speed: int = 120
onready var launch_direction: Vector2 = Vector2(0,0)
onready var launch_point = $ReleasePosition


func _release_ability():
	if weapon_ability:
		var wb = weapon_ability.instance()
		var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
		wb.rotation = mouse_direction.angle()
		wb.position = get_global_mouse_position()
		wb.caster = self.caster
		get_tree().current_scene.add_child(wb)

func _set_launch_direction():
	launch_direction = (get_global_mouse_position() - global_position).normalized()

func _throw_arrow():
	_set_launch_direction()
	var projectile: Area2D = FIREBALL_SCENE.instance()
	projectile.self_exited = true
	projectile.set_collision_mask_bit(0, true)
	projectile.set_collision_mask_bit(1, false)
	projectile.set_collision_mask_bit(2, true)
	projectile.launch(launch_point.global_position, launch_direction, projectile_speed)
	projectile.caster = self.caster
	get_tree().current_scene.add_child(projectile)

func _throw_power_arrow():
	for __ in 5:
		_throw_power_arrow_helper()


func _throw_power_arrow_helper():
	_set_launch_direction()
	var projectile: Area2D = FIREBALL_SCENE.instance()
	projectile.self_exited = true
	projectile.set_collision_mask_bit(0, true)
	projectile.set_collision_mask_bit(1, false)
	projectile.set_collision_mask_bit(2, true)
	projectile.launch(launch_point.global_position+Vector2(randi()%16-8,randi()%16-8), launch_direction.rotated(deg2rad(randf()*10-5)), int(projectile_speed*(0.2+0.8*randf()*randf())) )
	projectile.caster = self.caster
	get_tree().current_scene.add_child(projectile)
