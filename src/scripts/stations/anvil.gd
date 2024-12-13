class_name Anvil
extends ProgressiveStation


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is WeaponItem:
        item.reparent(self._inventory)
        self._finished = false
        self.started.emit(self)

        return null
    elif self.has_items() and self._finished:
        var drink: BaseItem = self._inventory.get_child(0).combine(item)

        return drink

    return null


func operate(delta: float) -> void:
    if self.has_items() and not self._finished:
        self._progress += delta * self.progress_rate

        if self._progress >= self.PROGRESS_MAX:
            self._inventory.get_child(0).apply(BaseItem.FORCE.PRESSURE)
            self._finished = true
            self._progress = 0
            self.finished.emit(self.get_instance_id())

        if not self._audio_player.playing:
            self._audio_player.play()
