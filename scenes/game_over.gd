extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Ui_accept"):
		_restart_game()
		
func _restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")

				
