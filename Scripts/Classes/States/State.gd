#Base State class
class_name State extends Node

@onready var state_machine : StateMachine = self.get_parent()
@onready var actor : CharacterBody2D = state_machine.get_parent()

## Emitted when the state finishes and wants to transition to another state.
signal finished

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state.
func enter() -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
