extends Hitbox
class_name Magic

export(int) var required_mp = 1

var self_exited: bool = false
var caster: Character = null
var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0

const FIREHIT_SCENE: PackedScene = preload("res://weapons/FireHit.tscn")

func _enter_tree():
	if not caster or caster.mp < required_mp:
		.queue_free()
	else:
		caster.mp -= required_mp

func _ready():
	damage *= caster.atk

func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	rotation += dir.angle()
	
	
func _physics_process(delta: float):
	position += direction * knife_speed * delta


func _on_ThrowableKnife_body_exited(body: Character):
	if not self_exited:
		self_exited = true
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, not body.get_collision_layer_bit(1)) # collide with player
		set_collision_mask_bit(2, body.get_collision_layer_bit(1)) # collide with enemy


func _collide(body: Character):
	if self_exited:
		if body != null:
			body.take_fire_damage(damage, knockback_direction, knockback_force)
		queue_free()


func _on_Timer_timeout():
	queue_free()


func queue_free():
	var firehit: Node2D = FIREHIT_SCENE.instance()
	firehit.position = global_position
	firehit.caster = caster
	get_tree().current_scene.call_deferred("add_child",firehit)
	.queue_free()
