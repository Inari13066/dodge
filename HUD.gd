extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	$LeaderboardButton.show()
	$Message.text = "Game Over \n Enter ypur Name"
	$Message.show()
	$PlayerName.show()
	# Wait until Player submit a name.
	await $PlayerName.text_submitted
	$LeaderboardButton/LeaderboardPopup/ColorRect/ItemList.add_item($PlayerName.text + " " + $ScoreLabel.text)

	$PlayerName.clear()
	$PlayerName.hide()
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	$LeaderboardButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
