@tool class_name CameraController extends Node3D


# Property to activate or deactivate the movement
@export var _isEnabled : bool = true

func set_IsEnabled(value : bool) -> void :
	_isEnabled = value

func get_IsEnebled() -> bool :
	return _isEnabled

# =============================================== ENUMS =====================================================

# Different Camera's Modes
enum CAMERA_MODE {
	## Basic CAMERA_MODE points forward no movement possible
	STATIC,
	## Third person CAMERA_MODE points forward and Yaw axis Spring-arm angle rotation enabled
	THIRD_PERSON,
	## Third person zoomed CAMERA_MODE points forward and Yaw axis Spring-arm angle rotation enabled and also zoom
	THIRD_PERSON_ZOOM,
	## First Person CAMERA_MODE points forward and Yaw and Pitch axis Spring-arm angle rotation enabled, you must configurer zoomInitialValue and the ymovementInitialValue, xmovementInitialValue appropriately to the character to actue as a first person camera, you should change this mode from any other and viceversa, this mode is only thought for first person characters
	FIRST_PERSON,
	## Full CAMERA_MODE points forward, every possible camera's movement and rotation enabled
	FULL
}


enum CAMERA_MOVEMENT {
	##Yaw-axis Spring-arm angle rotation movement
	YROTATION,
	##Pitch-axis Spring-arm angle rotation movement
	XROTATION,
	##Vertical Camera movement
	YMOVEMENT,
	##Horizontal Camera movement
	XMOVEMENT,
	##Yaw-axis Camera angle rotation movement
	YCAMERAROTATION,
	##Yaw-axis Camera angle rotation movement
	XCAMERAROTATION,
	##Spring-arm length change movement
	ZOOM
}


# ==================================  EXPORTED VARIABLES ===================================================


# CameraController script, it has also the camera movement
# rotating left right and up down of camera controller by moving mouse
# travelling with rolling of the wheel button
# up-down left-right camera movement and rotating left right and up down of camera
# every movement except yaw's rotations clamped

# Usage mode of the CameraController
@export_group("Camera Mode Preset")

##Camera mode selection
@export var cameraMode : CAMERA_MODE = CAMERA_MODE.FULL:
	set(value):
		cameraMode = value
		notify_property_list_changed()

##Camera mode transition's time in frames 
@export_range (1,100) var modeTransitionsNumFrames : int = 60


# Initial values for the different movements it is the fixed value when disabled
@export_group("Initial Values Preset")

##Indicates if the camera must rotate to position behind the character/pawn when activeted
@export var yrotationBehind : Dictionary[CAMERA_MODE,bool]

##Indicates if the camera must move in the x-axis with the parent (default option). Only affects to cameraMode STATIC
@export var xmovementWithParent : Dictionary[CAMERA_MODE,bool] :
	set (value):
		xmovementWithParent = value
		notify_property_list_changed()

##Margin in which there is no camera x movement following the parent. Only affects to cameraMode STATIC
@export var marginXMovement : Dictionary[CAMERA_MODE,float]

var yrotationInitialValue : float = 0.0
##Initial Value of the Y Rotation of the camera controler (Yaw axis) [Spring-arm angle]
@export_range(-180.0,180.0) var yrotationInitialValueGrad : float = 0.0 :
	set (value):
		yrotationInitialValueGrad = value
		yrotationInitialValue = value * PI / 180

var xrotationInitialValue : float = 0.0
##Initial Value of the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export_range(-90.0, 90.0) var xrotationInitialValueGrad : float = 0.0 :
	set (value):
		xrotationInitialValueGrad = value
		xrotationInitialValue = value * PI / 180

##Initial Value of the VERTICAL position of the camera
@export var ymovementInitialValue : float = 0.0

##Initial Value of the HORIZONTAL position of the camera
@export var xmovementInitialValue : float = 0.0

var ycameraRotationInitialValue : float = 0.0
##Initial Value of the Y Rotation of the camera (Yaw axis) [Camera angle]
@export_range(-180.0,180.0) var ycameraRotationInitialValueGrad : float = 0.0 :
	set (value):
		ycameraRotationInitialValueGrad = value
		ycameraRotationInitialValue = value * PI / 180

var xcameraRotationInitialValue : float = 0.0
##Initial Value of the X Rotation of the camera (Pitch axis) [Camera angle]
@export_range(-90.0,90.0) var xcameraRotationInitialValueGrad : float = 0.0 :
	set (value):
		xcameraRotationInitialValueGrad = value
		xcameraRotationInitialValue = value * PI / 180

##Initial Value of the Spring-arm length
@export var zoomInitialValue : float = 0.0

# Adjusting parameters for sensitivity of the different movements
@export_group("Camera actions sensitivity")

##Camera rotation's sensitivity
@export var rotationSensitivity : float = 0.75

##Camera zoom's sensitivity
@export var zoomSensitivity : float = 0.25

##Camera movement's sensitivity
@export var updownSensivility : float = 1.0


@export_group("Yaw axis Spring-arm angle Rotation")

##Checkbox for the Y Rotation of the camera controler (Yaw axis) [Spring-arm angle]
@export var yrotationEnabled : bool = true


@export_group("Pitch axis Spring-arm angle Rotation")

##Checkbox for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var xrotationEnabled : bool = true:
	set (value):
		xrotationEnabled = value
		notify_property_list_changed()

##Up value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var UP_CAMERA_ANGLE : int = 20

##Down value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var DOWN_CAMERA_ANGLE : int = 10


@export_group("Camera VERTICAL position")

##Checkbox for the VERTICAL position of the camera
@export var ymovementEnabled : bool = true :
	set (value):
		ymovementEnabled = value
		notify_property_list_changed()

##Up value for the VERTICAL position of the camera
@export var UP_CAMERA_HEIGHT : float = 8.0

##Down value for the VERTICAL position of the camera
@export var DOWN_CAMERA_HEIGHT : float = 1.8


@export_group("Camera HORIZONTAL position")

##Checkbox for the HORIZONTAL position of the camera
@export var xmovementEnabled : bool = true:
	set (value):
		xmovementEnabled = value
		notify_property_list_changed()

##Left value for the HORIZONTAL position of the camera
@export var LEFT_CAMERA_WIDTH : float = -8.0

##Right value for the HORIZONTAL position of the camera
@export var RIGHT_CAMERA_WIDTH : float = 8.8


@export_group("Yaw axis Camera angle Rotation")

##Checkbox for the Y Rotation of the camera (Yaw axis) [Camera angle]
@export var ycameraRotationEnabled : bool = true

##Up Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var LEFT_CAMERA3D_ANGLE : int = 20

##Down Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var RIGHT_CAMERA3D_ANGLE : int = 20

@export_group("Pitch axis Camera angle Rotation")

##Checkbox for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var xcameraRotationEnabled : bool = true :
	set (value):
		xcameraRotationEnabled = value
		notify_property_list_changed()

##Up Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var UP_CAMERA3D_ANGLE : int = 20

##Down Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var DOWN_CAMERA3D_ANGLE : int = 20


@export_group("Spring-arm zoom movement")

##Checkbox for the Spring-arm length changes
@export var zoomEnabled : bool = true:
	set (value):
		zoomEnabled = value
		notify_property_list_changed()

##Minimum value for the Spring-arm length changes
@export var MIN_ZOOM : int = 1

##Maximum value for the Spring-arm length changes
@export var MAX_ZOOM : int = 8



# ================================ INTERNAL VARIABLES ==================================================


#Getting SpringArm Component for future usage
@onready var _spring_arm : SpringArm3D = get_springarm()
@onready var _camera3D : Camera3D = get_camera3d()

# For the xmovement when the xmovement doesnt go with the parent
var _parentOffset : float = 0.0
@onready var _parentXPos :float = owner.global_position.x
@onready var _cameraXPos :float = global_position.x
var _parentXPos2 : float = 0.0

# Indicates if the middle or right button are pressed
var _middleButtonPressed : bool = false
var _rightButtonPressed : bool = false

# =======================================================================================================


# BUILT-IN METHODS ======================================================================================


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_spring_arm.queue_free()
		_camera3D.queue_free()

# Initial values setted
func _init() -> void:
	rotation.y = yrotationInitialValue
	rotation.x = xrotationInitialValue
	position.y = ymovementInitialValue
	position.x = xmovementInitialValue


func _ready() -> void:
	# The self actor is exclude and also the parent node from the spring arm
	_spring_arm.add_excluded_object(self)
	_spring_arm.add_excluded_object(get_parent())

	# Initial springArmValue must be set in the _ready() function due to have access to the SpringArmComponent
	_spring_arm.spring_length=zoomInitialValue

# In each physic process step if we dont want that the camera follows the parent
func _physics_process(_delta: float) -> void:
	# Only if it is enabled
	if _isEnabled :
		if xmovementWithParent.has(cameraMode) and not xmovementWithParent[cameraMode]:
			_parentXPos2 = get_parent().global_position.x
			_parentOffset = _parentXPos2 - _parentXPos
			_parentXPos = _parentXPos2
			_cameraXPos = global_position.x
			var marginX : float = marginXMovement[cameraMode] if marginXMovement.has(cameraMode) else 0.0
			if (_parentOffset >= 0.0 and (_cameraXPos - _parentXPos2) > -marginX) or (_parentOffset <= 0.0 and (_cameraXPos - _parentXPos2) < marginX):
				global_position.x += -_parentOffset

# Resolving inputs for the camera, cannot be configured outside
# Developer decision. Mouse movement to move the camera and middle wheel rolling button for zoom
# The unusual rotation and movements via right - middle button clicked and mouse move
func _input(event):
	# Only if it is enabled
	if _isEnabled :
		# Mouse input -> Travelling
		if event is InputEventMouseButton:
			# if cameraRotation is enabled we check if right button is pressed activating the flag
			if (xcameraRotationEnabled or ycameraRotationEnabled):
				if event.button_index==MOUSE_BUTTON_RIGHT:
					if event.is_pressed():
						_rightButtonPressed = true
					elif event.is_released():
						_rightButtonPressed = false

			# if the cameraMovement is enabled we check if right button is pressed activating the flag
			if (ymovementEnabled or xmovementEnabled):
				if event.button_index==MOUSE_BUTTON_MIDDLE:
					if event.is_pressed():
						_middleButtonPressed = true
					elif event.is_released():
						_middleButtonPressed = false

			# If Zoom is enabled we can modify the springarm length with the middle wheel
			if (zoomEnabled):
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					_spring_arm.spring_length = clamp(_spring_arm.spring_length - zoomSensitivity,MIN_ZOOM, MAX_ZOOM)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					_spring_arm.spring_length = clamp(_spring_arm.spring_length + zoomSensitivity,MIN_ZOOM, MAX_ZOOM)

		# Mouse Motion -> rotation and y-axis traslation with middle button pressed
		if event is InputEventMouseMotion:
			# if the cameraRotation or cameraMovement are enabled we can do the up&down movement and cameraRotation if the middle_ or the right_button are pressed
			if (ymovementEnabled or xmovementEnabled or xcameraRotationEnabled or ycameraRotationEnabled) :
				if _rightButtonPressed and ycameraRotationEnabled:
					_camera3D.rotation.y = clamp(_camera3D.rotation.y - event.relative.x /1000 * rotationSensitivity, -PI*LEFT_CAMERA3D_ANGLE/100, PI*RIGHT_CAMERA3D_ANGLE/100)
				if _rightButtonPressed and xcameraRotationEnabled:
					_camera3D.rotation.x = clamp(_camera3D.rotation.x - event.relative.y /1000 * rotationSensitivity, -PI*UP_CAMERA3D_ANGLE/100, PI*DOWN_CAMERA3D_ANGLE/100)

				if _middleButtonPressed and ymovementEnabled:
					position.y=clamp(position.y - event.relative.y /100 * updownSensivility, DOWN_CAMERA_HEIGHT, UP_CAMERA_HEIGHT)
				if _middleButtonPressed and xmovementEnabled  :
					position.x=clamp(position.x + event.relative.x /100 * updownSensivility, LEFT_CAMERA_WIDTH, RIGHT_CAMERA_WIDTH)

				# it neither the middle nor the right button are pressed
				if not _middleButtonPressed and not _rightButtonPressed:
					# If the rotation around armature is enables we do this rotation movement
					if (yrotationEnabled) :
						rotation.y = rotation.y - event.relative.x /1000 * rotationSensitivity
					if (xrotationEnabled) :
						rotation.x = clamp(rotation.x - event.relative.y /1000 * rotationSensitivity, -PI*UP_CAMERA_ANGLE/100, PI*DOWN_CAMERA_ANGLE/100)
			# case neither the cameraRotation nor cameraMovement are enabled abgesehen von button pressed we check for rotation around armature movement
			elif (yrotationEnabled or xrotationEnabled) :
				if (yrotationEnabled) :
					rotation.y = rotation.y - event.relative.x /1000 * rotationSensitivity
				if (xrotationEnabled) :
					rotation.x = clamp(rotation.x - event.relative.y /1000 * rotationSensitivity, -PI*UP_CAMERA_ANGLE/100, PI*DOWN_CAMERA_ANGLE/100)



# PUBLIC API of this CameraController Component =====================================================================

# Transition methods, it changes values of movement in a blend mode using corroutine
# Called inside this script the framesNum comes from an exported variable
# otherwise can be assigned independently

# The function's structure of all these function's are identical so only one function is created indicating the camera movement to be done
func doing_cameraTransition(cameraMovement : CAMERA_MOVEMENT, initialValue: float, finalValue: float, framesNum : int):
	# Only if it is enabled
	if _isEnabled:
		# if framesNum is less than 1 the movement is done and returns
		if framesNum < 1:
			rotation.y=finalValue
			return

		# The step value is calculated as 1/framesNum
		var step : float = 1.0 / framesNum as float

		# Flag to detect which is the last loop of the infinite loop to do
		var lastLoopCycle : bool = false

		# Loop until get the last value of the lerp
		while (true):
			# Once we arrive the step value 1 it means one more cycle and aus
			if (step >= 1):
				lastLoopCycle = true

			# if the Character has changed the coroutine stops
			if (get_tree() == null):
				break

			var x : float = lerp(initialValue,finalValue, step)
			match cameraMovement:
				CAMERA_MOVEMENT.YROTATION:
					rotation.y=x
				CAMERA_MOVEMENT.XROTATION:
					rotation.x=x
				CAMERA_MOVEMENT.YMOVEMENT:
					position.y=x
				CAMERA_MOVEMENT.XMOVEMENT:
					position.x=x
				CAMERA_MOVEMENT.YCAMERAROTATION:
					_camera3D.rotation.y=x
				CAMERA_MOVEMENT.XCAMERAROTATION:
					_camera3D.rotation.x=x
				CAMERA_MOVEMENT.ZOOM:
					_spring_arm.spring_length=x

			step += 1.0 / framesNum as float

			# if we are in the last loop cycle
			if lastLoopCycle:
				# Breaking the loop also is possible return statement
				break

			# Corroutine stoping function when frame's end comes
			await get_tree().process_frame	


# Function that carries out the actions when changes the cameraMode
func change_cameraMode(value : CAMERA_MODE):
	# Only if it is enabled
	if _isEnabled :
		# Assign the new cameraMode
		cameraMode = value

		# Case the CAMERA_MOVE we disable the corresponding CAMERA_MOVEMENT and do the transition
		match value:
			CAMERA_MODE.STATIC:
					yrotationEnabled=false
					xrotationEnabled=false
					ymovementEnabled=false
					xmovementEnabled=false
					ycameraRotationEnabled=false
					xcameraRotationEnabled=false
					zoomEnabled=false

					if (yrotationBehind.has(CAMERA_MODE.STATIC) and yrotationBehind[CAMERA_MODE.STATIC]):
						doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,zoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.THIRD_PERSON:
					yrotationEnabled=true
					xrotationEnabled=false
					ymovementEnabled=false
					xmovementEnabled=false
					ycameraRotationEnabled=false
					xcameraRotationEnabled=false
					zoomEnabled=false

					if (yrotationBehind.has(CAMERA_MODE.THIRD_PERSON) and yrotationBehind[CAMERA_MODE.THIRD_PERSON]):
						doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,zoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.THIRD_PERSON_ZOOM:
					yrotationEnabled=true
					xrotationEnabled=false
					ymovementEnabled=false
					xmovementEnabled=false
					ycameraRotationEnabled=false
					xcameraRotationEnabled=false
					zoomEnabled=true

					if (yrotationBehind.has(CAMERA_MODE.THIRD_PERSON_ZOOM) and yrotationBehind[CAMERA_MODE.THIRD_PERSON_ZOOM]):
						doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.FIRST_PERSON:
					yrotationEnabled=true
					xrotationEnabled=true
					ymovementEnabled=false
					xmovementEnabled=false
					ycameraRotationEnabled=false
					xcameraRotationEnabled=false
					zoomEnabled=false

					# The first person camera mode is a special movement, although the cameracontroller's rotation movement is enabled
					# it should be positioned correctly to the initial value so that the camera is point to the forward vector
					# It should be configured in the right mode modifying the InitialValues
					doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
					doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,zoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.FULL:
					yrotationEnabled=true
					xrotationEnabled=true
					ymovementEnabled=true
					xmovementEnabled=true
					zoomEnabled=true
					ycameraRotationEnabled=true
					xcameraRotationEnabled=true

					if (yrotationBehind.has(CAMERA_MODE.FULL) and yrotationBehind[CAMERA_MODE.FULL]):
						doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)

# Gets the camera controller component's context for character's change
func get_context() -> CameraControllerData :
	# Only if it is enabled
	if _isEnabled :
		var context = CameraControllerData.new()
		context.cameraControllerRotation = rotation
		context.cameraControllerPosition = position
		context.cameraRotation = get_node("SpringArm3D/Camera3D").rotation
		context.cameraPosition = get_node("SpringArm3D/Camera3D").position
		context.cameraControllerSpringArmRotation = get_node("SpringArm3D").rotation
		context.cameraControllerSpringArmPosition = get_node("SpringArm3D").position
		context.cameraControllerSpringArmLength = get_node("SpringArm3D").spring_length

		context.cameraControllerYRotationEnabled = yrotationEnabled
		context.cameraControllerXRotationEnabled = xrotationEnabled
		context.cameraYRotationEnabled = ycameraRotationEnabled
		context.cameraXRotationEnabled = xcameraRotationEnabled
		context.cameraControllerYMovementEnabled = ymovementEnabled
		context.cameraControllerXMovementEnabled = xmovementEnabled
		context.cameraControllerZoomEnabled = zoomEnabled

		context.cameraControllerMode = cameraMode

		return context
	return null


# Sets the camera controller component's context for character's
func set_context(context : CameraControllerData) -> void:
	# Only if it is enabled
	if _isEnabled :
		rotation = context.cameraControllerRotation
		position = context.cameraControllerPosition
		get_node("SpringArm3D/Camera3D").rotation = context.cameraRotation
		get_node("SpringArm3D/Camera3D").position = context.cameraPosition
		get_node("SpringArm3D").rotation = context.cameraControllerSpringArmRotation
		get_node("SpringArm3D").position = context.cameraControllerSpringArmPosition
		get_node("SpringArm3D").spring_length = context.cameraControllerSpringArmLength

		yrotationEnabled = context.cameraControllerYRotationEnabled
		xrotationEnabled = context.cameraControllerXRotationEnabled
		ycameraRotationEnabled = context.cameraYRotationEnabled
		xcameraRotationEnabled = context.cameraXRotationEnabled
		ymovementEnabled = context.cameraControllerYMovementEnabled
		xmovementEnabled = context.cameraControllerXMovementEnabled
		zoomEnabled = context.cameraControllerZoomEnabled

		change_cameraMode(context.cameraControllerMode)


# Getters and setters methods
func get_springarm() -> SpringArm3D:
	return get_node("SpringArm3D") as SpringArm3D
	
func get_camera3d() -> Camera3D:
	return get_node("SpringArm3D/Camera3D") as Camera3D

func get_middleButtonPressed() -> bool:
	return _middleButtonPressed

func get_rightButtonPressed() -> bool:
	return _rightButtonPressed

func set_middleButtonPressed( value : bool):
	_middleButtonPressed = value

func set_rightButtonPressed( value : bool):
	_rightButtonPressed = value



# This function is used so that the editor's options can be adapted to the cameraMode selected
# It works with @tool, with the setter method in the variables that can affect others where the call
# to the event properties_changed are called
# Basically disables in the editor the options not able to be configured in a specific cameraMode
# Also if a camera movement is explicitly disabled it hides the range associated to this option
func _validate_property(property: Dictionary):

	# Only in FULL mode. X,Y MOVEMENT & X,Y CAMERAROTATION
	if property.name in ["ymovementEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["xmovementEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["ycameraRotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["xcameraRotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

	# Options in all modes except STATIC. YROTATION
	if property.name in ["yrotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

	# Options in FIRST_PERSON and FULL mode. XROTATION
	if property.name in ["xrotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	
	# Options in FULL and ZOOMED mode. ZOOM
	if property.name in ["zoomEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR



	# Secundary Options of enabled movements
	if property.name in ["UP_CAMERA_ANGLE"] and ( xrotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA_ANGLE"] and ( xrotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["UP_CAMERA_HEIGHT"] and ( ymovementEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA_HEIGHT"] and ( ymovementEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["LEFT_CAMERA_WIDTH"] and ( xmovementEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["RIGHT_CAMERA_WIDTH"] and ( xmovementEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["UP_CAMERA3D_ANGLE"] and ( xcameraRotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA3D_ANGLE"] and ( xcameraRotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["LEFT_CAMERA3D_ANGLE"] and ( xcameraRotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["RIGHT_CAMERA3D_ANGLE"] and ( xcameraRotationEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.THIRD_PERSON_ZOOM or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["MIN_ZOOM"] and ( zoomEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["MAX_ZOOM"] and ( zoomEnabled == false or ( cameraMode == CAMERA_MODE.STATIC or cameraMode == CAMERA_MODE.THIRD_PERSON or cameraMode == CAMERA_MODE.FIRST_PERSON )):
		property.usage = PROPERTY_USAGE_NO_EDITOR
