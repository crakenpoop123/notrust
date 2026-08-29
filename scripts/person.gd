extends Sprite2D

var truth_teller

var text_possibilities = {
	"Name": ["get_name"],
	"NameList": ["Bob", "Hubert", "Clive", "Rosamond", "Karl", "Trenton", "Festus", "Jason", "Emmett", "Cheri", "Annice", "Fiona", "Ellery", "Leatrice", "Ursula", "Meryl", "Aura", "Vanessa", "Larissa", "Keri", "Mathilda", "Georgia", "Goldie", "Spring", "Cade", "Autumn", "Landon", "Garland", "Cecil", "Quincy", "Jeffery", "Lynwood", "Cordell", "Lela", "Wyatt"],
	"Height": ["range", 150, 220],
	"Age": ["range", 24, 83],
	"Birthday": ["get_birthday"],
	"BirthMonth": ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
	"BirthDay": [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
	"Speech": ["Believe me, a safe tile is at ϧ", "I'm not lying, there is a safe card at ϧ", "I wouldn't lie, the safe card is ϧ", "ϧ is safe, believe me", "YOU MUST LISTEN TO ME! ϧ is safe", "Trust me, ϧ is a safe card"],
} # Replace ϧ (Alt + 999) with the spot for Speech

@onready var text_location = $"../PersonText"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.15:
		truth_teller = false
	else:
		truth_teller = true
	init_text()

# Init the text variables
func init_text():
	for text in text_location.get_children():
		print("text node: ", text)
		print("text name: |", text.name, "|")
		print("output: ", init_specific_text(text))
		text.text = str(text.name, ": ", init_specific_text(text))
		print("----------")

# Used so that I can exit when the text gets set
func init_specific_text(text):
	# Grab the texts array
	var text_array = text_possibilities[text.name]
	
	# Get the first item in the text's array
	# This is used because it sometimes holds important info about how to get the text
	var first_item
	if text.name in text_possibilities:
		first_item = text_array[0]
		print("First item: ", first_item)
	else:
		print("text keys: ", text_possibilities.keys())
	
	# Check if there is custom code for the text
	if self.has_method(str(first_item)):
		return call(first_item, true) # TODO: Replace with truth_teller when set up for liars
	
	# Check if it is a range
	if first_item == "range":
		# Return a number between the second and third values
		return randi_range(text_array[1], text_array[2])
	
	if len(text_array) != 0:
		return text_array[randi_range(0, len(text_array) - 1)]
	
	# If the previous code doesn't find the correct text
	return "ERROR"

# Get a valid brithday by pulling from BirthMonth and BirthDay
func get_birthday(real):
	# Init the birthday text
	var birthday_text = ""
	
	var months_max = 11 # 12 months in a month - 1 for zero-indexing
	
	# Generate a real birthday for the truth-tellers
	if real:
		# Get the index of a random month
		var month_index = randi_range(0, months_max)
		
		# Add the random month to birthday_text
		birthday_text = birthday_text + text_possibilities["BirthMonth"][month_index]
		
		# Add a buffer between the months and days for formatting
		birthday_text = birthday_text + " " 
		
		# Get a random day from the month
		var month_day = randi_range(1, text_possibilities["BirthDay"][month_index])
		
		# Add the day to birthday_text
		birthday_text = birthday_text + str(month_day)
	
	return birthday_text

# Returns a random name, with ϧ replaced by a card location

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
