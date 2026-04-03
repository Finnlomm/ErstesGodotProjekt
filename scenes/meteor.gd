extends Area2D

@export var meteor_sprites: Array[Texture2D] = []
@export var min_speed := 200
@export var max_speed := 500
@export var min_rotation_speed := -180.0
@export var max_rotation_speed := 180.0

var speed := 0
var direction := Vector2.DOWN
var rotation_speed := 0.0

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Zufällige Grafik
	if meteor_sprites.size() > 0:
		$Meteor.texture = meteor_sprites[rng.randi() % meteor_sprites.size()]

	# Zufällige Geschwindigkeit
	speed = rng.randf_range(float(min_speed), float(max_speed))

	# Zufällige Richtung (leicht schräg nach unten)
	var random_angle = rng.randf_range(-0.5, 0.5)
	direction = Vector2.DOWN.rotated(random_angle)

	# Zufällige Rotationsgeschwindigkeit
	rotation_speed = rng.randf_range(min_rotation_speed, max_rotation_speed)

	# Startposition: Zufällige X-Position, aber oberhalb des Bildschirms
	var viewport_rect = get_viewport().get_visible_rect()
	position.x = rng.randi_range(0, int(viewport_rect.size.x))
	position.y = viewport_rect.position.y - 50  # 50 Pixel oberhalb des sichtbaren Bereichs

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	rotation_degrees += rotation_speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("Kollision mit: " + body.name)
	queue_free()
