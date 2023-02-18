extends Hitbox


func _collide(body: Character):
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_fire_damage(damage, knockback_direction, knockback_force)
