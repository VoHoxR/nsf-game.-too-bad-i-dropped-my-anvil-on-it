extends MeshInstance2D

func _ready() -> void:
	$".".scale = $"../CollisionShape2D".scale
