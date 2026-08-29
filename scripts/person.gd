extends Sprite2D

var truth_teller
var changed_val
var lie_probability = 0.85

var text_possibilities = {
	"Name": ["Bob", "Hubert", "Clive", "Rosamond", "Karl", "Trenton", "Jason", "Emmett", "Cheri", "Annice", "Fiona", "Ellery", "Leatrice", "Ursula", "Meryl", "Aura", "Vanessa", "Larissa", "Keri", "Mathilda", "Georgia", "Goldie", "Spring", "Cade", "Autumn", "Landon", "Garland", "Cecil", "Quincy", "Jeffery", "Lynwood", "Cordell", "Lela", "Wyatt"],
	"FakeName": ["Ianus", "Diarmiud", "Verginius", "Iuno", "Flavianus", "Perfectus", "Aemilia", "Valens", "Quinctilianus", "Crescens", "Florentius"],
	"Height": ["range", 150, 220],
	"FakeHeight": ["range", 250, 350],
	"Age": ["range", 20, 90],
	"FakeAge": ["range", 110, 200],
	"Birthday": ["get_birthday"],
	"BirthMonth": ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
	"FakeBirthMonth": ["Quintember", "Quadrober", "Maruary", "Fray", "Martember"],
	"BirthDay": [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
	"Speech": ["get_speech"],
	"SpeechList": ["Believe me, a safe tile is at ϧ", "I'm not lying, there is a safe card at ϧ", "I wouldn't lie, the safe card is ϧ", "ϧ is safe, believe me", "YOU MUST LISTEN TO ME! ϧ is safe", "Trust me, ϧ is a safe card"],
} # Replace ϧ (Alt + 999) with the spot for Speech

@onready var text_location = $"../PersonText"


# Init the text variables
func init_text():
	var rand_val = randf()
	print("rand_val: ", rand_val)
	# Decide if this person is a liar or a truth-teller
	if rand_val > lie_probability:
		changed_val = "none"
	else:
		changed_val = get_rand_attribute()
	
	for text in text_location.get_children():
		#print("text node: ", text)
		#print("text name: |", text.name, "|")
		#print("output: ", init_specific_text(text))
		#print("----------")
		text.text = str(text.name, ": ", init_specific_text(text))
	
	# Specify the height is in centimetres
	$"../PersonText/Height".text = $"../PersonText/Height".text + "cm"

# Returns a random attribute from PersonText
# Used to make a single thing wrong when the person is a liar
func get_rand_attribute():
	# Get the index of a random attribute
	var rand_attr = randi_range(0, $"../../Person/PersonText".get_child_count() - 2) # -1 for zero-indexing and -1 bc Speech shouldn't be included
	
	var count = 0
	for text in $"../../Person/PersonText".get_children():
		# Check if the rand attibute is the current one
		if count == rand_attr:
			return text.name
		
		# Increase count
		count += 1

# Used so that I can exit when the text gets set
func init_specific_text(text):
	# Set the truth_teller variable to a bool represetning if it is the current text
	truth_teller = text.name != changed_val
	print("text name: ", text.name, " | changed val: ", changed_val,  " | truth teller?: ", truth_teller)
	
	# Grab the texts array
	var text_array = text_possibilities[text.name]
	
	if !truth_teller and "Fake" + text.name in text_possibilities:
		text_array = text_possibilities["Fake" + text.name]
	
	# Get the first item in the text's array
	# This is used because it sometimes holds important info about how to get the text
	var first_item
	
	if text.name in text_possibilities:
		first_item = text_array[0]
		#print("First item: ", first_item)
	#else:
		#print("text keys: ", text_possibilities.keys())
	
	# Check if there is custom code for the text
	if self.has_method(str(first_item)):
		return call(first_item)
	
	# Check if it is a range
	if first_item == "range":
		# Return a number between the second and third values
		return randi_range(text_array[1], text_array[2])
	
	if len(text_array) != 0:
		return text_array[randi_range(0, len(text_array) - 1)]
	
	# If the previous code doesn't find the correct text
	return "ERROR"

# Get a valid brithday by pulling from BirthMonth and BirthDay
func get_birthday():
	# Init the birthday text
	var birthday_text = ""
	
	var months_max = 11 # 12 months in a month - 1 for zero-indexing
	var fake_months_max = 4 # 5 fake months - 1 for zero-indexing
	
	# Generate a real birthday for the truth-tellers
	if truth_teller:
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
	else:
		# If the birth month is wrong
		if randf() < 0.5:
			# Get the index of a random fake month
			var month_index = randi_range(0, fake_months_max)
			
			# Add the random month to birthday_text
			birthday_text = birthday_text + text_possibilities["FakeBirthMonth"][month_index]
			
			# Add a buffer between the months and days for formatting
			birthday_text = birthday_text + " " 
			
			# Get a random day from the month
			var month_day = randi_range(1, 30)
			
			# Add the day to birthday_text
			birthday_text = birthday_text + str(month_day)
		else:
			
			# Get the index of a random real month
			var month_index = randi_range(0, months_max)
			
			# Add the random month to birthday_text
			birthday_text = birthday_text + text_possibilities["BirthMonth"][month_index]
			
			# Add a buffer between the months and days for formatting
			birthday_text = birthday_text + " " 
			
			# Get a random day that is too high to be part of the month
			var month_day = text_possibilities["BirthDay"][month_index] + randi_range(2, 6)
			
			# Add the day to birthday_text
			birthday_text = birthday_text + str(month_day)
	
	return birthday_text

# Returns a random speech, with ϧ replaced by a card location
func get_speech():
	# Gets the unedited speech
	var speech = text_possibilities["SpeechList"][randi_range(0, len(text_possibilities["SpeechList"]) - 1)]
	
	# Get the index of the filler character: ϧ
	var filler_index = speech.find("ϧ")
	
	# Remove the filler value from the text
	speech[filler_index] = ""
	
	# Get a card position
	var card_pos = get_card_location(changed_val != "none")
	
	# Insert the new value into the text
	speech = speech.insert(filler_index, str(card_pos))
	
	return speech

# Returns the location of either a random mine or a random card
func get_card_location(mine):
	# MainLevel node
	var main = $"../.."
	
	#print("mine pos", main.mine_positions)
	
	# Returns a random mine position if mine == true
	if mine == true:
		return main.mine_positions[randi_range(0, len(main.mine_positions) - 1)]
	# Return a random index of a safe card
	else:
		return get_random_non_mine()

# Searches main.mines for a random non-mine
func get_random_non_mine():
	# MainLevel node
	var main = $"../.."
	
	# Random card pos
	var card_pos = Vector2(randi_range(0, main.grid_length - 1), randi_range(0, main.grid_length - 1))
	
	if main.mines[card_pos[0]][card_pos[1]] == 0:
		return card_pos
	else:
		return get_random_non_mine()
