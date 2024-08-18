extends Button

signal update_leaderboard

var leaderboarData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_toggled(toggled_on):
	var leaderboardPopup = $LeaderboardPopup
	if toggled_on == true:
		leaderboardPopup.show()
	else:
		leaderboardPopup.hide()

func _on_update_leaderboard():
	var save_file = FileAccess.open("res://leaderboard.save", FileAccess.READ)
	var json_string = save_file.get_line()
	# Creates the helper class to interact with JSON
	var json = JSON.new()
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(json_string)
	#if not parse_result == OK:
		#print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	#
	# Get the data from the JSON object
	leaderboarData = json.get_data()
	await make_leaderboard()

func make_leaderboard():
	print(leaderboarData)
	$LeaderboardPopup/ColorRect/Label.text = str(leaderboarData).replace('{','').replace('}',''). replace(', ','\n')

func _on_save_game():
	var save_file = FileAccess.open("res://leaderboard.save", FileAccess.WRITE)
	print(get_node('../PlayerName').text, get_node("../ScoreLabel").text)
	leaderboarData[get_node('../PlayerName').text] = int(get_node("../ScoreLabel").text)
	save_file.store_line(JSON.stringify(leaderboarData))
	update_leaderboard.emit()
	make_leaderboard()
