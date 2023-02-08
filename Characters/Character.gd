extends KinematicBody2D
class_name Character, "res://heroes/knight/knight_idle_anim_f0.png"

const FRICTION: float = 0.15

export(int) var max_hp: int = 2 setget set_maxhp
export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp, max_hp)

export(int) var accerelation: int = 40
export(int) var max_speed: int = 100

onready var state_machine: Node = $FiniteStateMachine
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
func move()->void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * accerelation
	velocity = velocity.limit_length(max_speed)


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	self.hp -= dam
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force * 2

func set_hp(new_hp: int) -> void:
	hp = int(clamp(new_hp, 0, max_hp))
	emit_signal("hp_changed", hp, max_hp)
	
func set_maxhp(new_hp: int) -> void:
	max_hp = new_hp
	hp = max_hp
	emit_signal("hp_changed", hp, max_hp)
