extends TextureRect

var mouse_touching = false

var card_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_touching:
		$".".modulate = Color(1, 1, 1)
	else:
		$".".modulate = Color(0.8, 0.8, 0.8)
	
	if Input.is_action_just_pressed("click") and mouse_touching:
		print(card_pos)


func _on_card_area_mouse_entered() -> void:
	mouse_touching = true


func _on_card_area_mouse_exited() -> void:
	mouse_touching = false
