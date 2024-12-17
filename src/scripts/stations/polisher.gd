class_name Polisher
extends ProgressiveStation


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is WeaponItem and item.state == WeaponItem.STATE.SHARPENED:
        item.reparent(self._inventory)
        self._finished = false
        self.started.emit(self)

    return null


func operate(delta: float) -> void:
    if self.has_items() and not self._finished:
        self._progress += delta * self.progress_rate

        if self._progress >= self.PROGRESS_MAX:
            self._inventory.get_child(0).apply(BaseItem.FORCE.POLISH)
            self._finished = true
            self.finished.emit(self.get_instance_id())

        if not self._audio_player.playing:
            self._audio_player.play()
