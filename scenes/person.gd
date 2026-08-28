extends TextureRect

var truth_teller = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.15:
		truth_teller = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
