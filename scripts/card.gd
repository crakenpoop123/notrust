extends TextureRect

var mouse_touching = false

var card_pos: Vector2
var mine

var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process():
	# Stop the process func immediately if this card has already been clicked
	if !active:
		return "Dead card"
	
	if mouse_touching:
		$".".modulate = Color(1, 1, 1)
	else:
		$".".modulate = Color(0.8, 0.8, 0.8)
	
	if Input.is_action_just_pressed("click") and mouse_touching:
		print(card_pos)
		print("card is mine: ", mine)
		
		# If this card is a mine, change the scene to the lose menu
		if mine == true:
			get_tree().change_scene_to_file.call_deferred("res://scenes/lose_menu.tscn")
		else:
			active = false


func _on_card_area_mouse_entered() -> void:
	mouse_touching = true


func _on_card_area_mouse_exited() -> void:
	mouse_touching = false
