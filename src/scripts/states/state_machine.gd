# The `StateMachine` manages `State` classes that manage the state of the root
# node.
class_name StateMachine
extends Node


@export var initial_state: State.STATENAME

var _states: Dictionary = {}
var _tda: Array[State.STATENAME] = []


func _ready() -> void:
    # Register all child states
    for child: Node in self.get_children():
        if not child is State:
            continue

        assert(not child.state_name in self._states, "Cannot set duplicate state")

        child.finished.connect(self._on_finished_state)
        child.property_set.connect(self._on_property_set_state)
        child.state_changed.connect(self._on_state_changed_state)
        self._states[child.state_name] = child

    # Enter initial state
    assert(self.initial_state != null, "Missing initial state")
    assert(self.initial_state in self._states, "Unable to find initial state")
    self._tda.append(self.initial_state)
    self.__top().enter()


func notify(event: InputEvent) -> void:
    self.__top().notify(event)


func update(delta: float) -> void:
    self.__top().update(delta)


func __top() -> State:
    return self._states[self._tda[-1]]


# Called when the top state sends a `finished` signal.
# This is typically called when the top state has completed its task and has no
# further actions to take, then the entity is reverted back to its previous
# state.
func _on_finished_state() -> void:
    self.__top().exit()
    self._tda.pop_back()
    self.__top().enter()


# Called when the top state sends a `property_set` signal.
# This is typically called when a state needs to tell the incoming state
# information about the entity's current state.
func _on_property_set_state(
    state_name: State.STATENAME,
    property: StringName,
    value: Variant,
) -> void:
    self._states[state_name].set(property, value)


# Called when the top state needs to change state.
# This is typically called when the top state needs to change to a different
# state, and the new state is added to the stack.
# The top state can also optionally indicated if it has completed its task, in
# which case, it will be removed from the stack first. Otherwise, once the new
# state has completed its task, the current state will be re-entered.
func _on_state_changed_state(
    state_name: State.STATENAME,
    finished: bool = false,
) -> void:
    self.__top().exit()

    if finished:
        self._tda.pop_back()

    self._tda.append(state_name)
    self.__top().enter()