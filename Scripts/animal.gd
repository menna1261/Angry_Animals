extends RigidBody2D


@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
enum ANIMAL_STATE {READY , DRAG , RELEASE}
@onready var stretch = $AudioStreamPlayer2D
@onready var arrow = $arrow
@onready var launching = $launching
@onready var kick = $launching2

#the initial state we are going to start with
var _state : ANIMAL_STATE = ANIMAL_STATE.READY
const max_lim = Vector2(0,60)
const min_lim = Vector2(-60,0)
var arrow_scale_x = 0.0
var last_collision_count : int = 0

var _start = Vector2.ZERO
var _draged_vector = Vector2.ZERO
var _drag_start = Vector2.ZERO
var last_draged_vector = Vector2.ZERO

const impulse_multiply = 20.0
const impulse_max = 1200.0

func _set_animal_state(new_state : ANIMAL_STATE):
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE : 
		arrow.hide()
		freeze = false
		apply_central_impulse(get_impulse())
		launching.play()
		SignalManager.on_attempt_made.emit()
	elif _state ==ANIMAL_STATE.DRAG:
		arrow.show()
		_drag_start = get_global_mouse_position()

func scale_arrow():
	var imp_len = get_impulse().length()
	var perc = imp_len / impulse_max
	arrow.scale.x = (arrow_scale_x * perc)+arrow_scale_x
	arrow.rotation = (_start - position).angle()

func play_stretch_sound ():
	if(last_draged_vector-_draged_vector).length()>0:
		if stretch.playing == false:
			stretch.play()
	
func get_dragged_vector(gmp) :
	return gmp- _drag_start

func _drag_in_limits():
	last_draged_vector = _draged_vector
	_draged_vector.x = clampf(
		_draged_vector.x,
		min_lim.x,
		max_lim.x
	)
	_draged_vector.y = clampf(
		_draged_vector.y,
		min_lim.y,
		max_lim.y
	)
	position = _start + _draged_vector

func _update(delta : float):
	match _state:
		ANIMAL_STATE.DRAG:
			_update_drag()
		ANIMAL_STATE.RELEASE:
			update_flight()
	
func play_collision():
	if (last_collision_count == 0 and get_contact_count() >0
	and kick.playing == false):
		kick.play()
	
	last_collision_count = get_contact_count()	
func update_flight():
	play_collision()


func _ready():
	arrow_scale_x = arrow.scale.x
	_start = position
	arrow.hide()

func _physics_process(delta):
	_update(delta)

func get_impulse():
	return _draged_vector * -1 * impulse_multiply

func _die() :
	SignalManager.on_animal_died.emit()
	queue_free()
	
func _release_detection()->bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			_set_animal_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func _on_visible_on_screen_notifier_2d_screen_exited():
	_die()

func _update_drag():
	if _release_detection() == true :
		return
	var gmp  = get_global_mouse_position()
	_draged_vector = get_dragged_vector(Vector2(gmp))
	play_stretch_sound()
	_drag_in_limits()
	scale_arrow()
	

func _on_input_event(viewport, event, shape_idx):
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"):
		_set_animal_state(ANIMAL_STATE.DRAG)


func _on_sleeping_state_changed():
	if sleeping == true:
		var cb = get_colliding_bodies()
		if cb.size() > 0 :
			cb[0]._die()
		call_deferred("_die")
		
		
