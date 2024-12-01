class_name QuenchingBasin
extends BaseStation


func add_item(item: BaseItem) -> BaseItem:
	if item is Teapot:
		item.apply(BaseItem.FORCE.FILL)

	return null
