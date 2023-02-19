extends Character
class_name Player

enum {UP, DOWN}

var current_weapon: Weapon = null
onready var weapons: Node2D = $Weapons

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_dropped(index)

func _ready():
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	_restore_previous_state()
	
func _restore_previous_state():
	if SavedData.max_hp >= 0:
		self.max_hp = SavedData.max_hp
		self.max_mp = SavedData.max_mp
		self.max_exp = SavedData.max_exp
		self.lv = SavedData.lv
		self.myexp = SavedData.myexp
		self.hp = SavedData.hp
		self.mp = SavedData.mp
		self.atk = SavedData.atk
		self.def = SavedData.def
	else:
		self.hp = self.max_hp
		self.mp = self.max_mp
		SavedData.max_hp = self.max_hp
		SavedData.max_mp = self.max_mp
		SavedData.max_exp = self.max_exp
		SavedData.lv = self.lv
		SavedData.myexp = self.myexp
		SavedData.hp = self.hp
		SavedData.mp = self.mp
		SavedData.atk = self.atk
		SavedData.def = self.def
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
		weapon.hide()
		emit_signal("weapon_picked_up", weapon.get_texture())
		emit_signal("weapon_switched", weapons.get_child_count()-2, weapons.get_child_count()-1)
	current_weapon = weapons.get_child(SavedData.equipped_weapon_index)
	current_weapon.reset_animation()
	current_weapon.show()
	current_weapon.caster = self
	emit_signal("weapon_switched", weapons.get_child_count()-1, SavedData.equipped_weapon_index)
	

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	current_weapon.move(mouse_direction)


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


func get_attack_input():
	if not current_weapon.is_busy():
		if Input.is_action_just_pressed("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_pressed("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_throw") and current_weapon.get_index() != 0:
			_drop_weapon()
			
	current_weapon.get_attack_input()


func cancel_attack():
	current_weapon.cancel_attack()

func _switch_weapon(direction: int):
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0

	current_weapon.hide()
	current_weapon.caster = null
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	current_weapon.caster = self
	SavedData.equipped_weapon_index = index
	emit_signal("weapon_switched", prev_index, index)

func pick_up_weapon(weapon: Weapon):
	SavedData.weapons.append(weapon.duplicate())
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon.caster = null
	current_weapon.cancel_attack()
	current_weapon = weapon
	current_weapon.on_floor = false
	current_weapon.show()
	current_weapon.caster = self
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)


func _drop_weapon():
	SavedData.weapons[current_weapon.get_index() - 1].queue_free()
	SavedData.weapons.remove(current_weapon.get_index() - 1)
	var weapon_to_drop = current_weapon
	_switch_weapon(UP)
	emit_signal("weapon_dropped", weapon_to_drop.get_index())
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	yield(weapon_to_drop.tween, "tree_entered")
	weapon_to_drop.show()
	weapon_to_drop.ability_icon.hide()
	weapon_to_drop.on_floor = true
	current_weapon.caster = null
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)


func _on_ManaRecoveryTimer_timeout():
	self.mp += 1
	SavedData.mp = self.mp


func _move_to_gamefail_scene():
	SceneTransistor.start_transition_to("res://GameFail.tscn")

