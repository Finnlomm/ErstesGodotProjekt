extends Node2D

# 1. Lade die Meteor-Szene
var meteor_scene: PackedScene = preload("res://scenes/meteor.tscn")
var laser_scene: PackedScene = preload("res://scenes/laser.tscn")

func _ready():
	pass  # Timer startet automatisch, da 'Autostart' aktiviert ist

func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)


func _on_player_laser(pos) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos
