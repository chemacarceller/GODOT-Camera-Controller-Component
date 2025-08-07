extends CharacterBody3D

@export var movementComponent : PackedScene

var _movementComponent : Node = null

func _ready() -> void:
	_movementComponent = movementComponent.instantiate()
	
	# Movement Component Configuration
	_movementComponent.leftInput="ui_left"
	_movementComponent.rightInput="ui_right"
	_movementComponent.frontInput="ui_up"
	_movementComponent.rearInput="ui_down"
	_movementComponent.jumpInput="ui_select"
	
	_movementComponent.armature = $Armature
	_movementComponent.directionalObject = $CameraController
	
	add_child(_movementComponent)

func _input(_event: InputEvent) -> void:

	# If move_run action changes, the runing variable of the movement modified
	if Input.is_action_pressed("move_run_change"):
		_movementComponent.set_isRuning(not _movementComponent.get_isRuning())
	elif Input.is_action_pressed("move_run_continuos"):
		_movementComponent.set_isRuning(true)
	elif Input.is_action_just_released("move_run_continuos"):
		_movementComponent.set_isRuning(false)


# Getter and setter
func get_movementComponent() -> Node :
	return _movementComponent

func set_movementComponent(value : Node):
	_movementComponent = value
