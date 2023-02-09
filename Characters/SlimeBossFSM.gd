extends FiniteStateMachine

var can_jump = false

onready var path_timer = parent.get_node("PathTimer")
onready var jump_timer = parent.get_node("JumpTimer")

func _init():
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")


func _ready():
	set_state(states.idle)
	

func _state_logic(_delta):
	if state == states.jump:
		parent.chase()
		parent.move()

func _get_transition():
	match state:
		states.idle:
			if can_jump:
				return states.jump
		states.jump:
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1


func _enter_state(_previous_state, new_state):
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.jump:
			path_timer.stop()
			animation_player.play("jump")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")


func _exit_state(state_exited):
	if state_exited == states.jump:
		can_jump = false
		path_timer.start()
		jump_timer.start()


func _on_JumpTimer_timeout():
	can_jump = true
