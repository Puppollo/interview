extends Area2D

@export var speed: int = 100

var scale_grow: bool = true

@export var scale_step_x: float = 0.001
@export var scale_step_y: float = 0.003
@export var grow_steps: int = 3

var default_scale: Vector2
var default_max_x: float
var default_min_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_scale = $Sprite2D.scale
	default_max_x = default_scale.x+scale_step_x*grow_steps
	default_min_x = default_scale.x-scale_step_x*grow_steps
	print(default_scale,", ", default_max_x,", ", default_min_x,", ",scale_step_x*grow_steps)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if scale_grow:
		$Sprite2D.scale.x+=scale_step_x+(scale_step_x*delta)
		$Sprite2D.scale.y-=scale_step_y-(scale_step_y*delta)
		if $Sprite2D.scale.x >= default_max_x:
			scale_grow=false
			$Sprite2D.scale = Vector2(default_scale+Vector2(scale_step_x*grow_steps,scale_step_y*grow_steps))
	else:
		$Sprite2D.scale.x-=scale_step_x-(scale_step_x*delta)
		$Sprite2D.scale.y+=scale_step_y+(scale_step_y*delta)
		if $Sprite2D.scale.x <= default_min_x:
			scale_grow=true
			$Sprite2D.scale= Vector2(default_scale-Vector2(scale_step_x*grow_steps,scale_step_y*grow_steps))
		
