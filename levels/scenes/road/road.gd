extends Node2D

@export var count = 3
@export var speed: float = 100
@export var dash_size: float = 30
@export var width: float = 100
@export var color: Color = Color(0.586, 0.629, 0.662, 1.0)

var start_x: float = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	start_x-=speed*delta
	if start_x <= -dash_size*2:
		start_x=0
	queue_redraw()
	

func _draw() -> void:
	draw_rect(Rect2(0, 0, get_window().size.x, 10.0), Color.GAINSBORO)
	for i in range(count):
		draw_dashed_line(Vector2(start_x, i*width), Vector2(get_window().size.x+dash_size, i*width), color, 10, dash_size, false)
	
