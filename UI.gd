extends CanvasLayer

const INVENTORY_ITEM_SCENE: PackedScene = preload("res://ui/InventoryItem.tscn")

onready var player: Character = get_parent().get_node("Player")
onready var health_bar = $PlayerStatusContainer/HealthBar
onready var health_bar_tween = $PlayerStatusContainer/HealthBar/Tween
onready var health_bar_text = $PlayerStatusContainer/HealthBar/Label
onready var mana_bar = $PlayerStatusContainer/ManaBar
onready var mana_bar_tween = $PlayerStatusContainer/ManaBar/Tween
onready var mana_bar_text = $PlayerStatusContainer/ManaBar/Label
onready var exp_bar = $PlayerStatusContainer/ExpBar
onready var exp_bar_tween = $PlayerStatusContainer/ExpBar/Tween
onready var exp_bar_text = $PlayerStatusContainer/ExpBar/Label
onready var exp_bar_level_text = $PlayerStatusContainer/ExpBar/LevelLabel
onready var floor_text = $Floor
onready var inventory: HBoxContainer = $PanelContainer/Inventory


func _ready():
	if player:
		var __
		__ = player.connect("hp_changed", self, "_on_Player_hp_changed")
		__ = player.connect("mp_changed", self, "_on_Player_mp_changed")
		__ = player.connect("exp_changed", self, "_on_Player_exp_changed")
		__ = player.connect("lv_changed", self, "_on_Player_lv_changed")
		_update_health_bar(player.hp, player.max_hp)
		_update_mana_bar(player.mp, player.max_mp)
		_update_exp_bar(player.myexp, player.max_exp)
		_update_exp_bar_lv(player.lv)

		__ = SavedData.connect("floor_changed", self, "_on_floor_changed")
		__ = player.connect("weapon_picked_up", self, "_on_Player_weapon_picked_up")
		__ = player.connect("weapon_dropped", self, "_on_Player_weapon_dropped")
		__ = player.connect("weapon_switched", self, "_on_Player_weapon_switched")


func _update_health_bar(new_hp: int, max_hp:int) -> void:
	var new_health: int = int(100 * float(new_hp) / max_hp)
	var __ = health_bar_tween.interpolate_property(health_bar, "value", 
	health_bar.value, new_health, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = health_bar_tween.start()
	health_bar_text.text = str(new_hp)+"/"+str(max_hp)

func _on_Player_hp_changed(new_hp: int, max_hp:int) -> void:
	_update_health_bar(new_hp, max_hp)


func _update_mana_bar(new_mp: int, max_mp:int) -> void:
	var new_mana: int = int(100 * float(new_mp) / max_mp)
	var __ = mana_bar_tween.interpolate_property(mana_bar, "value", 
	mana_bar.value, new_mana, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = mana_bar_tween.start()
	mana_bar_text.text = str(new_mp)+"/"+str(max_mp)

func _on_Player_mp_changed(new_mp: int, max_mp:int) -> void:
	_update_mana_bar(new_mp, max_mp)

func _update_exp_bar(new_exp: int, max_exp:int) -> void:
	var new_exp_frac: int = int(100 * float(new_exp) / max_exp)
	var __ = exp_bar_tween.interpolate_property(exp_bar, "value", 
	exp_bar.value, new_exp_frac, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = exp_bar_tween.start()
	exp_bar_text.text = str(new_exp)+"/"+str(max_exp)

func _update_exp_bar_lv(level: int) -> void:
	exp_bar_level_text.text = str(level)
	
func _on_Player_exp_changed(new_exp: int, max_exp:int) -> void:
	_update_exp_bar(new_exp, max_exp)

func _on_Player_lv_changed(new_lv: int, _max_lv:int) -> void:
	_update_exp_bar_lv(new_lv)

func _on_floor_changed() -> void:
	floor_text.text = "Floor: " + str(SavedData.num_floor)
	
func _on_Player_weapon_switched(prev_index: int, new_index: int):
	inventory.get_child(prev_index).deselect()
	inventory.get_child(new_index).select()
	
func _on_Player_weapon_picked_up(weapon_texture: Texture):
	var new_item = INVENTORY_ITEM_SCENE.instance()
	inventory.add_child(new_item)
	new_item.initialize(weapon_texture)
	
func _on_Player_weapon_dropped(index: int):
	inventory.get_child(index).queue_free()
	
