extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hitbox: Hitbox = $Hitbox
var caster: Character = null

func _ready():
	if caster:
		hitbox.damage *= caster.atk
	animation_player.play("animation")


func _on_Timer_timeout():
	queue_free()
