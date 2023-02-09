extends Hitbox



func _on_Hitbox_area_entered(area: Projectile):
	area.queue_free()
