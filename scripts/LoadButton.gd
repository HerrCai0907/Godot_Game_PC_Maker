extends Button

var loadDialog:FileDialog

func _ready():
	self.loadDialog = self.get_tree().get_nodes_in_group("LoadDialog")[0]
	self.loadDialog.connect("file_selected",self,"data_load")

func _pressed():
	# pop up dialog
	self.loadDialog.popup()


func data_load(filepath:String):
	self.get_tree().get_nodes_in_group("ComponentMenu")[0].new_component_load(
		"ud_" + filepath.left(filepath.length() - 4)
		)
