extends CharacterBody2D

@export var hp = 10
@export var type = "enemy"

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()

func _process(delta):
	if hp <= 0:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
