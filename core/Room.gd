extends Node2D

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://effects/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Characters/FlyingCreature.tscn")
}

const TILE_SIZE: int = 16
export(int) var num_enemies_to_spawn: int = 10
var num_enemies: int
var num_spawnpoints: int

onready var tilemap: TileMap = $TileMap2
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetecter")


func _ready():
	num_spawnpoints = enemy_positions_container.get_child_count()
	
	if num_spawnpoints == 0:
		num_enemies = 0
	else:
		num_enemies = num_enemies_to_spawn


func _on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
		_open_entrance()


func _open_doors():
	for door in door_container.get_children():
		door.open()

func _close_entrance():
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 3)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+Vector2.DOWN, 4)
		
func _open_entrance():
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), -1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position)+Vector2.DOWN, -1)
		
func _spawn_enemies():
	for enemy_i in num_enemies_to_spawn:
		var disturb_position = Vector2(randf()-0.5, randf()-0.5)
		var enemy_position = enemy_positions_container.get_children()[enemy_i % num_spawnpoints]
		var enemy: KinematicBody2D = ENEMY_SCENES.FLYING_CREATURE.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.global_position = enemy_position.position + disturb_position*TILE_SIZE
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.global_position = enemy_position.position + disturb_position*TILE_SIZE
		call_deferred("add_child", spawn_explosion)
		
		yield(get_tree().create_timer(0.01), "timeout")


func _on_PlayerDetecter_body_entered(_body: KinematicBody2D):
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_open_doors()
