extends CanvasLayer

const INVENTORY_ITEM_SCENE: PackedScene = preload("res://ui/InventoryItem.tscn")

onready var player: Character = get_parent().get_node("Player")
onready var health_bar = $HealthBar
onready var health_bar_tween = $HealthBar/Tween
onready var health_bar_text = $HealthBar/Label
onready var floor_text = $Floor
onready var inventory: HBoxContainer = $PanelContainer/Inventory


func _ready():
	if player:
		player.connect("hp_changed", self, "_on_Player_hp_changed")
		_update_health_bar(player.hp, player.max_hp)
		SavedData.connect("floor_changed", self, "_on_floor_changed")
		player.connect("weapon_picked_up", self, "_on_Player_weapon_picked_up")
		player.connect("weapon_dropped", self, "_on_Player_weapon_dropped")
		player.connect("weapon_switched", self, "_on_Player_weapon_switched")


func _update_health_bar(new_hp: int, max_hp:int) -> void:
	var new_health: int = int(100 * float(new_hp) / max_hp)
	var __ = health_bar_tween.interpolate_property(health_bar, "value", 
	health_bar.value, new_health, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = health_bar_tween.start()
	health_bar_text.text = str(new_hp)+"/"+str(max_hp)


func _on_Player_hp_changed(new_hp: int, max_hp:int) -> void:
	_update_health_bar(new_hp, max_hp)
	
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
	
