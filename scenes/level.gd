extends Node2D

# 1. Lade die Meteor-Szene
var meteor_scene: PackedScene = preload("res://scenes/meteor.tscn")
var laser_scene: PackedScene = preload("res://scenes/laser.tscn")

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
func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	
	# connect the signal
	meteor.connect("collision", on_meteor_collision)

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
