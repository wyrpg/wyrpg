extends CharacterBody2D
signal deal_damage
signal die

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var hp = 100
var screen_size # Size of the game window.
@export var die_signal_emitted = false
var game_started = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if game_started:
		if hp <= 0 and not die_signal_emitted:
			die.emit()
			die_signal_emitted = true
		
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$PlayerSprite.play()
		else:
			$PlayerSprite.stop()
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		if velocity.x != 0:
			$PlayerSprite.animation = "walk"
			$PlayerSprite.flip_v = false
			# See the note below about the following boolean assignment.
			$PlayerSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$PlayerSprite.animation = "up"
			$PlayerSprite.flip_v = velocity.y > 0

func start(pos):
	position = pos
	show()
	$PlayerCollisionShape.disabled = false

#change so that the enemy takes damage in its function not so that the weapon deals damage
func _on_id_lanyard_body_entered(body):
	print("body entered the id lanyard")
	deal_damage.emit(body)

func take_damage(damage):
	hp -= damage
	$HealthBar.size -= Vector2(damage, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("type") == "enemy":
		take_damage(10)
	# Must be deferred as we can't change physics properties on a physics callback.
	$PlayerCollisionShape.set_deferred("disabled", true)
	$ID_Lanyard.set_deferred("disabled", true)

func _on_hud_start_game() -> void:
	hp = 100
	die_signal_emitted = false
	$HealthBar.size = Vector2(100, 10)

func _on_main_game_start() -> void:
	game_started = true
