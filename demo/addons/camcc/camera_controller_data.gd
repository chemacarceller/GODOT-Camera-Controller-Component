class_name CameraControllerData extends Node

# Camera Controller Data
var cameraControllerRotation : Vector3 = Vector3.ZERO
var cameraControllerPosition : Vector3 = Vector3.ZERO
var cameraPosition : Vector3 = Vector3.ZERO
var cameraRotation : Vector3 = Vector3.ZERO
var cameraControllerSpringArmPosition : Vector3 = Vector3.ZERO
var cameraControllerSpringArmRotation : Vector3 = Vector3.ZERO
var cameraControllerSpringArmLength : float = 0.0


# Camera Controller enabled features
var cameraControllerYRotationEnabled : bool = true
var cameraControllerXRotationEnabled : bool = true
var cameraYRotationEnabled : bool = true
var cameraXRotationEnabled : bool = true
var cameraControllerYMovementEnabled : bool = true
var cameraControllerXMovementEnabled : bool = true
var cameraControllerZoomEnabled : bool = true

# Camera Controller Mode
var cameraControllerMode : CameraController.CAMERA_MODE = CameraController.CAMERA_MODE.FULL
