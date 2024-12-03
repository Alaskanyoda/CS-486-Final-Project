extends CharacterBody3D

enum playerStates {
	IDLE,
	HEAVYATT,
	ATT_0_1,
	ATT_1_END,
	ATT_1_2,
	ATT_2_END,
	ATT_2_3_END,
	BLOCK_START,
	BLOCKING,
	BLOCK_END,
	DEAD
}

@onready var player = get_node(".")

var state = playerStates.IDLE
@onready var PlayerAP = $playerRiggedWithWeapons/AnimationPlayer
@onready var rootNode = get_node('/root/Game')
@export var Damage = 0
@export var Blocking = false
var startTime = Time.get_unix_time_from_system()
var timeStampBlocking = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var sensitivity = 200
var input_dir := Vector3(0, 0, 0)


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("boss", "update_target_location", player.global_transform.origin)
	match state:
		playerStates.IDLE:
			Damage = 0
			rootNode.spear_damage_set(true)
			if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not(PlayerAP.is_playing())):
				if(Input.is_key_pressed(KEY_SHIFT)):
					state = playerStates.HEAVYATT
					Damage = 20
					rootNode.spear_damage_set(false)
					PlayerAP.queue("heavyattack")
				else:
					state = playerStates.ATT_0_1
					Damage = 5
					rootNode.spear_damage_set(false)
					PlayerAP.queue("Swing0-1")
			if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not(PlayerAP.is_playing())):
				state = playerStates.BLOCK_START
				PlayerAP.queue("BlockStart")
		playerStates.ATT_0_1:
			if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not(PlayerAP.is_playing())):
				PlayerAP.queue("Swing1-2")
				Damage = 5
				rootNode.spear_damage_set(false)
				state = playerStates.ATT_1_2
			else:
				if(not(PlayerAP.is_playing())):
					PlayerAP.queue("Swing1-end")
					Damage = 0
					rootNode.spear_damage_set(true)
					state = playerStates.ATT_1_END
		playerStates.ATT_1_END:
			if(not(PlayerAP.is_playing())):
				state = playerStates.IDLE
		playerStates.ATT_1_2:
			if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not(PlayerAP.is_playing())):
				PlayerAP.queue("Swing2-3-end")
				Damage = 7
				rootNode.spear_damage_set(false)
				state = playerStates.ATT_2_3_END
			else:
				if(not(PlayerAP.is_playing())):
					PlayerAP.queue("Swing2-end")
					Damage = 0
					rootNode.spear_damage_set(true)
					state = playerStates.ATT_1_END
		playerStates.ATT_2_END:
			if(not(PlayerAP.is_playing())):
				state = playerStates.IDLE
		playerStates.ATT_2_3_END:
			if(not(PlayerAP.is_playing())):
				state = playerStates.IDLE
			if (PlayerAP.current_animation_position > 0.0 and PlayerAP.current_animation_position < 1.2):
				Damage = 7
			else:
				Damage = 0
		playerStates.BLOCK_START:
			timeStampBlocking = Time.get_unix_time_from_system()
			state = playerStates.BLOCKING
		playerStates.BLOCKING:
			Blocking = true
			if(not(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))):
				PlayerAP.queue("BlockEnd")
				Blocking = false
				state = playerStates.BLOCK_END
		playerStates.BLOCK_END:
			if(not(PlayerAP.is_playing())):
				state = playerStates.IDLE
		playerStates.DEAD:
			pass
		playerStates.HEAVYATT:
			if(not(PlayerAP.is_playing())):
				state = playerStates.IDLE
			if (PlayerAP.current_animation_position <= 2.6):
				rootNode.spear_damage_set(false)
			if (PlayerAP.current_animation_position >= 2.6 and PlayerAP.current_animation_position < 3.6):
				Damage = 20
			else:
				Damage = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if (is_on_floor()):
		input_dir = Vector3(0, 0, 0)
		if (Input.is_physical_key_pressed(KEY_A)):
			input_dir.x -= 1
		if (Input.is_physical_key_pressed(KEY_D)):
			input_dir.x += 1
		if (Input.is_physical_key_pressed(KEY_W)):
			input_dir.y -= 1
		if (Input.is_physical_key_pressed(KEY_S)):
			input_dir.y += 1
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensitivity
		$CameraNode.rotation.x -= event.relative.y / sensitivity
		$CameraNode.rotation.x = clamp($CameraNode.rotation.x, deg_to_rad(-45), deg_to_rad(35))
