class_name QuenchingBasin
extends BaseStation


func add_item(item: BaseItem) -> BaseItem:
    if item is WeaponItem:
        item.apply(BaseItem.FORCE.COOL)

    return null
