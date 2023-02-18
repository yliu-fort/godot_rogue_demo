extends Area2D
class_name Hitbox

export(int) var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 200
export(bool) var knockback_inverted: bool = false

var body_inside: bool = false

onready var collision_shape: CollisionShape2D = get_child(0)
onready var timer: Timer = Timer.new()

func _init() -> void:
	if not is_connected("body_entered", self, "_on_body_entered"):
		var __ = connect("body_entered", self, "_on_body_entered")
		__ = connect("body_exited", self, "_on_body_exited")

func _ready():
	assert(collision_shape != null)
	timer.wait_time = 1
	add_child(timer)
	
	
func _on_body_entered(body: Character):
	body_inside = true
	timer.start()
	while body_inside:
		_collide(body)
		yield(timer, "timeout")


func _on_body_exited(_body: Character):
	body_inside = false
	timer.stop()

func _collide(body: Character):
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		if knockback_inverted:
			body.take_damage(damage,-knockback_direction, knockback_force)
		else:
			body.take_damage(damage, knockback_direction, knockback_force)
