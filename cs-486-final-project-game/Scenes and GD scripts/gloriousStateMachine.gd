extends Node3D

#enum playerStates {
	#IDLE,
	#HEAVYATT,
	#ATT_0_1,
	#ATT_1_END,
	#ATT_1_2,
	#ATT_2_END,
	#ATT_2_3_END,
	#BLOCK_START,
	#BLOCKING,
	#BLOCK_END,
	#DEAD
#}
#
#@onready var player = $Player3D
#
#var state = playerStates.IDLE
#@onready var PlayerAP = $Player3D/playerRiggedWithWeapons/AnimationPlayer
#var startTime = Time.get_unix_time_from_system()
#var timeStampBlocking = 0
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#get_tree().call_group("boss", "update_target_location", player.global_transform.origin)
	#match state:
		#playerStates.IDLE:
			#if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not(PlayerAP.is_playing())):
				#if(Input.is_key_pressed(KEY_SHIFT)):
					#state = playerStates.HEAVYATT
					#PlayerAP.queue("heavyattack")
				#else:
					#state = playerStates.ATT_0_1
					#PlayerAP.queue("Swing0-1")
			#if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not(PlayerAP.is_playing())):
				#state = playerStates.BLOCK_START
				#PlayerAP.queue("BlockStart")
		#playerStates.ATT_0_1:
			#if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (PlayerAP.current_animation_position > 0.3)):
				#PlayerAP.queue("Swing1-2")
				#state = playerStates.ATT_1_2
			#else:
				#if(not(PlayerAP.is_playing())):
					#PlayerAP.queue("Swing1-end")
					#state = playerStates.ATT_1_END
		#playerStates.ATT_1_END:
			#if(not(PlayerAP.is_playing())):
				#state = playerStates.IDLE
		#playerStates.ATT_1_2:
			#if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and (PlayerAP.current_animation_position > 0.3) and (PlayerAP.current_animation == "Swing1-2")):
				#PlayerAP.queue("Swing2-3-end")
				#state = playerStates.ATT_2_3_END
			#else:
				#if(not(PlayerAP.is_playing())):
					#PlayerAP.queue("Swing2-end")
					#state = playerStates.ATT_1_END
		#playerStates.ATT_2_END:
			#if(not(PlayerAP.is_playing())):
				#state = playerStates.IDLE
		#playerStates.ATT_2_3_END:
			#if(not(PlayerAP.is_playing())):
				#state = playerStates.IDLE
		#playerStates.BLOCK_START:
			#timeStampBlocking = Time.get_unix_time_from_system()
			#state = playerStates.BLOCKING
		#playerStates.BLOCKING:
			#if(not(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))):
				#PlayerAP.queue("BlockEnd")
				#state = playerStates.BLOCK_END
		#playerStates.BLOCK_END:
			#if(not(PlayerAP.is_playing())):
				#state = playerStates.IDLE
		#playerStates.DEAD:
			#pass
		#playerStates.HEAVYATT:
			#if(not(PlayerAP.is_playing())):
				#state = playerStates.IDLE
