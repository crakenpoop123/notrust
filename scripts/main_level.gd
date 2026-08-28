extends Node2D

var grid_length
var card = preload("res://scenes/card.tscn")

var person_time = 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Person.visible = false
	
	grid_length = $CardsGrid.columns
	
	for y_pos in range(grid_length):
		for x_pos in range(grid_length):
			var curr_card = card.instantiate()
			
			curr_card.card_pos = Vector2(x_pos, y_pos)
			
			$CardsGrid.add_child(curr_card)
	
	$PersonTimer.start(person_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_person_timer_timeout() -> void:
	$Person.visible = !$Person.visible
	
