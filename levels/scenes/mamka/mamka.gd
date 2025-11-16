extends Area2D

signal treshold_passed()

@export var starting_y: float = 320
@export var speed: float = 100

var width: float = 100

func _ready() -> void:
	position.y = starting_y
	position.x = get_window().size.x+100
	

func _process(delta: float) -> void:
	position.x-=speed*delta
	var thr: float = get_window().size.x-width
	if position.x >= thr-speed*delta && position.x <= thr+speed*delta:
		# можно ли запускать новую мамку, сигнал нужен для того, чтоб сообщить что мамкой пройден путь
		# достаточный чтоб игроку можно было проскочить
		treshold_passed.emit()
		
	if position.x < -width:
		queue_free()
		
