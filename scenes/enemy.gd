extends Area2D

@export var speed := 200
@export var health := 1
@export var points := 100  # Punkte für den Spieler

signal enemy_destroyed(points)

func _physics_process(delta: float) -> void:
	position.y += speed * delta  # Bewegung nach unten
	if position.y > get_viewport().get_visible_rect().size.y:
		queue_free()  # Löschen, wenn außerhalb des Bildschirms

# Wird aufgerufen, wenn der Gegner getroffen wird
func take_damage(damage: int) -> void:
	health -= damage
	print("Gegner getroffen! Gesundheit: ", health)  # Debug
	if health <= 0:
		print("Gegner zerstört! Punkte: ", points)  # Debug
		enemy_destroyed.emit(points)  # Punkte an die Hauptszene senden
		queue_free()  # Gegner löschen

# Kollision mit Area2D (z. B. Laser)
func _on_area_entered(area: Area2D) -> void:
	print("Area-Kollision mit: ", area.name, " | Gruppen: ", area.get_groups())  # Debug
	if area.is_in_group("player_lasers"):
		print("Treffer! Laser erkannt.")  # Debug
		take_damage(1)
		area.queue_free()  # Laser löschen
