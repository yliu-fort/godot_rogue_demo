extends Character
class_name Player

onready var sword: Node2D = $Sword
onready var sword_hitbox: Area2D = $Sword/Node2D/Sprite/Hitbox
onready var sword_animation_player: AnimationPlayer = $Sword/SwordAnimationPlayer

func _ready():
	add_to_group("player")

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	sword.rotation = mouse_direction.angle()
	sword_hitbox.knockback_direction = mouse_direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
		
	#print(global_position)


func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP
		
	if Input.is_action_just_pressed("ui_attack") and not sword_animation_player.is_playing():
		sword_animation_player.play("attack")
