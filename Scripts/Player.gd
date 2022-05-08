extends KinematicBody2D

export var SPEED = 400
var screen_size
onready var health = 100
export var MAX_INVINCIBILITY_TIME = 1
onready var current_invincibility_time = 0

export var MAX_ATTACK_COOLDOWN = 1
onready var current_attack_cooldown = 0
var flag

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("damageable", true)
	set_meta("faction", "player")

func _process(delta):
	if current_invincibility_time > 0:
		current_invincibility_time -= delta
		
	if current_attack_cooldown >= 0:
		flag = true
		current_attack_cooldown -= delta
	if current_attack_cooldown <= 0 and flag==true:
		print("attack up")
		flag = false
	look_at(get_global_mouse_position())
	
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
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == true:
		if current_attack_cooldown <= 0:
			# play attack animation
			$Weapon.get_node("AnimationPlayer").play("attack")
			# start attack cooldown
			current_attack_cooldown = MAX_ATTACK_COOLDOWN

func on_damage(damage):
	if current_invincibility_time <= 0:
		health -= damage
		print("taken damage, health left: %d" % health)
		if health <= 0:
			queue_free() # die
		current_invincibility_time = MAX_INVINCIBILITY_TIME
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
