extends Node2D
# При частом перемещении влево вправо из-за операций с float исходная позиция будет смещаться, 
# на коротком промежутке игры наверное пофиг

# скорость перескавивания на другую дорожку
@export var side_speed: int = 230
# расстояние между дорожками
@export var jump_distance: float = 100
@export var max_speed: int = 500
@export var min_speed: int = 50
@export var start_speed: float = 100

# сигнал если скорость (влево/вправо) поменялась
signal speed_changed(speed: float)

var position_up = Vector2(0,0)
var position_down = Vector2(0, jump_distance)

var hitted: bool = false

# скорость игрока
var speed:float = 100
# шаг изменения скорости
var speed_step: float = 10
# визуальная скорость
var speed_visual: float = 100

var moving: bool = false
var move_to: Vector2 = position_down
var side_up: bool = true

var accept_input: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = start_speed
	speed_changed.emit(speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !moving && !hitted:
		accept_input=true		
	
	if hitted:
		hitted_move(delta)
		if side_up:
			moving_to(delta,Vector2(0,jump_distance))
		else:
			moving_to(delta,Vector2(0,0))
		return
	
	if moving:
		accept_input = false
		moving_to(delta, move_to)
		return
	
	if !accept_input:
		return
			
	if Input.is_action_pressed("speed_up"):
		if speed_up(delta):
			speed_changed.emit(speed)
		
	if Input.is_action_pressed("slow_down"):
		if slow_down(delta):
			speed_changed.emit(speed)
	
	if Input.is_action_just_pressed("change_side") && !moving:
		moving = true
		side_up = !side_up
		if side_up:
			move_to = position_up
		else:
			move_to = position_down

func hitted_move(delta: float) -> void:
	$Scooter.rotate(delta*20)
	return

func moving_to(delta: float, dest: Vector2) -> void:
	var distance_to_destination: float = $Scooter.position.distance_to(dest)
	var distance_to_move: float = side_speed * delta
	# if we are close, just move to destination
	if abs(distance_to_destination) < abs(distance_to_move): 
		$Scooter.position = dest
		moving = false
	else:
		$Scooter.position += $Scooter.position.direction_to(dest) * distance_to_move
	return

func speed_up(delta: float)->bool:
	var old_speed = speed
	speed+=speed_step
	if speed >= max_speed:
		speed = max_speed
		if speed == old_speed:
			return false
	else:
		$Scooter.position.x+=speed_visual*delta
		position_up.x = $Scooter.position.x 
		position_down.x = $Scooter.position.x 
	return true
	
func slow_down(delta: float)->bool:
	var old_speed = speed
	speed-=speed_step
	if speed <= min_speed:
		speed = min_speed
		if speed == old_speed:
			return false
	else:
		$Scooter.position.x-=speed_visual*delta
		position_up.x = $Scooter.position.x 
		position_down.x = $Scooter.position.x 
	return true


func _on_hitted(_area: Area2D) -> void:
	hitted = true
	accept_input = false
	position_up.x = 0 
	position_down.x = 0
	speed = min_speed
	speed_changed.emit(speed)
	$HitTimer.start()
	return
	


func _on_hit_timer_timeout() -> void:
	$HitTimer.stop()
	hitted = false
	$Scooter.rotation =0
	
