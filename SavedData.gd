extends Node

var num_floor: int = 0 setget set_floor
var max_floors: int = 20
signal floor_changed

var max_hp: int = -1
var max_mp: int = -1
var max_exp: int = -1
var hp: int = -1
var mp: int = -1
var myexp: int = -1
var lv: int = -1
var atk: int = -1
var def: int = -1

var weapons: Array = []
var equipped_weapon_index: int = 0


func set_floor(new_floor):
	num_floor = new_floor
	emit_signal("floor_changed")


func reset_savedata():
	num_floor = 0

	max_hp = -1
	max_mp = -1
	max_exp = -1
	hp = -1
	mp = -1
	myexp = -1
	lv = -1
	atk = -1
	def = -1

	weapons = []
	equipped_weapon_index = 0
