tool
extends Button

var img:Sprite
const amplifyFactor = 2
const v2Size = amplifyFactor * Vector2(25,25)

var componentID:String

func _init(componentIDInput="Null"):
	for i in self.get_children():
		i.free()
	self.rect_min_size = v2Size
	self.rect_size = v2Size
	self.rect_position = -0.5 * v2Size
	self.img = Sprite.new()
	if componentIDInput.left(3) != "ud_":
		self.img.texture = load("res://images/Compenents/" + componentIDInput + ".png")
	else:
		self.img.texture = GlobalFunc.load_external_png(componentIDInput.right(3) + ".png")
	self.componentID = componentIDInput
	self.img.scale = self.v2Size / self.img.texture.get_size()
	self.img.position = 0.5 * v2Size
	self.add_child(self.img)

func _pressed():
	if self.get_tree().get_nodes_in_group("Map")[0].status != GlobalFunc.STATUS.idle:
		return
	var newComponent = load("res://scenes/ComponentInDrag.tscn").instance()
	self.get_tree().call_group("Map","set_status",GlobalFunc.STATUS.create_component)
	self.get_tree().call_group("Map","add_child",newComponent)
	newComponent.componentID = self.componentID
	
