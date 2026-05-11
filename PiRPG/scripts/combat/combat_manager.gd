class_name CombatManager extends Node2D

enum parent_type {
	PLAYER, NPC
}
@export var controller_type: parent_type
var parent = null
var control_data: Dictionary = {}
# |----- Disclaimer -------
# | I was trying to fix the previous implementation of the mobs/enemies but
# | ended up realizing it was "smarter" by remaking them instead of fix each 
# | part that was meant to be modular.
# | 
# | This is just a part of a code you might see later on in production. For now
# | it's just a sample for combats/attacks.
# | 
# | I tried fixing stuff so this was my first "implementation".
# | It might be used later on, just let us "fix" the movement and player recognition
# | on enemies/mobs or else it will be too "specific just for mobs.
# | 
# | This code is meant for modular purposes, so instead of making 1 source code
# | for each mob/entity on the game, make it all here and each element has it's own
# | use of this.
# | 
# | All the rest might be the same code I picked before.
# | ---------------------


# Fireball scene
var fireball_scene = preload("res://scripts/combat/projectile/fireball.tscn")

const PLAYER_FIREBALL_SPEED = 120
const PLAYER_FIREBALL_LIFETIME = 1.5

const MOB_FIREBALL_SPEED = 80
const MOB_FIREBALL_LIFETIME = 3.0

func _ready() -> void:
	_create_stats()
	#print(parent)

func _unhandled_input(event: InputEvent) -> void:
	if controller_type == parent_type.PLAYER:
		if event.is_action_pressed("shoot"):
			#var _parent = get_parent() as Player
			#shoot_fireball(_parent.picked_direction)
			var scanner = control_data["enemy_scan"] as EnemyScanner
			if scanner and scanner.available_enemy:
				shoot_fireball(
					global_position.direction_to(scanner.available_enemy.global_position)
				)
			else:
				shoot_fireball(
					global_position.direction_to(get_global_mouse_position())
				)

func _create_stats():
	match controller_type:
		parent_type.PLAYER:
			parent = get_parent() as Player
			control_data["enemy_scan"] = get_node("EnemyScanner")
			control_data["attack"] = {
				"fireball": {
					"lifetime": PLAYER_FIREBALL_LIFETIME,
					"speed": PLAYER_FIREBALL_SPEED
				}
			}
		parent_type.NPC:
			parent = get_parent() as EnemyBase
			control_data["attack"] = {
				"fireball": {
					"lifetime": MOB_FIREBALL_LIFETIME,
					"speed": MOB_FIREBALL_SPEED
				}
			}

# -----------------------------
# Shoot a fireball in the movement direction
# -----------------------------
func shoot_fireball(target_direction: Vector2) -> void:
	# Only shoot if the mob has a valid movement direction
	#if last_input_vector == Vector2.ZERO:
		#return

	# Instantiate fireball
	#var fireball = fireball_scene.instantiate()
	#fireball.global_position = global_position + last_input_vector.normalized()
	#fireball.direction = last_input_vector
	#fireball.rotation = last_input_vector.angle()
	#get_tree().current_scene.add_child(fireball)
	var fireball = fireball_scene.instantiate() as FireballAttack
	fireball.setup(
		global_position, target_direction, #From | To
		control_data["attack"]["fireball"]["lifetime"],
		control_data["attack"]["fireball"]["speed"],
		parent.collision_layer, parent.collision_mask
	)
	
	get_tree().get_nodes_in_group("trash").front().add_child(fireball)
