extends RigidBody2D
class_name Character, "res://heroes/knight/knight_idle_anim_f0.png"

const HIT_EFFECT_SCENE: PackedScene = preload("res://effects/HitEffect.tscn")
const DAMAGE_TEXT_SCENE: PackedScene = preload("res://ui/DamageText.tscn")

const FRICTION: float = 0.15

export(int) var max_hp: int = 2 setget set_maxhp
export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp, max_hp)

export(int) var accerelation: int = 40
export(int) var max_speed: int = 100

export(int) var flying: bool = false

onready var state_machine: Node = $FiniteStateMachine
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready():
	friction = 0

func _physics_process(_delta: float) -> void:
	linear_velocity = velocity
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)


func move()->void:
	mov_direction = mov_direction.normalized()
	velocity += mov_direction * accerelation
	velocity = velocity.limit_length(max_speed)


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.dead:
		_spawn_hit_effect()
		if name == "Player":
			_spawn_damage_text(dam, Color(1,0,1,1))
		else:
			_spawn_damage_text(dam, Color(1,1,1,1))
		self.hp -= dam
		if name == "Player":
			SavedData.hp = hp
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2


func set_hp(new_hp: int) -> void:
	var temp_hp = int(clamp(new_hp, 0, max_hp))
	hp = temp_hp
	emit_signal("hp_changed", hp, max_hp)


func set_maxhp(new_hp: int) -> void:
	max_hp = new_hp
	hp = max_hp
	emit_signal("hp_changed", hp, max_hp)

func _spawn_hit_effect():
	var hit_effect: Sprite = HIT_EFFECT_SCENE.instance()
	add_child(hit_effect)

func _spawn_damage_text(dam: int, color: Color):
	var damage_text = DAMAGE_TEXT_SCENE.instance()
	damage_text.position = self.global_position
	damage_text.dam_text = str(dam)
	damage_text.text_color = color
	get_tree().current_scene.add_child(damage_text)
