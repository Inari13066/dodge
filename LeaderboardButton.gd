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
	release_focus()

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
	make_leaderboard()

func make_leaderboard():
	$LeaderboardPopup/ColorRect/ItemList.clear()
	leaderboarData = sort_leaderboard(leaderboarData)
	print(leaderboarData)
	for leader in leaderboarData:
		$LeaderboardPopup/ColorRect/ItemList.add_item(str(leader) + " : " + str(leaderboarData[leader]))

func _on_save_game():
	var save_file = FileAccess.open("res://leaderboard.save", FileAccess.WRITE)
	var playerName = get_node('../PlayerName').text
	var score = int(get_node("../ScoreLabel").text)
	leaderboarData[playerName] = max(leaderboarData.get(playerName, 0), score)
	save_file.store_line(JSON.stringify(leaderboarData))
	make_leaderboard()
	
func sort_leaderboard(data) :
	var sortable = [];
	for player in data:
		sortable.push_back([player, data[player]]);

	sortable.sort_custom(func(a,b): return a[1] > b[1])
	var objSorted = {}
	for i in sortable.size():
		var item = sortable[i]
		objSorted[item[0]]=item[1]
	return objSorted
