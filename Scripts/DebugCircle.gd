extends Node2D


func _ready():
	_draw()

func _draw():
	draw_circle(Vector2.ZERO, 3, Color.red)
