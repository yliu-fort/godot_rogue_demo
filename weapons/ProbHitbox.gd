extends Hitbox


func _collide(body: Character):
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		if randi()%2 == 0:
			if knockback_inverted:
				body.take_damage(damage,-knockback_direction, knockback_force)
			else:
				body.take_damage(damage, knockback_direction, knockback_force)
