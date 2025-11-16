extends Node2D

@export var mamka_scene: PackedScene

var distance: float = 0
var distance_speed: float = 100
var mamka_can_spawn: bool = true

const FIRST_Y: float = 320
const SECOND_Y: float = 420

var mamkas: Array[Area2D]

func _ready() -> void:
	$SpawnTimer.wait_time = randf_range(0.3,1)
	$SpawnTimer.start()
	return


func _process(delta: float) -> void:
	distance += distance_speed*delta
	$ScoresLabel.text = "distance: "+str(int(distance))
	for i in range(mamkas.size()):
		if !mamkas[i-1]:
			mamkas.pop_at(i-1)
	return
	

func _on_player_speed_changed(speed: float) -> void:
	set_speed(speed, false)
	return

func _on_spawn_timer_timeout() -> void:
	if !mamka_can_spawn:
		return
	add_mamka()
	return
	
func _on_treshold_passed() -> void:
	$SpawnTimer.wait_time = randf_range(0.3,1)
	mamka_can_spawn = true
	return

func set_speed(speed: float, force_player:bool)->void:
	if force_player:
		$player.speed=speed
		
	$road.speed = speed
	distance_speed = speed/10
	for i in mamkas:
		if !i:
			continue
		i.speed = speed
	return

func add_mamka():
	mamka_can_spawn = false
	
	var mamka = mamka_scene.instantiate()
	mamka.scale = Vector2(0.28,0.28)
	mamka.speed = $road.speed
	
	var pos:int = randi_range(0,1)
	if pos == 1:
		mamka.starting_y = FIRST_Y
	else:
		mamka.starting_y = SECOND_Y
		
	add_child(mamka)
	mamka.connect("treshold_passed",_on_treshold_passed)
	mamkas.append(mamka)
	return
