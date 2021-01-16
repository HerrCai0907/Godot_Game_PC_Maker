class_name ComponentInMap
extends Node2D

var componentID:String = "Null" setget set_componentID

var img:Sprite = Sprite.new()
var inPointList:Array = [] #Point
var outPointList:Array = [] #Point

var if_time_relevant:bool = false

func display_update():
	pass

func _calculate_finished():
	for i in self.outPointList:
		i.undisplay_value()
	for i in self.inPointList:
		i.undisplay_value()

func set_componentID(value:String):
	componentID = value
	if value.left(3) != "ud_":
		(self.img as Sprite).texture = load("res://images/Compenents/" + value + ".png")
	else:
		(self.img as Sprite).texture = GlobalFunc.load_external_png(value.right(3) + ".png")

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
	var textureSize:Vector2 = (self.img as Sprite).texture.get_size()
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

func get_cal_node(P):
	pass

#func find_parents():
#	var list:Array = []
#	for i in self.inPointList:
#		if (i as Point).find_pair() != null:
#			list.append( ((i as Point).find_pair() as Point).linkedComponent )
#		else:
#			list.append("error")
#	return list
#func find_descendents():
#	var list:Array = []
#	for i in self.outPointList:
#		if (i as Point).find_pair() != null:
#			list.append( ((i as Point).find_pair() as Point).linkedComponent )
#	return list
