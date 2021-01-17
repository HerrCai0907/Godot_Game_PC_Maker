tool
extends Node2D

var componentID:String = "PositivePole" setget set_componentID
var img = Sprite.new()

func set_componentID(value:String):
	componentID = value
	if value.left(3) != "ud_":
		(self.img as Sprite).texture = load("res://images/Compenents/" + value + ".png")
	else:
		(self.img as Sprite).texture = GlobalFunc.load_external_png(value.right(3) + ".png")

func _init():
	for i in self.get_children():
		i.free()
	self.componentID = "Null"
	#self.position = -10000 * Vector2.ONE  #void display in game
	self.add_child(self.img)

func _input(event):
	# follow mouse
	if event is InputEventMouseMotion:
		var vCamera:Camera2D = self.get_tree().get_nodes_in_group("Camera")[0]
		self.position = event.position * vCamera.zoom  + vCamera.offset
	elif event is InputEventKey and event.is_pressed():
		match (event as InputEventKey).scancode:
			KEY_R:
				self.rotation_degrees += 90
			KEY_ESCAPE:
				self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.idle)
				self.queue_free()

	# create new component
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			print("add a " + self.componentID + " in ",self.position)
			var newComponent
			if self.componentID.left(3) != "ud_":
				newComponent = load("res://scripts/Components/" + self.componentID +".gd").new(
					self.position,
					self.rotation_degrees)
			else:
				newComponent = load("res://scripts/Components/UserDefinedComponent.gd").new(
					self.position,
					self.rotation_degrees,
					self.componentID)
			self.get_tree().call_group_flags(2,"Map","add_child",newComponent)
			self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.idle)
			get_tree().set_input_as_handled() # stop input
			self.queue_free()

	

