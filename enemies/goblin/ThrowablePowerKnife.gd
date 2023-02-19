extends Projectile

onready var arrow_life_timer: Timer = $Timer

func _ready():
	arrow_life_timer.start()


func _collide(body: Character):
	if self_exited:
		if body != null:
			body.take_damage(damage, knockback_direction, knockback_force)


func _on_Timer_timeout():
	queue_free()
