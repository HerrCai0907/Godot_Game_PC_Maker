extends Button

onready var map_node:Node2D = self.get_tree().get_nodes_in_group("Map")[0]

func _pressed():
	if map_node.status == GlobalFunc.STATUS.idle:
		for i in map_node.get_children():
			i.queue_free()
