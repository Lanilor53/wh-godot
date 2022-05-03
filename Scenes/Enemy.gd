extends Node2D

var player
var SPEED = 300
var DETECT_DISTANCE = 150

func _ready():
	player = get_tree().get_root().get_node("Main").get_node("Player")
	
func _process(delta):
	var player_distance = self.position.distance_to(player.position)
	print(player_distance)
	if player_distance <= DETECT_DISTANCE:
		var velocity = self.position.direction_to(player.position)
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		self.position += velocity * delta
