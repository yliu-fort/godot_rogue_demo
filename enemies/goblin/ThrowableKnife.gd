extends Hitbox
class_name Projectile

var caster: Character = null
var self_exited: bool = false
var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0

func _ready():
	if caster:
		damage *= caster.atk
	else:
		queue_free()

func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	rotation += dir.angle() + PI/4
	
	
func _physics_process(delta: float):
	position += direction * knife_speed * delta


func _on_ThrowableKnife_body_exited(body: Character):
	if not self_exited:
		self_exited = true
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1, not body.get_collision_layer_bit(1))
		set_collision_mask_bit(2, not body.get_collision_layer_bit(2))


func _collide(body: Character):
	if self_exited:
		if body != null:
			body.take_damage(damage, knockback_direction, knockback_force)
		queue_free()

