extends CanvasLayer


onready var ability_icon = $AbilityIcon
onready var tween = $Tween


func recharge_ability_animation(time: float):
	var __ = tween.interpolate_property(ability_icon, "value", 100, 0, time)
	assert(__)
	__ = tween.start()
	assert(__)
