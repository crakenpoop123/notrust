extends TextureRect

var mouse_touching = false

var card_pos: Vector2
var mine

var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stop the process func immediately if this card has already been clicked
	if active:
		
		if mouse_touching:
			$".".modulate = Color(1, 1, 1)
		else:
			$".".modulate = Color(0.8, 0.8, 0.8)
		
		# What to do when the card is clicked on and the person is not visible
		if Input.is_action_just_pressed("click") and mouse_touching and !$"../../Person".visible:
			# If this card is a mine, change the scene to the lose menu
			if mine == true:
				get_tree().change_scene_to_file.call_deferred("res://scenes/lose_menu.tscn")
			else:
				card_pressed()

# Holds instructions for what to do when the card is pressed
func card_pressed():
	# Make the card inactive when it has already been interacted with
	active = false
	
	# Gray out the card
	$".".modulate = Color(0.4, 0.4, 0.4)
	
	# Decrease the number of cards left
	$"../..".cards_left -= 1
	# Remove this from the mines grid (set to 2 bc actually removing it would induce crashes)
	$"../..".mines[card_pos[0]][card_pos[1]] = 2
	
	$"../..".card_just_pressed = true
	
	#print($"../..".cards_left)

func _on_card_area_mouse_entered() -> void:
	mouse_touching = true


func _on_card_area_mouse_exited() -> void:
	mouse_touching = false
