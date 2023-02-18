extends Hitbox


func _collide(body: Character):
	knockback_direction = (body.global_position - global_position).normalized()
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		if knockback_inverted:
			body.take_wind_damage(damage,-knockback_direction, knockback_force)
		else:
			body.take_wind_damage(damage, knockback_direction, knockback_force)
