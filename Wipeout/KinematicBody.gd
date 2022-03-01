extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed 
var default_move_speed = 10
#Sens - 0.03
var mouse_sensitivity = 0.15
var h_acceleration = 4
var gravity = 20
var jump = 10
var air_acceleration = 1 
var normal_acceleration = 6 
var full_contact = false
var crouch_move_speed = 2
var crouch_speed = 10
var default_height = 1.5
var crouch_height = .1


#Physics
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()





onready var head = $Head
onready var ground_check = $GroundCheck
onready var pcap = $CollisionShape


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.window_fullscreen = true
	if Input.is_action_pressed("escape"):
		OS.window_fullscreen = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _input(event):
	if event is InputEventMouseMotion: 
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	
	if Input.is_action_pressed("escape"):
		OS.window_fullscreen = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _physics_process(delta):
	
	#Jumping and Physics
	
	speed = default_move_speed
	
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	 
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()	
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		
			gravity_vec = Vector3.UP * jump
			
			
	
	
		
	#Crouching and Sprinting
	
	if Input.is_action_pressed("run"):
		speed = 20
		
	elif not Input.is_action_pressed("run"):
		speed = 10
	if Input.is_action_pressed("crouch"):
		pcap.shape.height -= crouch_speed * delta	
		speed = crouch_move_speed	
	else:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)	
		
	
	#Movement
		
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	
	
		
	
	
	
	
	#direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
