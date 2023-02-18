extends Hitbox



func _on_Hitbox_area_entered(area: Projectile):
	if area:
		area.queue_free()
