extends KinematicBody2D

export var SPEED = 100
export var MAX_HEALTH = 100
export var DETECT_DISTANCE = 150
export var CONTACT_DAMAGE = 10

onready var player = get_tree().get_root().get_node("Main").get_node("Player")
onready var current_health = MAX_HEALTH

func _ready():
	set_meta("faction", "enemy")
	set_meta("damageable", true)
	
func _process(delta):
	var player_distance = self.position.distance_to(player.position)
	if player_distance <= DETECT_DISTANCE:
		var velocity = self.position.direction_to(player.position)
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		move_and_slide(velocity)
		
		for i in range(get_slide_count()-1): # todo: rewrite using on_collide events?
			var collider = get_slide_collision(i).collider
			if collider.has_meta("faction") and collider.get_meta("faction") == "player":
				if collider.has_meta("damageable") and collider.get_meta("damageable") == true:
					collider.on_damage(CONTACT_DAMAGE)

func on_damage(damage):
	current_health -= damage
	print("enemy damaged, hp: %d" % current_health)
	if current_health <= 0:
		queue_free()
