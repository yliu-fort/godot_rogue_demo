extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var timer: Timer = $Timer
onready var hitbox: Hitbox = $Hitbox

export(int) var required_mp = 30

var caster: Character = null

func _enter_tree():
	if not caster or caster.mp < required_mp:
		.queue_free()
	else:
		caster.mp -= required_mp


func _ready():
	hitbox.damage *= caster.atk
	rotation = 0
	animation_player.play("animation")


func _on_Timer_timeout():
	queue_free()
