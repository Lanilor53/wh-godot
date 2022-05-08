extends ProgressBar

func _ready():
	var player = get_tree().get_root().get_node("Main").get_node("Player")
	player.connect("attack_charge_changed", self, "_on_attack_charge_changed")
	max_value = player.MAX_ATTACK_COOLDOWN

func _on_attack_charge_changed(new_value):
	print("charge: %f" % new_value)
	value = 1-new_value
