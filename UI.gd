extends CanvasLayer

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var health_bar = $HealthBar
onready var health_bar_tween = $HealthBar/Tween
onready var health_bar_text = $HealthBar/Label


func _ready():
	# wait a single idle frame so all nodes have a chance to set themselves up
	#yield(get_tree(), "idle_frame")
	#player = get_tree().get_nodes_in_group("player")[0]
	
	# if you want to connect to all ground nodes:
	#for ground_node in possible_ground_nodes:
	#	ground_node.connect("body_entered", self, "_on_Ground_body_entered")
	
	# if you just want to connect to the first ground node
	if player:
		player.connect("hp_changed", self, "_on_Player_hp_changed")
		_update_health_bar(player.hp, player.max_hp)


func _update_health_bar(new_hp: int, max_hp:int) -> void:
	var new_health: int = int(100 * float(new_hp) / max_hp)
	var __ = health_bar_tween.interpolate_property(health_bar, "value", 
	health_bar.value, new_health, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = health_bar_tween.start()
	health_bar_text.text = str(new_hp)+"/"+str(max_hp)


func _on_Player_hp_changed(new_hp: int, max_hp:int) -> void:
	_update_health_bar(new_hp, max_hp)
