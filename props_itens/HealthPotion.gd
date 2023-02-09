extends Area2D

onready var animation_player = $AnimationPlayer

func _on_HealthPotion_body_entered(player: Character):
	var heal_amount = player.max_hp - player.hp
	player.hp += heal_amount
	SavedData.hp = player.hp
	animation_player.play("use_potion")
	player._spawn_damage_text(heal_amount, Color(0,1,0,1))
