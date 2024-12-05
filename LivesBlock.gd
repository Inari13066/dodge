extends Control
var lives

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("lives", "hide")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_add_heart():
	lives = get_meta("Lives")
	if lives < 3:
		set_meta("Lives",lives + 1)
		show_lives()


func _on_hud_start_game():
	set_meta("Lives",0)
	get_tree().call_group("lives", "hide")


func show_lives():
	get_tree().call_group("lives", "hide")
	var lives_nodes = get_tree().get_nodes_in_group("lives")
	lives = get_meta("Lives")
	for live in lives:
		lives_nodes[live].show()
 


func _on_player_lose_life():
	lives = get_meta("Lives")
	set_meta("Lives",lives - 1)
	show_lives()
