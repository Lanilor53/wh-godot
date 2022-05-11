extends KinematicBody2D

signal enemy_died

export var SPEED = 100
export var MAX_HEALTH = 100
export var DETECT_DISTANCE = 300
export var CONTACT_DAMAGE = 10
export var VISION_ANGLE = 75

onready var player = get_tree().get_root().get_node("Main").get_node("Player")
onready var nav = get_tree().get_root().get_node("Main").get_node("Level").get_node("Navigation2D")
onready var current_health = MAX_HEALTH
onready var is_attacking = false

func _ready():
	set_meta("faction", "enemy")
	set_meta("damageable", true)

func _process(delta):
	var player_distance = self.position.distance_to(player.position)
	if player_distance <= DETECT_DISTANCE:
		# check if player is in cone of sight TODO: vision obstruction
		var look_dir = rotation
		var player_dir = position.direction_to(player.position)
		var player_angle = abs(rad2deg(player_dir.angle() - look_dir))
		print(player_angle)
		if (player_angle >= 0 and player_angle <= VISION_ANGLE) or (player_angle >= 360 - VISION_ANGLE and player_angle <= 360):
			# use unoptimised path if near a collider
			var player_path
			if len($NavigationModeArea.get_overlapping_bodies()) > 0:
				player_path = nav.get_simple_path(position, player.position, false)
			else:
				player_path = nav.get_simple_path(position, player.position, true)
			# don't move if no path exists
			if len(player_path) > 0:
				$DebugCircle.global_position = player_path[1]
				var velocity = self.position.direction_to(player_path[1])
				if velocity.length() > 0:
					velocity = velocity.normalized() * SPEED
				look_at(player_path[1])
				move_and_slide(velocity)
			
			# reach when player is near
			if player in $AttackRangeArea2D.get_overlapping_bodies():
				if not is_attacking:
					$Rapier/AnimationPlayer.play("reach")
					is_attacking = true
			
			if is_attacking and not (player in $AttackRangeArea2D.get_overlapping_bodies()):
				$Rapier/AnimationPlayer.play("hold")
				is_attacking = false
	else:
		$PlayerRaycast.enabled = false
	
func on_damage(damage):
	current_health -= damage
	print("enemy damaged, hp: %d" % current_health)
	if current_health <= 0:
		emit_signal("enemy_died")
		queue_free()
