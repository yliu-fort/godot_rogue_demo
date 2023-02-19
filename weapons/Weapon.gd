extends Node2D
class_name Weapon

export(bool) var on_floor: bool = false

var caster: Character = null setget set_caster
var can_active_ability: bool = true


onready var animation_player = $AnimationPlayer
onready var charge_particles = $Node2D/Sprite/ChargeParticles
onready var hitbox = $Node2D/Sprite/Hitbox
onready var player_detector: Area2D = $PlayerDetector
onready var tween: Tween = $Tween
onready var cool_down_timer: Timer = $CoolDownTimer
onready var ui = $UI
onready var ability_icon = $UI/AbilityIcon
onready var ability_icon_border = $UI/AbilityIcon/ReferenceRect

export(PackedScene) var weapon_ability = null

func _ready():
	if not on_floor:
		player_detector.set_collision_mask_bit(0, false)
		player_detector.set_collision_mask_bit(1, false)
		
func get_attack_input() -> void:
	if Input.is_action_just_pressed("ui_attack") and not animation_player.is_playing():
		animation_player.play("charge")
	elif Input.is_action_just_released("ui_attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif charge_particles.emitting and not animation_player.current_animation == "active_ability":
			# if emitting only then strong_attack can be triggered without charging during active_ability state
			animation_player.play("strong_attack")
	elif Input.is_action_just_released("ui_active_ability") and animation_player.has_animation("active_ability") and not is_busy() and can_active_ability:
		if weapon_ability:
			can_active_ability = false
			cool_down_timer.start()
			ui.recharge_ability_animation(cool_down_timer.wait_time)
		animation_player.play("active_ability")


func _release_ability():
	if weapon_ability:
		var wb = weapon_ability.instance()
		var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
		wb.rotation = mouse_direction.angle()
		wb.position = global_position + mouse_direction * 30
		wb.caster = caster # player/weapons/weapon: add player's damage
		get_tree().current_scene.add_child(wb)


func cancel_attack():
	animation_player.play("cancel_attack")
	
func move(mouse_direction):
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1

func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false

func reset_animation():
	animation_player.play("RESET")
	
func _on_PlayerDetector_body_entered(body: PhysicsBody2D):
	if body != null:
		player_detector.set_collision_mask_bit(0, false)
		player_detector.set_collision_mask_bit(1, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		var __ = tween.stop_all()
		assert(__)
		player_detector.set_collision_mask_bit(1, true)

func interpolate_pos(initial_pos: Vector2, final_pos: Vector2):
	var __ = tween.interpolate_property(self, "position", initial_pos, final_pos, 0.8, Tween.TRANS_QUART, Tween.EASE_OUT)
	assert(__)
	__ = tween.start()
	assert(__)
	player_detector.set_collision_mask_bit(0, true)


func _on_Tween_tween_completed(_object, _key):
	player_detector.set_collision_mask_bit(1, true)


func _on_CoolDownTimer_timeout():
	can_active_ability = true

func show():
	ability_icon.show()
	ability_icon_border.show()
	.show()
	
func hide():
	ability_icon.hide()
	ability_icon_border.hide()
	.hide()
	
func get_texture() -> Texture:
	return $Node2D/Sprite.texture

func set_caster(new_caster: Character):
	hitbox.caster = new_caster
	caster = new_caster
