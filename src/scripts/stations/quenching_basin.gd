class_name QuenchingBasin
extends BaseStation


func add_item(item: BaseItem) -> BaseItem:
    if item is WeaponItem:
        item.apply(BaseItem.FORCE.COOL)
        self._audio_player.play()

    return null
