extends CharacterBody2D

var speed : int= 500;
signal laser(position)
@onready var laser_cooldown_timer = $LaserCooldownTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(100,300);  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = Input.get_vector("Move_left", "Move_right", "Move_up","Move_down")
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("Shoot") and laser_cooldown_timer.is_stopped():
		laser.emit($LaserStartPosition.global_position)
		laser_cooldown_timer.start()
	
