extends KinematicBody2D

export var SPEED = 100
export var MAX_HEALTH = 100
export var DETECT_DISTANCE = 300
export var CONTACT_DAMAGE = 10

onready var player = get_tree().get_root().get_node("Main").get_node("Player")
onready var nav = get_tree().get_root().get_node("Main").get_node("Level").get_node("Navigation2D")
onready var current_health = MAX_HEALTH

func _ready():
	set_meta("faction", "enemy")
	set_meta("damageable", true)

func _process(delta):
	var player_distance = self.position.distance_to(player.position)
	if player_distance <= DETECT_DISTANCE:
		if $PlayerRaycast.enabled == false:
			$PlayerRaycast.enabled = true
		$PlayerRaycast.global_position = player.global_position
		$PlayerRaycast.cast_to = (player.global_position-global_position)*-1
		# get collision point with enemy collider
		var closest_to_player_collider_point = $PlayerRaycast.get_collision_point()
		# use unoptimised path if near a collider
		var player_path
		if len($NavigationModeArea.get_overlapping_bodies()) > 0:
			player_path = nav.get_simple_path(position, player.position, false)
		else:
			player_path = nav.get_simple_path(position, player.position, true)
		
		$DebugCircle.global_position = player_path[1]
		var velocity = self.position.direction_to(player_path[1])
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		move_and_slide(velocity)
		
		for i in range(get_slide_count()-1): # todo: rewrite using on_collide events?
			var collider = get_slide_collision(i).collider
			if collider.has_meta("faction") and collider.get_meta("faction") == "player":
				if collider.has_meta("damageable") and collider.get_meta("damageable") == true:
					collider.on_damage(CONTACT_DAMAGE)
	else:
		$PlayerRaycast.enabled = false
	
func on_damage(damage):
	current_health -= damage
	print("enemy damaged, hp: %d" % current_health)
	if current_health <= 0:
		queue_free()
