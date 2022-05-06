extends KinematicBody2D

var player
export var SPEED = 100
export var DETECT_DISTANCE = 150
export var CONTACT_DAMAGE = 10

func _ready():
	player = get_tree().get_root().get_node("Main").get_node("Player")
	set_meta("damageable", true)
	
func _process(delta):
	var player_distance = self.position.distance_to(player.position)
	if player_distance <= DETECT_DISTANCE:
		var velocity = self.position.direction_to(player.position)
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		move_and_slide(velocity)
		
		for i in range(get_slide_count()-1):
			var collision = get_slide_collision(i)
			if collision.collider.has_meta("damageable") and collision.collider.get_meta("damageable") == true:
				collision.collider.on_damage(self, CONTACT_DAMAGE)
