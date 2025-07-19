@tool class_name CameraController extends Node3D


# Property to activate or deactivate the controller component
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
	##Vertical CameraController movement
	YMOVEMENT,
	##Horizontal CameraController movement
	XMOVEMENT,
	##Yaw-axis Camera angle rotation movement
	YCAMERAROTATION,
	##Yaw-axis Camera angle rotation movement
	XCAMERAROTATION,
	##Yaw-axis Camera Y movement
	ZOOM
}

# Enable / Disable Status of each movement

# Checkbox for the Y Rotation of the camera controler (Yaw axis) [Spring-arm angle]
var _yrotationEnabled : bool = true
# Checkbox for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
var _xrotationEnabled : bool = true
# Checkbox for the VERTICAL position of the camera
var _ymovementEnabled : bool = true
# Checkbox for the HORIZONTAL position of the camera
var _xmovementEnabled : bool = true
# Checkbox for the Y Rotation of the camera (Yaw axis) [Camera angle]
var _ycameraRotationEnabled : bool = true
# Checkbox for the X Rotation of the camera (Pitch axis) [Camera angle]
var _xcameraRotationEnabled : bool = true 
# Checkbox for the Spring-arm length changes
var _zoomEnabled : bool = true

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
		match cameraMode:
			CAMERA_MODE.STATIC:
					_yrotationEnabled=false
					_xrotationEnabled=false
					_ymovementEnabled=false
					_xmovementEnabled=false
					_ycameraRotationEnabled=false
					_xcameraRotationEnabled=false
					_zoomEnabled=false
			CAMERA_MODE.THIRD_PERSON:
					_yrotationEnabled=true
					_xrotationEnabled=false
					_ymovementEnabled=false
					_xmovementEnabled=false
					_ycameraRotationEnabled=false
					_xcameraRotationEnabled=false
					_zoomEnabled=false
			CAMERA_MODE.THIRD_PERSON_ZOOM:
					_yrotationEnabled=true
					_xrotationEnabled=false
					_ymovementEnabled=false
					_xmovementEnabled=false
					_ycameraRotationEnabled=false
					_xcameraRotationEnabled=false
					_zoomEnabled=true
			CAMERA_MODE.FIRST_PERSON:
					_yrotationEnabled=true
					_xrotationEnabled=true
					_ymovementEnabled=false
					_xmovementEnabled=false
					_ycameraRotationEnabled=false
					_xcameraRotationEnabled=false
					_zoomEnabled=false
			CAMERA_MODE.FULL:
					_yrotationEnabled=true
					_xrotationEnabled=true
					_ymovementEnabled=true
					_xmovementEnabled=true
					_zoomEnabled=true
					_ycameraRotationEnabled=true
					_xcameraRotationEnabled=true
		notify_property_list_changed()

##Camera mode transition's time in frames 
@export_range (1,100) var modeTransitionsNumFrames : int = 60



# Initial values for the different movements it is the fixed value when disabled
# All the modes share the same initial values
# For zoom parameter there is a parameter for First person which is negative or the others which is positive
@export_group("Initial Values Preset")

##Indicates if the camera must rotate to position behind the character/pawn when activeted
@export var yrotationBehind : Dictionary[CAMERA_MODE,bool]

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

##Initial Value of the Spring-arm length. First Person has a negative range
@export_range(0,10) var zoomInitialValue : float = 0.0
@export_range(-10,0) var fpZoomInitialValue : float = 0.0




# Adjusting parameters for sensitivity of the different movements
@export_group("Camera actions sensitivity")

##Camera rotation's sensitivity
@export var rotationSensitivity : float = 0.75

##Camera zoom's sensitivity
@export var zoomSensitivity : float = 0.25

##Camera movement's sensitivity
@export var updownSensivility : float = 1.0



@export_group("Yaw axis Spring-arm angle Rotation")

##Up value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var LEFT_CAMERA_ANGLE : int = 180

##Down value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var RIGHT_CAMERA_ANGLE : int = 180



@export_group("Pitch axis Spring-arm angle Rotation")

##Up value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var UP_CAMERA_ANGLE : int = 20

##Down value for the X Rotation of the camera controler (Pitch axis) [Spring-arm angle]
@export var DOWN_CAMERA_ANGLE : int = 10



@export_group("Camera VERTICAL position")

##Up value for the VERTICAL position of the camera
@export var UP_CAMERA_HEIGHT : float = 8.0

##Down value for the VERTICAL position of the camera
@export var DOWN_CAMERA_HEIGHT : float = 1.8



@export_group("Camera HORIZONTAL position")

##Left value for the HORIZONTAL position of the camera
@export var LEFT_CAMERA_WIDTH : float = -8.0

##Right value for the HORIZONTAL position of the camera
@export var RIGHT_CAMERA_WIDTH : float = 8.8



@export_group("Yaw axis Camera angle Rotation")

##Up Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var LEFT_CAMERA3D_ANGLE : int = 20

##Down Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var RIGHT_CAMERA3D_ANGLE : int = 20




@export_group("Pitch axis Camera angle Rotation")

##Up Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var UP_CAMERA3D_ANGLE : int = 20

##Down Value for the X Rotation of the camera (Pitch axis) [Camera angle]
@export var DOWN_CAMERA3D_ANGLE : int = 20



@export_group("Spring-arm zoom movement")

##Minimum value for the Spring-arm length changes
@export var MIN_ZOOM : int = 1

##Maximum value for the Spring-arm length changes
@export var MAX_ZOOM : int = 8



# ================================ INTERNAL VARIABLES ==================================================

#Getting SpringArm Component for future usage
@onready var _spring_arm : SpringArm3D = get_springarm()
@onready var _camera3D : Camera3D = get_camera3d()

# Indicates if the middle or right button are pressed
var _middleButtonPressed : bool = false
var _rightButtonPressed : bool = false

# =======================================================================================================


# BUILT-IN METHODS ======================================================================================


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_spring_arm.queue_free()
		_camera3D.queue_free()

func _ready() -> void:
	# Fixing the camera controller from its initial values
	# The position and rotation is of the root component 
	# Rotation so that the component can be assigned as the directionalObject of a movement component and not the springarm
	position.y = ymovementInitialValue
	position.x = xmovementInitialValue
	rotation.y = yrotationInitialValue
	rotation.x = xrotationInitialValue
	_camera3D.rotation.y = ycameraRotationInitialValue
	_camera3D.rotation.x = xcameraRotationInitialValue
	
	# The self actor is exclude and also the parent node from the spring arm
	_spring_arm.add_excluded_object(self)
	_spring_arm.add_excluded_object(get_parent())

	# Initial springArmValue must be set in the _ready() function due to have access to the SpringArmComponent
	if cameraMode == CAMERA_MODE.FIRST_PERSON:
		_spring_arm.spring_length=fpZoomInitialValue
	else:
		_spring_arm.spring_length=zoomInitialValue

# Resolving inputs for the camera, cannot be configured outside
# Developer decision. Mouse movement to move the camera and middle wheel rolling button for zoom
# The unusual rotation and movements via right - middle button clicked and mouse move
func _input(event):
	# Only if it is enabled
	if _isEnabled :
		# Mouse input -> Travelling
		if event is InputEventMouseButton:
			# if cameraRotation is enabled we check if right button is pressed activating the flag
			if (_xcameraRotationEnabled or _ycameraRotationEnabled):
				if event.button_index==MOUSE_BUTTON_RIGHT:
					if event.is_pressed():
						_rightButtonPressed = true
					elif event.is_released():
						_rightButtonPressed = false

			# if the cameraMovement is enabled we check if right button is pressed activating the flag
			if (_ymovementEnabled or _xmovementEnabled):
				if event.button_index==MOUSE_BUTTON_MIDDLE:
					if event.is_pressed():
						_middleButtonPressed = true
					elif event.is_released():
						_middleButtonPressed = false

			# If Zoom is enabled we can modify the springarm length with the middle wheel
			if (_zoomEnabled):
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					_spring_arm.spring_length = clamp(_spring_arm.spring_length - zoomSensitivity,MIN_ZOOM, MAX_ZOOM)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					_spring_arm.spring_length = clamp(_spring_arm.spring_length + zoomSensitivity,MIN_ZOOM, MAX_ZOOM)

		# Mouse Motion -> rotation and y-axis traslation with middle button pressed
		if event is InputEventMouseMotion:
			# if the cameraRotation or cameraMovement are enabled we can do the up&down movement and cameraRotation if the middle_ or the right_button are pressed
			if (_ymovementEnabled or _xmovementEnabled or _xcameraRotationEnabled or _ycameraRotationEnabled) :
				if _rightButtonPressed and _ycameraRotationEnabled:
					_camera3D.rotation.y = clamp(_camera3D.rotation.y - event.relative.x /1000 * rotationSensitivity, -PI*LEFT_CAMERA3D_ANGLE/100, PI*RIGHT_CAMERA3D_ANGLE/100)
				if _rightButtonPressed and _xcameraRotationEnabled:
					_camera3D.rotation.x = clamp(_camera3D.rotation.x - event.relative.y /1000 * rotationSensitivity, -PI*UP_CAMERA3D_ANGLE/100, PI*DOWN_CAMERA3D_ANGLE/100)

				if _middleButtonPressed and _ymovementEnabled:
					position.y=clamp(position.y - event.relative.y /100 * updownSensivility, DOWN_CAMERA_HEIGHT, UP_CAMERA_HEIGHT)
				if _middleButtonPressed and _xmovementEnabled  :
					position.x=clamp(position.x + event.relative.x /100 * updownSensivility, LEFT_CAMERA_WIDTH, RIGHT_CAMERA_WIDTH)

				# it neither the middle nor the right button are pressed
				if not _middleButtonPressed and not _rightButtonPressed:
					# If the rotation around armature is enables we do this rotation movement
					if (_yrotationEnabled) :
						rotation.y = clamp(rotation.y - event.relative.x /1000 * rotationSensitivity, -PI*LEFT_CAMERA_ANGLE/100, PI*RIGHT_CAMERA_ANGLE/100)
					if (_xrotationEnabled) :
						rotation.x = clamp(rotation.x - event.relative.y /1000 * rotationSensitivity, -PI*UP_CAMERA_ANGLE/100, PI*DOWN_CAMERA_ANGLE/100)
			# case neither the cameraRotation nor cameraMovement are enabled abgesehen von button pressed we check for rotation around armature movement
			elif (_yrotationEnabled or _xrotationEnabled) :
				if (_yrotationEnabled) :
					rotation.y = clamp(rotation.y - event.relative.x /1000 * rotationSensitivity, -PI*LEFT_CAMERA_ANGLE/100, PI*RIGHT_CAMERA_ANGLE/100)
				if (_xrotationEnabled) :
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
			match cameraMovement:
				CAMERA_MOVEMENT.YROTATION:
					rotation.y=finalValue
				CAMERA_MOVEMENT.XROTATION:
					rotation.x=finalValue
				CAMERA_MOVEMENT.YMOVEMENT:
					position.y=finalValue
				CAMERA_MOVEMENT.XMOVEMENT:
					position.x=finalValue
				CAMERA_MOVEMENT.YCAMERAROTATION:
					_camera3D.rotation.y=finalValue
				CAMERA_MOVEMENT.XCAMERAROTATION:
					_camera3D.rotation.x=finalValue
				CAMERA_MOVEMENT.ZOOM:
					_spring_arm.spring_length=finalValue
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
			if not is_inside_tree():
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


#========================================================================================================================================
#  PUBLIC API of the Camera Controller Component
#
# change_cameraMode -> actions to be performed whea a camera mode change is needed
# get and set context -> gets ans sets the context of a camera controller component once both characters share this component is changed
#
#========================================================================================================================================


# Function that carries out the actions when changes the cameraMode
func change_cameraMode(value : CAMERA_MODE):
	# Only if it is enabled
	if _isEnabled :
		# Assign the new cameraMode
		cameraMode = value

		# We put the initial value of the component once the movement is not enabled
		# If the movement is enabled it keeps the previous value
		# Exception with the y rotation that can be modify if the mode is in the yRotationBehind dictionary
		# But not to the initial value, it is positioned behind the character
		match value:
			CAMERA_MODE.STATIC:
				_yrotationEnabled=false
				_xrotationEnabled=false
				_ymovementEnabled=false
				_xmovementEnabled=false
				_ycameraRotationEnabled=false
				_xcameraRotationEnabled=false
				_zoomEnabled=false
				if (yrotationBehind.has(CAMERA_MODE.STATIC) and yrotationBehind[CAMERA_MODE.STATIC]):
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
				else :
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,yrotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,zoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.THIRD_PERSON:
				_yrotationEnabled=true
				_xrotationEnabled=false
				_ymovementEnabled=false
				_xmovementEnabled=false
				_ycameraRotationEnabled=false
				_xcameraRotationEnabled=false
				_zoomEnabled=false
				if (yrotationBehind.has(CAMERA_MODE.THIRD_PERSON) and yrotationBehind[CAMERA_MODE.THIRD_PERSON]):
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,zoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.THIRD_PERSON_ZOOM:
				_yrotationEnabled=true
				_xrotationEnabled=false
				_ymovementEnabled=false
				_xmovementEnabled=false
				_ycameraRotationEnabled=false
				_xcameraRotationEnabled=false
				_zoomEnabled=true
				if (yrotationBehind.has(CAMERA_MODE.THIRD_PERSON_ZOOM) and yrotationBehind[CAMERA_MODE.THIRD_PERSON_ZOOM]):
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XROTATION,rotation.x,xrotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,position.y,ymovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,position.x,xmovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.FIRST_PERSON:
				_yrotationEnabled=true
				_xrotationEnabled=true
				_ymovementEnabled=false
				_xmovementEnabled=false
				_ycameraRotationEnabled=false
				_xcameraRotationEnabled=false
				_zoomEnabled=false
				if (yrotationBehind.has(CAMERA_MODE.FIRST_PERSON) and yrotationBehind[CAMERA_MODE.FIRST_PERSON]):
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,_spring_arm.rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YMOVEMENT,_spring_arm.position.y,ymovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XMOVEMENT,_spring_arm.position.x,xmovementInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.XCAMERAROTATION,_camera3D.rotation.x,xcameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.YCAMERAROTATION,_camera3D.rotation.y,ycameraRotationInitialValue,modeTransitionsNumFrames)
				doing_cameraTransition(CAMERA_MOVEMENT.ZOOM,_spring_arm.spring_length,fpZoomInitialValue,modeTransitionsNumFrames)

			CAMERA_MODE.FULL:
				_yrotationEnabled=true
				_xrotationEnabled=true
				_ymovementEnabled=true
				_xmovementEnabled=true
				_ycameraRotationEnabled=true
				_xcameraRotationEnabled=true
				_zoomEnabled=true
				if (yrotationBehind.has(CAMERA_MODE.FULL) and yrotationBehind[CAMERA_MODE.FULL]):
					doing_cameraTransition(CAMERA_MOVEMENT.YROTATION,_spring_arm.rotation.y,get_parent().get_armature().rotation.y,modeTransitionsNumFrames)


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

		context.cameraControllerYRotationEnabled = _yrotationEnabled
		context.cameraControllerXRotationEnabled = _xrotationEnabled
		context.cameraYRotationEnabled = _ycameraRotationEnabled
		context.cameraXRotationEnabled = _xcameraRotationEnabled
		context.cameraControllerYMovementEnabled = _ymovementEnabled
		context.cameraControllerXMovementEnabled = _xmovementEnabled
		context.cameraControllerZoomEnabled = _zoomEnabled

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

		_yrotationEnabled = context.cameraControllerYRotationEnabled
		_xrotationEnabled = context.cameraControllerXRotationEnabled
		_ycameraRotationEnabled = context.cameraYRotationEnabled
		_xcameraRotationEnabled = context.cameraXRotationEnabled
		_ymovementEnabled = context.cameraControllerYMovementEnabled
		_xmovementEnabled = context.cameraControllerXMovementEnabled
		_zoomEnabled = context.cameraControllerZoomEnabled
		
		cameraMode = context.cameraControllerMode


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


	if property.name in ["zoomInitialValue"] and cameraMode == CAMERA_MODE.FIRST_PERSON:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["fpZoomInitialValue"] and cameraMode != CAMERA_MODE.FIRST_PERSON:
		property.usage = PROPERTY_USAGE_NO_EDITOR


	# Enabled options are prefixed by the camera mode
	if property.name in ["_ymovementEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_xmovementEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_ycameraRotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_xcameraRotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_yrotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_xrotationEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["_zoomEnabled"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR

	# Secundary Options of enabled movements
	if property.name in ["LEFT_CAMERA_ANGLE"] and _yrotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["RIGHT_CAMERA_ANGLE"] and _yrotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["UP_CAMERA_ANGLE"] and _xrotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA_ANGLE"] and _xrotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["UP_CAMERA_HEIGHT"] and _ymovementEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA_HEIGHT"] and _ymovementEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["LEFT_CAMERA_WIDTH"] and  _xmovementEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["RIGHT_CAMERA_WIDTH"] and _xmovementEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["UP_CAMERA3D_ANGLE"] and _xcameraRotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["DOWN_CAMERA3D_ANGLE"] and _xcameraRotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["LEFT_CAMERA3D_ANGLE"] and _xcameraRotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["RIGHT_CAMERA3D_ANGLE"] and _xcameraRotationEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["MIN_ZOOM"] and _zoomEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["MAX_ZOOM"] and _zoomEnabled == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
