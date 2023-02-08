extends Enemy

onready var hitbox: Area2D = $Hitbox


func _process(_delta):
	hitbox.knockback_direction = velocity.normalized()
	

