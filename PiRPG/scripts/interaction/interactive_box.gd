extends Area2D

@export var trigger_node: Node = null
@export var is_unique: bool = false
var is_interacting: bool = false
var is_locked: bool = false
var has_bodies: bool = false

@export_multiline var dialogue_text: String = ""

func _ready() -> void:
	$Label.text = str("Press Spacebar to interact")

func _unhandled_input(event: InputEvent) -> void:#(event: InputEvent) -> void:
	has_bodies = not get_overlapping_bodies().is_empty()
	if has_bodies and not is_interacting:
		if event as InputEventKey:
			if event.is_action_pressed("interact"):
				interact()
	if event.is_action_pressed("ui_cancel"):
		dismiss()
	if trigger_node and not has_bodies:
		dismiss()

func _process(_delta: float) -> void:
	if trigger_node is DialogueBox:
		if not trigger_node.visible:
			is_interacting = false
	if is_locked:
		is_interacting = true
		#queue_free()
		return
	$Label.visible = not is_interacting and has_bodies

func interact():
	is_interacting = true
	if is_locked:
		return
	if is_unique:
		is_locked = true
		queue_free()
	if trigger_node and trigger_node.has_method("trigger"):
		trigger_node.trigger()
	if trigger_node is DialogueBox and not dialogue_text.is_empty():
		trigger_node.set_text(dialogue_text)

func dismiss():
	is_interacting = false
	if trigger_node and trigger_node.has_method("dismiss"):
		trigger_node.dismiss()
