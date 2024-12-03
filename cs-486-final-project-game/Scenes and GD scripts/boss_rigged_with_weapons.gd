extends Node3D

@onready var rootNode = get_node('/root/Game')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_axe_area_3d_body_entered(body: Node3D) -> void:
	rootNode.axe()


func _on_axe_area_3d_body_exited(body: Node3D) -> void:
	rootNode.axe_leave()
