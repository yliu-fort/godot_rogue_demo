extends Area2D

onready var animation_player = $AnimationPlayer


func _on_HealthPotion_body_entered(player: Character):
	player.hp = player.max_hp
	SavedData.hp = player.hp
	animation_player.play("use_potion")
