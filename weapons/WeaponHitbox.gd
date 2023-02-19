extends Hitbox

var caster: Character = null

func _collide(body: Character):
	if body == null or not body.has_method("take_damage") or not caster:
		queue_free()
	else:
		if knockback_inverted:
			body.take_damage(damage*caster.atk,-knockback_direction, knockback_force)
		else:
			body.take_damage(damage*caster.atk, knockback_direction, knockback_force)

func _on_Hitbox_area_entered(area: Projectile):
	if area:
		area.queue_free()
