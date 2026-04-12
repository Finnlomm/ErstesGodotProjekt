extends Node2D

# Spawn-Parameter für progressive Schwierigkeit
@export var initial_spawn_interval := 2.0  # Anfangs-Intervall in Sekunden
@export var min_spawn_interval := 0.5     # Minimales Intervall
@export var interval_decrease := 0.1      # Um wie viel das Intervall verkürzt wird
@export var time_until_next_decrease := 10.0  # Alle 10 Sekunden wird das Intervall verkürzt

# Timer-Nodes (müssen in der Szene vorhanden sein!)
@onready var difficulty_timer = $DifficultyTimer
@onready var enemy_timer = $EnemyTimer

# Aktuelles Spawn-Intervall
var current_spawn_interval := initial_spawn_interval

# 1. Lade die Meteor-Szene
var meteor_scene: PackedScene = preload("res://scenes/meteor.tscn")
var laser_scene: PackedScene = preload("res://scenes/laser.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var health = 3

func _ready():
	pass  # Timer startet automatisch, da 'Autostart' aktiviert ist
	
	#set up health ui
	get_tree().call_group("ui", "set_health", health)
	
	#stars
	var size := get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	for star in $Stars.get_children():
		var random_x = rng.randi_range(0, int(size.x))
		var random_y = rng.randi_range(0, int(size.y))
		star.position = Vector2(random_x, random_y)
		
		#scale 
		var random_scale = rng.randf_range(0.5,1.5)
		star.scale = Vector2(random_scale, random_scale)
	
		#speed
		star.speed_scale = rng.randf_range(0.6, 2)
	
	# Timer für progressive Spawns konfigurieren
	$MeteorTimer.wait_time = current_spawn_interval  # Nutzt deinen bestehenden MeteorTimer
	difficulty_timer.wait_time = time_until_next_decrease
	difficulty_timer.start()
	
	enemy_timer.wait_time = 5.0
	enemy_timer.start()
	
func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	
	# connect the signal
	meteor.connect("collision", on_meteor_collision)
	$MeteorTimer.start(current_spawn_interval)
	
# Wird aufgerufen, wenn der DifficultyTimer abläuft
func _on_difficulty_timer_timeout() -> void:
	current_spawn_interval = max(current_spawn_interval - interval_decrease, min_spawn_interval)
	$MeteorTimer.wait_time = current_spawn_interval  # Aktualisiere den MeteorTimer
	difficulty_timer.start(time_until_next_decrease)
	print("Schwierigkeit erhöht! Neues Spawn-Intervall: ", current_spawn_interval)

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	$Enemies.add_child(enemy)
	enemy.position.x = randf_range(0, get_viewport().get_visible_rect().size.x)
	enemy.position.y = -50  # Oberhalb des Bildschirms

func on_meteor_collision():
	health -= 1
	get_tree().call_group("ui", "set_health", health)
	
	if health <= 0:
		call_deferred("_load_game_over")
	

func _on_player_laser(pos) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos

func _load_game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
