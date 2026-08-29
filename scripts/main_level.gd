extends Node2D

var grid_length
var card = preload("res://scenes/card.tscn")
var cards_left
var card_just_pressed = false

var person_time = 4

var num_mines = 5
var mine_positions: Array
var mines: Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Compute which card the mouse is touching
	var offset_mouse_pos = get_global_mouse_position() - $CardsGrid.position
	var card_width = $CardsGrid.size[0] / grid_length
	var norm_mouse_pos = offset_mouse_pos / card_width
	var card_touching = Vector2(floor(norm_mouse_pos[0]), floor(norm_mouse_pos[1]))
	
	# Show the current mouse pos with a text label
	$MousePosition.text = str(card_touching)
	# Show how many tiles are left
	$TilesLeft.text = "CARDS LEFT: " + str(cards_left - num_mines)
	
	# When a card is pressed, it will set this to true
	if card_just_pressed:
		# Ensures it does not trigger multiple times
		card_just_pressed = false
		
		if cards_left <= num_mines:
			get_tree().change_scene_to_file.call_deferred("res://scenes/win_menu.tscn")
		
		# Shows the person briefly
		show_person()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Person.visible = false
	
	grid_length = $CardsGrid.columns
	cards_left = grid_length ** 2
	
	setup_mines()
	
	for y_pos in range(grid_length):
		for x_pos in range(grid_length):
			var curr_card = card.instantiate()
			
			curr_card.card_pos = Vector2(x_pos, y_pos)
			
			# Tell the card if it is a mine or not
			if mines[x_pos][y_pos] == 1:
				curr_card.mine = true
			else:
				curr_card.mine = false
			
			$CardsGrid.add_child(curr_card)
	
	#$Person/PersonTimer.start(person_time)

# Fills the mines 2D array with zeroes, then calls place_mines 
func setup_mines():
	# Resize the mines array
	mines.resize(grid_length)
	
	# Iterate over all y_pos
	for y_pos in range(grid_length):
		# Add an array
		mines[y_pos] = []
		mines[y_pos].resize(grid_length)
		# Fill mines[y_pos] with zeroes
		mines[y_pos].fill(0)
	
	# Place mines in the mines_array
	place_mines()

# Place mines in the mines_array
func place_mines():
	mine_positions.resize(num_mines)
	
	# Repeats for the number of mines
	for i in range(num_mines):
		# Generates a mine and adds it to the mine_positions array
		mine_positions[i] = generate_mine(i)
	
	# Loop over all mines in mine_positions
	for curr_mine in mine_positions:
		# Add this mine to the map
		mines[curr_mine[0]][curr_mine[1]] = 1

func generate_mine(i):
	# Gets a random position for the mine
	var temp_pos = Vector2(randi_range(0, grid_length - 1), randi_range(0, grid_length - 1))
	
	# Checks this position doesn't already have a mine
	if !temp_pos in mine_positions:
		return temp_pos
	
	# If it does already have a mine, get a new mine position
	return generate_mine(i)

# Hides the person after a short delay
func _on_person_timer_timeout() -> void:
	# Hide the person
	$Person.visible = false
	

# Shows the person
func show_person():
	$Person.visible = true
	
	# Inits the text for this person
	$Person/Person.init_text()
	
	# Start the timer (to hide the person)
	$Person/PersonTimer.start(person_time)
