extends RoomGeo

const WEAPONS: Array = [
preload("res://weapons/Hammer.tscn"),
preload("res://weapons/LongAxe.tscn"),
preload("res://weapons/Sword.tscn")]

onready var weapon_pos = $WeaponPos


func _ready():
	var weapon = WEAPONS[randi()%WEAPONS.size()].instance()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)

