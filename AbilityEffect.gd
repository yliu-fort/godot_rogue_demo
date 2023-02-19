extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hitbox: Hitbox = $Hitbox

func _ready():
	animation_player.play("animation")


func _on_Timer_timeout():
	queue_free()
