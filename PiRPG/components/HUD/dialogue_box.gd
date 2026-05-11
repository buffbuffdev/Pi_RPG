class_name DialogueBox extends Control

func _ready() -> void:
	$Panel/RichTextLabel.scroll_active = false
	$Panel/RichTextLabel.visible_ratio = 0.0

func _input(event: InputEvent) -> void:
	var mouse_button = event as InputEventMouseButton
	if mouse_button:
		if mouse_button.pressed:
			if mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				$Panel/RichTextLabel.scroll_active = true
			elif mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
				$Panel/RichTextLabel.scroll_active = true

func set_text(dialogue_text: String) -> void:
	$Panel/RichTextLabel.text = dialogue_text
func trigger():
	show()
func dismiss():
	#$Panel/RichTextLabel.scroll_active = true
	hide()
	$Panel/RichTextLabel.visible_ratio = 0.0

func _physics_process(delta: float) -> void:
	if visible:
		var visible_ratio = $Panel/RichTextLabel.visible_ratio
		visible_ratio = move_toward(visible_ratio, 1.0, delta/$Panel/RichTextLabel.text.length() * 120)
		$Panel/RichTextLabel.visible_ratio = visible_ratio
