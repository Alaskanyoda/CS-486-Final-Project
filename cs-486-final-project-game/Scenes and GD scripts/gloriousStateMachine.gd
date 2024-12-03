extends Node3D

@onready var playerHealth = $Healthbars/PlayerHealthBar
@onready var bossHealth = $Healthbars/BossHealthBar
@onready var player = $Player3D
@onready var boss = $boss_3d
var php = 100
var bhp = 100
var axeEntered = false
var spearEntered = false
var axeDamaged = true
var spearDamaged = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	playerHealth.init_health(100)
	bossHealth.init_health(100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (axeEntered == true):
		if (axeDamaged == false): #state machines set to false right bfore damage can be dealt
			if (player.Blocking):
				php -= boss.Damage / 2
			else:
				php -= boss.Damage
			if php > 0:
				if (player.Blocking):
					playerHealth.value -= boss.Damage / 2
				else:
					playerHealth.value -= boss.Damage
			else:
				get_tree().change_scene_to_file("res://Scenes and GD scripts/you_died.tscn")
			axeDamaged = true
	if (spearEntered == true):
		if (spearDamaged == false): #state machines set to false right bfore damage can be dealt
			bhp -= player.Damage
			if bhp > 0:
				bossHealth.value -= player.Damage
			else:
				get_tree().change_scene_to_file("res://Scenes and GD scripts/you_win.tscn")
			spearDamaged = true

func spear() -> void:
	spearEntered = true
	
func spear_leave() -> void:
	spearEntered = false
	
func axe() -> void:
	axeEntered = true

func axe_leave() -> void:
	axeEntered = false
	
func axe_damage_set(axedmg) -> void:
	axeDamaged = axedmg
	
func spear_damage_set(speardmg) -> void:
	spearDamaged = speardmg
	
