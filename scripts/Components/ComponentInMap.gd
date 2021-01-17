tool
class_name ComponentInMap
extends Node2D

# Property
var componentID:String = "Null" setget set_componentID

# Display
var img:TextureButton = TextureButton.new()
var inPointList:Array = [] #Point
var outPointList:Array = [] #Point
onready var map_node = self.get_tree().get_nodes_in_group("Map")[0]
# Status
#var if_time_relevant:bool = false
var if_moving:bool = false
var init_mouse_pos:Vector2 = Vector2.ZERO
var init_self_pos:Vector2 = Vector2.ZERO
#------------------------------------------------------------------
#------------------------------setget------------------------------
#------------------------------------------------------------------
func set_componentID(value:String):
	componentID = value
	if value.left(3) != "ud_":
		(self.img as TextureButton).texture_normal = load("res://images/Compenents/" + value + ".png")
	else:
		(self.img as TextureButton).texture_normal = GlobalFunc.load_external_png(value.right(3) + ".png")
	self.img.rect_position = -(self.img as TextureButton).texture_normal.get_size() / 2

#------------------------------------------------------------------
#------------------------------system------------------------------
#------------------------------------------------------------------
func _init(ID="Null", inSize=0, outSize=0, Pos=Vector2.ZERO, Deg=0):
	for i in self.get_children():
		i.free()
	
	# basis setting
	self.add_to_group("Components")

	# position
	self.position = Pos
	self.rotation_degrees = Deg
	
	# create img
	self.componentID = ID
	self.add_child(self.img)
	
	# create point
	var tmp1:Resource = load("res://scenes/Components/Point.tscn")
	var tmp2 # Point
	var textureSize:Vector2 = (self.img as TextureButton).texture_normal.get_size()
	# create in point
	for i in range(inSize):
		tmp2 = tmp1.instance()
		self.add_child(tmp2)
		tmp2.rect_position = Vector2(
			- textureSize.x / 2 - 2 ,
			textureSize.y * (0.5 - float(i + 1) / float(inSize + 1)) -2
			)
		self.inPointList.append(tmp2)
		tmp2.status = 0
		tmp2.linkedComponent = self
		tmp2.PointID = String(i)
	# create out point
	for i in range(outSize):
		tmp2 = tmp1.instance()
		self.add_child(tmp2)
		tmp2.rect_position = Vector2(
			textureSize.x / 2 - 2 ,
			textureSize.y * (0.5 - float(i + 1) / float(outSize + 1)) -2
			)
		self.outPointList.append(tmp2)
		tmp2.status = 1
		tmp2.linkedComponent = self
		tmp2.PointID = String(i)

func _ready():
	self.img.connect("pressed",self,"_on_img_pressed")

func _input(event):
	if !self.if_moving:
		return
	if event is InputEventMouseMotion:
		self.position = (
			self.init_self_pos + (event.position - self.init_mouse_pos) * 
			self.get_tree().get_nodes_in_group("Camera")[0].zoom
			)
		for i_point in self.inPointList:
			var linked_line:Line = (i_point as Point).line
			if linked_line == null:
				continue
			linked_line.points[0] = linked_line.cal_point_center_pos(i_point)
		for i_point in self.outPointList:
			var linked_line:Line = (i_point as Point).line
			if linked_line == null:
				continue
			linked_line.points[1] = linked_line.cal_point_center_pos(i_point)
	elif event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			self.map_node.status = GlobalFunc.STATUS.idle
			self.queue_free()

func _exit_tree():
	for i_point in self.inPointList:
		var linked_line:Line = (i_point as Point).line
		if linked_line == null:
			continue
		linked_line.queue_free()
	for i_point in self.outPointList:
		var linked_line:Line = (i_point as Point).line
		if linked_line == null:
			continue
		linked_line.queue_free()
#------------------------------------------------------------------
#------------------------------signal------------------------------
#------------------------------------------------------------------
func _on_img_pressed():
	if self.map_node.status == GlobalFunc.STATUS.idle:
		self.map_node.status = GlobalFunc.STATUS.move_component
		self.if_moving = true
		self.init_mouse_pos = self.get_viewport().get_mouse_position()
		self.init_self_pos = self.position
	elif self.if_moving:
		self.map_node.status = GlobalFunc.STATUS.idle
		self.if_moving = false
#------------------------------------------------------------------
#----------------------------function------------------------------
#------------------------------------------------------------------
func display_update():
	pass

func _calculate_finished():
	for i in self.outPointList:
		i.undisplay_value()
	for i in self.inPointList:
		i.undisplay_value()

func get_cal_node(P):
	pass
