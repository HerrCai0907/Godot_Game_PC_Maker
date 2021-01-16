extends Node2D

var status:int = GlobalFunc.STATUS.idle setget set_status
var activeNode:Node = null

func set_status(value):
	var info_display_label:Label = self.get_tree().get_nodes_in_group("InfoDisplay")[0]
	status = value
	match value:
		GlobalFunc.STATUS.idle:
			info_display_label.text = ""
		GlobalFunc.STATUS.create_component:
			info_display_label.text = "create a new component"
		GlobalFunc.STATUS.create_line:
			info_display_label.text = "create line"
		GlobalFunc.STATUS.simulation:
			info_display_label.text = "simulation"
		GlobalFunc.STATUS.select_save_area:
			info_display_label.text = "select image range"
