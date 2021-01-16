extends Node2D

#BG 25+2 pix
const maxMenuCount = 9
const amplifyFactor = 2
var imgBG:Sprite
var left_button:TextureButton
var right_button:TextureButton
var componentInMenuList:Array = []
var componentInMenuStringList:Array = []

var CIM_res:Resource = preload("res://scripts/ComponentInMenu.gd")

var page:int = 0 setget set_page

func _ready():
	# display
	self.imgBG = $BG
	self.imgBG.scale = amplifyFactor * Vector2.ONE
	self.left_button = $LeftButton
	self.right_button = $RightButton
	self.left_button.connect("pressed",self,"_on_left_button_pressed")
	self.right_button.connect("pressed",self,"_on_right_button_pressed")
	
	#init paras
	self.componentInMenuStringList = [
		"Pole_Negative",
		"Pole_Positive",
		"Gate_And",
		"Gate_Or",
		"Gate_Not",
		"IO_Input",
		"IO_Output",
		"Gate_Proliferation",
		"DFF"]
	
	for i in range(self.componentInMenuStringList.size()):
		var tmp2 = self.CIM_res.new(self.componentInMenuStringList[i])
		self.componentInMenuList.append(tmp2)
		self.add_child(tmp2)
		self.CIM_display()
		
func new_component_load(loadedComponentID:String):
	var tmp2 = self.CIM_res.new(loadedComponentID)
	var i = self.componentInMenuStringList.size()
	self.componentInMenuStringList.append(loadedComponentID)
	self.componentInMenuList.append(tmp2)
	self.add_child(tmp2)
	self.page = int(self.componentInMenuList.size() / maxMenuCount)
	self.CIM_display()

func CIM_display():
	# hide all menu
	for ibutton in self.componentInMenuList:
		(ibutton as Button).visible = false
		(ibutton as Button).disabled = true
	# show the menu in this page
	for i in range(
		self.page * maxMenuCount,
		min(self.componentInMenuList.size(),(self.page +1) * maxMenuCount)
		):
		(self.componentInMenuList[i] as Button).rect_position = amplifyFactor * Vector2((i - self.page * maxMenuCount - 4.5) * 27 + 1, -12.5)
		(self.componentInMenuList[i] as Button).visible = true
		(self.componentInMenuList[i] as Button).disabled = false

func set_page(value):
	if value * maxMenuCount + 1 > self.componentInMenuList.size():
		page = int(self.componentInMenuList.size() / maxMenuCount)
	elif value < 0:
		page = 0
	else:
		page = value
func _on_left_button_pressed():
	self.page -= 1
	self.CIM_display()
func _on_right_button_pressed():
	self.page += 1
	self.CIM_display()









