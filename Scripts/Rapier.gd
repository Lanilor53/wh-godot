extends Area2D

export var DAMAGE = 15

func _on_Rapier_body_entered(body):
	if body.has_meta("faction") and body.get_meta("faction") == "enemy":
				if body.has_meta("damageable") and body.get_meta("damageable") == true:
					body.on_damage(DAMAGE)
