extends Node2D

var dam_text = ""
var text_color = Color(1,1,1,1)

func randomize_position_and_size():
	position += Vector2(rand_range(-8, 8), rand_range(-8, 8))
	
func _ready():
	randomize_position_and_size()
	$Node2D/Label.text = dam_text
	$Node2D/Label.add_color_override("font_color", text_color)
	$Node2D/AnimationPlayer.play("animation")
