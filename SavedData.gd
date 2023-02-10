extends Node

var num_floor: int = 0 setget set_floor
signal floor_changed

var max_hp: int = -1
var max_mp: int = -1
var max_exp: int = -1
var hp: int = -1
var mp: int = -1
var myexp: int = -1
var lv: int = -1

var weapons: Array = []
var equipped_weapon_index: int = 0


func set_floor(new_floor):
	num_floor = new_floor
	emit_signal("floor_changed")
