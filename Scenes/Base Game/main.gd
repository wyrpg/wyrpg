extends Node

@export var mob_scene: PackedScene
var score = 0
@export var game_started = false
signal game_start

func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stream_paused = true
	$GameOver.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#get_tree().call_group("mobs", "queue_free")
	if $GameOver.playing:
		$GameOver.stop()
	$Music.stream_paused = false
	game_started = true
	game_start.emit()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_player_deal_damage(body):
	if game_started:
		if body.type == "enemy":
			body.hp -= 10
			print(body.hp)

func _on_player_die():
	game_over()
