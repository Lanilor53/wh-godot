extends KinematicBody2D

export var SPEED = 400
var screen_size
onready var health = 100
export var MAX_INVINCIBILITY_TIME = 1
onready var current_invincibility_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("damageable", true)

func _process(delta):
	if current_invincibility_time > 0:
		current_invincibility_time -= delta
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
		velocity = velocity.normalized() * SPEED
	
		move_and_slide(velocity)
	
func on_damage(source, damage):
	if current_invincibility_time <= 0:
		health -= damage
		print("taken damage, health left: %d" % health)
		if health <= 0:
			queue_free() # die
		current_invincibility_time = MAX_INVINCIBILITY_TIME
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
