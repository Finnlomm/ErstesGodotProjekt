extends CanvasLayer

static var image = load("res://assets/PNG/UI/playerLife1_red.png")

func set_health(amount):
	# remve all children
	for child in $MarginContainer2/HBoxContainer.get_children():
		child.queue_free()
		
	#create new children
	for i in amount:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		$MarginContainer2/HBoxContainer.add_child(text_rect)
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP
