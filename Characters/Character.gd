extends RigidBody2D
class_name Character, "res://heroes/knight/knight_idle_anim_f0.png"

const HIT_EFFECT_SCENE: PackedScene = preload("res://effects/HitEffect.tscn")
const DAMAGE_TEXT_SCENE: PackedScene = preload("res://ui/DamageText.tscn")

const FRICTION: float = 0.15

export(int) var max_hp: int = 2 setget set_maxhp
export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp, max_hp)

export(int) var max_mp: int = 2 setget set_maxmp
export(int) var mp: int = 2 setget set_mp
signal mp_changed(new_mp, max_mp)

export(int) var max_exp: int = 100 setget set_maxexp
export(int) var myexp: int = 0 setget set_exp
signal exp_changed(new_exp, max_exp)

export(int) var max_lv: int = 99 setget set_maxlv
export(int) var lv: int = 0 setget set_lv
signal lv_changed(new_lv, max_lv)

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
			_spawn_damage_text(dam, Color(1,0,0.8,1))
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
	emit_signal("hp_changed", hp, max_hp)
	
func set_mp(new_mp: int) -> void:
	var temp_mp = int(clamp(new_mp, 0, max_mp))
	mp = temp_mp
	emit_signal("mp_changed", mp, max_mp)

func set_maxmp(new_mp: int) -> void:
	max_mp = new_mp
	emit_signal("mp_changed", mp, max_mp)
	
func set_exp(new_exp: int) -> void:
	if new_exp >= max_exp:
		var exp_diff = new_exp - max_exp
		self._level_up()
		myexp = exp_diff
	else:
		var temp_exp = int(clamp(new_exp, 0, max_exp))
		myexp = temp_exp
	emit_signal("exp_changed", myexp, max_exp)

func set_maxexp(new_exp: int) -> void:
	max_exp = new_exp
	self.myexp += 0
	emit_signal("exp_changed", myexp, max_exp)
	
func set_lv(new_lv: int) -> void:
	var temp_lv = int(clamp(new_lv, 0, max_lv))
	lv = temp_lv
	self.max_exp = int(100 * max(lv,1) * pow(1.1,lv))
	emit_signal("lv_changed", lv, max_lv)

func set_maxlv(new_lv: int) -> void:
	max_lv = new_lv
	emit_signal("lv_changed", lv, max_lv)

func _level_up():
	self.lv += 1
	self.max_hp += 10
	self.max_mp += 5
	self.hp = self.max_hp
	if name == "Player":
		SavedData.max_hp = self.max_hp
		SavedData.max_mp = self.max_mp
		SavedData.max_exp = self.max_exp
		SavedData.lv = self.lv
		SavedData.hp = self.hp
		#SavedData.mp = self.mp
		#SavedData.myexp = self.myexp

func _spawn_hit_effect():
	var hit_effect: Sprite = HIT_EFFECT_SCENE.instance()
	add_child(hit_effect)

func _spawn_damage_text(dam: int, color: Color):
	var damage_text = DAMAGE_TEXT_SCENE.instance()
	damage_text.position = self.global_position
	damage_text.dam_text = str(dam)
	damage_text.text_color = color
	get_tree().current_scene.add_child(damage_text)


func _on_ResourceRecoveryTimer_timeout():
	self.mp += 1

func obtain_exp(obtained_exp: int):
	self.myexp += obtained_exp
	if name == "Player":
		SavedData.myexp = self.myexp
