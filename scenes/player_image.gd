extends CharacterBody2D

var speed : int= 500;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(100,300);  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("Move_left", "Move_right", "Move_up","Move_down")
	velocity = direction * speed
	move_and_slide()
	
