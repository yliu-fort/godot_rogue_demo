extends Navigation2D

const SPAWN_ROOMS: Array = [preload("res://core/SpawnRoom1.tscn"), preload("res://core/spawnRoom0.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://core/Room0.tscn"), preload("res://core/Room1.tscn"), preload("res://core/Room2.tscn"),preload("res://core/Room3.tscn")]
const SPECIAL_ROOMS: Array = [preload("res://core/SpecialRoom0.tscn")]
const END_ROOMS: Array = [preload("res://core/EndRoom1.tscn"), preload("res://core/EndRoom0.tscn")]
const SLIME_BOSS_ROOM: PackedScene = preload("res://core/BossRoom0.tscn")

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 5
const RIGHT_WALL_TILE_INDEX = 7
const LEFT_WALL_TILE_INDEX = 6

const slime_boss_floor: int = 5

export(int) var num_levels: int = 5

onready var player: Character = get_parent().get_node("Player")


func _ready():
	SavedData.num_floor += 1
	_set_background_color()
	if SavedData.num_floor % slime_boss_floor == 0:
		num_levels = 3
	_spawn_rooms()


func _set_background_color():
	# set background color based on floor
	var grey = max(77 - pow(2, SavedData.num_floor-1), 0) / 255.0
	var color: Vector3 = Vector3(grey,grey,grey)
	if SavedData.num_floor >= 9:
		color.x += min((SavedData.num_floor - 9), 5) / 255.0
	VisualServer.set_default_clear_color(Color(color.x, color.y, color.z, 1.0))


func _spawn_rooms():
	var previous_room: Node2D
	var special_room_spawned: bool = false
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instance()
			else:
				if SavedData.num_floor % slime_boss_floor == 0:
					room = SLIME_BOSS_ROOM.instance()
					room.num_enemies_to_spawn = int(SavedData.num_floor / slime_boss_floor)
				else:
					if (randi() % 3 == 0  or i == num_levels -2) and not special_room_spawned:
						room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instance()
						special_room_spawned = true
					else:
						room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instance()
				
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
			var corridor_height: int = randi()%5+2
			for y in corridor_height:
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2,-y), LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1,-y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2( 0,-y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2( 1,-y), RIGHT_WALL_TILE_INDEX)
			
			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE


		add_child(room)
		previous_room = room
