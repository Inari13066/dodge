extends Node
@export var mob_scene: PackedScene
@export var boost_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BoostTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("boosts", "queue_free")
	$Music.play()
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	#$MobTimer.start()
	$ScoreTimer.start()
	$BoostTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_boost_timer_timeout():
	var boost = boost_scene.instantiate()
	
	var boost_spawn_location = $MobPath/MobSpawnLocation
	boost_spawn_location.progress_ratio = randf()
	
	var direction = boost_spawn_location.rotation + PI / 2
	
	boost.position = boost_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	boost.rotation = direction
	
	var velocity = Vector2(randf_range(100.0, 150.0), 0.0)
	boost.linear_velocity = velocity.rotated(direction)
	
	add_child(boost)
	
	
