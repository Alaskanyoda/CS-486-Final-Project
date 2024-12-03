extends CharacterBody3D

enum bossStates {
	IDLE,
	ATT_1_SAFE, #3.36-5, 6-7               8-4meters
	ATT_1_1, #3.36-5, 6-7
	ATT_1_2, #3.36-5, 6-7
	ATT_2_SAFE, #0-1, 2-2.7
	ATT_2_1, #0-1, 2-2.7
	ATT_2_2, #0-1, 2-2.7
	ATT_3_SAFE, #2-2.7 (swing), 3.5 (shrapnel)
	ATT_3_1, #2-2.7 (swing), 3.5 (shrapnel release)
	ATT_3_2, #2-2.7 (swing), 3.5 (shrapnel release)
	ATT_4_SAFE, #1-1.76, 2.5-3.6
	ATT_4_1, #1-1.76, 2.5-3.6
	ATT_4_2, #1-1.76, 2.5-3.6
	ATT_5_SAFE, #0.6-0.83, 1.03-1.3, 1.5-1.7, 3.8-4.1 (big slam)
	ATT_5_1, #0.6-0.83, 1.03-1.3, 1.5-1.7, 3.8-4.1 (big slam)
	ATT_5_2, #0.6-0.83, 1.03-1.3, 1.5-1.7, 3.8-4.1 (big slam)
	ATT_5_3, #0.6-0.83, 1.03-1.3, 1.5-1.7, 3.8-4.1 (big slam)
	ATT_5_4, #0.6-0.83, 1.03-1.3, 1.5-1.7, 3.8-4.1 (big slam)
	SHOOT,
	DEAD
}

enum weaponStates {
	AXE,
	BOW
}

var bossState = bossStates.IDLE
var weaponState = weaponStates.AXE
@onready var BossAP = $bossRiggedWithWeapons/AnimationPlayer

@onready var nav: NavigationAgent3D = $NavigationAgent3D

@export var Damage = 0
var speed = 3
var accel = 10
var rotateModifier = 0
var canRotate = true

func _ready() -> void:
	nav.target_position = Vector3(0, 1, 0)
	
func _process(delta: float) -> void:
	match bossState:
		bossStates.IDLE:
			if (not(BossAP.is_playing())):
				speed = 3
				var optionsWeight = [0, 0, 0, 0, 0, 0, 100] # att1, att2, att3, att4, att5, bowshot, do nothing
				var totalWeight = 0
				var distance = (nav.target_position - global_transform.origin).length()
				if ((distance > 5) and (distance < 10)):
					optionsWeight[0] = 10
				if ((distance > 3) and (distance < 9)):
					optionsWeight[1] = 20
				if ((distance > 8) and (distance < 11)):
					optionsWeight[2] = 10
				if ((distance > 5) and (distance < 9)):
					optionsWeight[3] = 10
				if ((distance > 0) and (distance < 5)):
					optionsWeight[4] = 10
				if ((distance > 0) and (distance < 3)):
					optionsWeight[4] = 100
				if (distance > 15):
					optionsWeight[5] = 100
				var index = 6
				var frequency = 0.1
				for i in optionsWeight.size():
					var rand = randf_range(0, 100)
					if (optionsWeight[i]*frequency >= rand): #within the range of 0 to rand
						index = i
						break
				match index: #assume we have axe out
					0:
						speed = 1
						BossAP.queue("Swing1")
						bossState = bossStates.ATT_1_SAFE
					1:
						speed = 1
						BossAP.queue("Swing2")
						bossState = bossStates.ATT_2_SAFE
					2:
						speed = 0
						BossAP.queue("Swing3")
						bossState = bossStates.ATT_3_SAFE
					3:
						speed = 1
						BossAP.queue("Swing4")
						bossState = bossStates.ATT_4_SAFE
					4:
						speed = 1
						BossAP.queue("Swing5")
						bossState = bossStates.ATT_5_SAFE
					5: #shoot bow
						BossAP.queue("Swap")
						pass
					6: #do nothing
						pass
					
				
			
		bossStates.ATT_1_SAFE: #3.36-5, 6-7
			Damage = 0
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
			if (BossAP.current_animation_position >= 3.36 and BossAP.current_animation_position <= 5.0):
				bossState = bossStates.ATT_1_1
			if (BossAP.current_animation_position >= 6.0 and BossAP.current_animation_position <= 7.0):
				bossState = bossStates.ATT_1_1
		bossStates.ATT_1_1:
			Damage = 20
			if (BossAP.current_animation_position >= 5.0):
				bossState = bossStates.ATT_1_SAFE
		bossStates.ATT_1_2:
			Damage = 20
			if (BossAP.current_animation_position >= 7.0):
				bossState = bossStates.ATT_1_SAFE
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
		bossStates.ATT_2_SAFE: #0-1, 2-2.7
			Damage = 0
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
			if (BossAP.current_animation_position >= 0.0 and BossAP.current_animation_position <= 1.0):
				bossState = bossStates.ATT_2_1
			if (BossAP.current_animation_position >= 2.0 and BossAP.current_animation_position <= 2.7):
				bossState = bossStates.ATT_2_1
		bossStates.ATT_2_1:
			Damage = 20
			if (BossAP.current_animation_position >= 1.0):
				bossState = bossStates.ATT_2_SAFE
		bossStates.ATT_2_2:
			Damage = 20
			if (BossAP.current_animation_position >= 2.7):
				bossState = bossStates.ATT_2_SAFE
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
		bossStates.ATT_3_SAFE: #2-2.7 (swing), 3.5 (shrapnel)
			Damage = 0
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
			if (BossAP.current_animation_position >= 2.0 and BossAP.current_animation_position <= 2.7):
				bossState = bossStates.ATT_3_1
			if (BossAP.current_animation_position >= 2.7 and BossAP.current_animation_position <= 3.5):
				canRotate = false
			else:
				canRotate = true
		bossStates.ATT_3_1:
			Damage = 50
			if (BossAP.current_animation_position >= 2.7):
				bossState = bossStates.ATT_3_SAFE
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
		bossStates.ATT_3_2: #DOES NOTHING FOR NOW
			pass
		bossStates.ATT_4_SAFE: #1-1.76, 2.5-3.6
			Damage = 0
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
			if (BossAP.current_animation_position >= 1.0 and BossAP.current_animation_position <= 1.76):
				bossState = bossStates.ATT_4_1
			if (BossAP.current_animation_position >= 2.5 and BossAP.current_animation_position <= 3.6):
				bossState = bossStates.ATT_4_2
		bossStates.ATT_4_1:
			Damage = 20
			if (BossAP.current_animation_position >= 1.76):
				bossState = bossStates.ATT_4_SAFE
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
		bossStates.ATT_4_2:
			Damage = 20
			if (BossAP.current_animation_position >= 3.6):
				bossState = bossStates.ATT_4_SAFE
			if (not(BossAP.is_playing())):
				bossState = bossStates.IDLE
		bossStates.ATT_5_SAFE:
			bossState = bossStates.IDLE
			pass
		bossStates.ATT_5_1:
			pass
		bossStates.ATT_5_2:
			pass
		bossStates.ATT_5_3:
			pass
		bossStates.ATT_5_4:
			pass
		bossStates.SHOOT:
			pass
		bossStates.DEAD:
			pass
	

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	if canRotate:
		rotation.y = atan2(direction[0], direction[2]) + PI + rotateModifier
	
	move_and_slide()

func update_target_location(target_location):
	nav.target_position = target_location
	
