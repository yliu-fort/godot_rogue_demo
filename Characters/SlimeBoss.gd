extends Enemy

onready var hitbox = $Hitbox
export(int) var scale_all = 8  # when place into the scene manually, set scale_all to 8
export(bool) var scaled = false # when place into the scene manually, set scaled to false

export(int) var mass_coeff = 1
export(int) var hp_coeff = 1
export(int) var speed_coeff = 20
export(int) var knockback_force_coeff = 50

func duplicate_slime():
	if scale_all > 1:
		var impulse_direction: Vector2
		for __ in 2:
			impulse_direction = Vector2.RIGHT.rotated(rand_range(0, 2*PI))
			_spawn_slime(impulse_direction)
			_spawn_slime(impulse_direction * -1)


func _ready():
	_scale_slime()

func _process(_delta):
	hitbox.knockback_direction = velocity.normalized()

func _scale_slime():
	if not scaled:
		scaled = true
		for sp in self.get_children():
			if sp.has_method("get_scale"):
				sp.scale *= scale_all
		mass = scale_all * mass_coeff
		hitbox.knockback_force = scale_all * knockback_force_coeff
		hitbox.damage = scale_all * atk
		max_hp *= scale_all
		hp *= scale_all
		max_speed = scale_all * speed_coeff


func _spawn_slime(direction: Vector2):
	var slime = load("res://Characters/SlimeBoss.tscn").instance()
	var __ = slime.connect("tree_entered", get_parent(), "_on_enemy_summoned")
	__ = slime.connect("tree_exited", get_parent(), "_on_enemy_killed")
	slime.position = position
	slime.scale_all = scale_all / 2
	slime.scaled = false
	slime.lv = lv
	get_parent().add_child(slime)
	slime.velocity += direction * 150


