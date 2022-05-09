extends KinematicBody2D

export var SPEED = 400
export var ROTATION_SPEED = 20
export var REACH_ROTATION_SPEED = 3.5
onready var look_point = get_global_mouse_position()
var screen_size
onready var health = 100
export var MAX_INVINCIBILITY_TIME = 1
onready var current_invincibility_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("damageable", true)
	set_meta("faction", "player")

func _physics_process(delta):
	if $Weapon.is_reach:
		look_point = look_point.linear_interpolate(get_global_mouse_position(), delta*REACH_ROTATION_SPEED)
	else:
		look_point = look_point.linear_interpolate(get_global_mouse_position(), delta*ROTATION_SPEED)
	look_at(look_point)

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
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed == true:
				# reach with weapon
				$Weapon.get_node("AnimationPlayer").play("reach")
		elif event.pressed == false:
				# hold weapon close
				$Weapon.get_node("AnimationPlayer").play("hold")

func on_damage(damage):
	if current_invincibility_time <= 0:
		health -= damage
		print("taken damage, health left: %d" % health)
		if health <= 0:
			queue_free() # die
		current_invincibility_time = MAX_INVINCIBILITY_TIME
	
