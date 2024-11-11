class_name Sink
extends BaseStation


func add_item(item: BaseItem) -> BaseItem:
	if item is Teapot:
		item.apply(BaseItem.FORCE.FILL)

	return null
