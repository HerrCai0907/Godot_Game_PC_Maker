class_name Point
extends TextureButton

var status:int = -1 setget set_status# in:0; out:1; NA:-1
var PointID

var line:Line = null
var linkedComponent = null

var valueDisplay = Label.new()
onready var map_node = self.get_tree().get_nodes_in_group("Map")[0]

func _init(PID=null):
	self.valueDisplay.rect_position = Vector2(0,-10)
	self.add_child(self.valueDisplay)
	self.rect_min_size = 4 * Vector2.ONE
	
	self.PointID = PID

func set_status(inputValue:int):
	status = inputValue
	if inputValue == 0:
		self.texture_normal = load("res://images/Compenents/Point.png")
		self.texture_pressed = load("res://images/Compenents/Point-Pressed.png")
	elif inputValue == 1:
		self.texture_normal = load("res://images/Compenents/Point2.png")
		self.texture_pressed = load("res://images/Compenents/Point-Pressed.png")

func _pressed():
	print("Point.gd: point on pressed")
	if self.line != null:
		self.line.queue_free()
		self.map_node.status = GlobalFunc.STATUS.idle
	print(self.map_node.status)
	match self.map_node.status:
		GlobalFunc.STATUS.idle:
			self.line = load("res://scenes/Components/Line.tscn").instance()
			self.map_node.status = GlobalFunc.STATUS.create_line
			self.map_node.activeNode = self.line
			self.map_node.add_child(self.line)
			if self.status == 0:
				self.line.in_point = self
			elif self.status == 1:
				self.line.out_point = self
		GlobalFunc.STATUS.create_line:
			self.line = self.map_node.activeNode
			if self.status == 0:
				self.line.in_point = self
			elif self.status == 1:
				self.line.out_point = self

func find_pair():
	if self.line == null:
		return null
	match self.status:
		0:
			return self.line.out_point
		1:
			return self.line.in_point

func display_value(value):
	self.valueDisplay.visible = true
	self.valueDisplay.text = "1" if value else "0"
func undisplay_value():
	self.valueDisplay.visible = false



