extends Area2D

export var BASE_DAMAGE = 15
export var is_reach = false
var current_speed
onready var shape = $CollisionShape2D
onready var previous_position = shape.global_position

func _physics_process(delta):
	current_speed = (shape.global_position-previous_position)
	previous_position = shape.global_position
#	print("speed: %s" % current_speed)
#	print("prev pos: %s \n pos: %s" % [previous_position, shape.global_position])

func _on_Rapier_body_entered(body):
	# only damage when in reach state
	if is_reach:
		if body.has_meta("faction") and body.get_meta("faction") == "enemy":
			if body.has_meta("damageable") and body.get_meta("damageable") == true:
				var total_speed = (abs(current_speed.x) + abs(current_speed.y))
				print("dealing damage, total speed: %s, total dmg: %s" % [total_speed, BASE_DAMAGE*total_speed])
				body.on_damage(BASE_DAMAGE*total_speed)
