extends Button

var save_info:Dictionary = {}
var saveDialog:FileDialog

#-----------------------------------------------------------
#---------------------setget--------------------------------
#-----------------------------------------------------------

#-----------------------------------------------------------
#---------------------system--------------------------------
#-----------------------------------------------------------
func _ready():
	self.saveDialog = self.get_tree().get_nodes_in_group("SaveDialog")[0]
	self.saveDialog.connect("file_selected",self,"data_save")

#-----------------------------------------------------------
#---------------------signal--------------------------------
#-----------------------------------------------------------
func _pressed():
	# pop up dialog
	self.saveDialog.invalidate()
	self.saveDialog.popup()
	
	#prepare save file content
	self.get_tree().call_group_flags(2,"Components","connection_update")
	# create_structure_level for CalComponent
	var componentList:Array = self.get_tree().get_nodes_in_group("CalComponents")
	var componentDic:Dictionary = self.get_tree().get_nodes_in_group("Simulation")[0].create_structure_level(componentList)
	
	var IONameList:Array = []
	
	for ilevel in componentDic:
		self.save_info[ilevel] = {}
		for inode in componentDic[ilevel]:
			self.save_info[ilevel][inode.to_string()] = (inode as CalculatedComponent).info_save()
			if (inode as CalculatedComponent).CID.left(3) == "IO_" and inode.linkedDisplay != null:
				while IONameList.has(inode.linkedDisplay.nameEditer.text):
					inode.linkedDisplay.nameEditer.text += "*"
				IONameList.append(inode.linkedDisplay.nameEditer.text)
				self.save_info[ilevel][inode.to_string()]["IOName"] = inode.linkedDisplay.nameEditer.text
	print(self.save_info)

#-----------------------------------------------------------
#---------------------function------------------------------
#-----------------------------------------------------------
func data_save(filepath:String):
	# save data
	var path = filepath.left(filepath.length() - 4)
	print(path)
	var file = File.new()
	file.open(path + ".dat",File.WRITE)#File.WRITE是写模式，并且如果文件不存在会自动新建文件
	file.store_string(var2str(self.save_info))
	file.close()
	
	# save image
	var selected_area_node = load("res://scenes/SelectedArea.tscn").instance()
	self.get_parent().add_child(selected_area_node)
	self.get_tree().get_nodes_in_group("Map")[0].status = GlobalFunc.STATUS.select_save_area
	var selected_area:Rect2 = yield(selected_area_node,"area_selected")
	print(selected_area)
	self.get_tree().get_nodes_in_group("Map")[0].status = GlobalFunc.STATUS.idle
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	var image:Image = get_viewport().get_texture().get_data()
	image.flip_y()
	image = image.get_rect(selected_area)
	var v2Zoom:Vector2 = self.get_tree().get_nodes_in_group("Camera")[0].zoom
	image.resize(image.get_width() * v2Zoom.x,image.get_height() * v2Zoom.y)
	image.save_png(path + ".png")









