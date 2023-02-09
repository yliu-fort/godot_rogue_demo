extends FiniteStateMachine


func _init() -> void:
	_add_state("idle")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	pass

func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	pass
	
func _exit_state(_state_exited: int) -> void:
	pass
