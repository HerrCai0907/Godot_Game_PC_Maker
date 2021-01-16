class_name IO_Input
extends BasisComponent

#var componentID:String = "Null" setget set_componentID

#var img:Sprite = Sprite.new()
var inputButton = TextureButton.new()
var nameEditer = LineEdit.new()
#var inPointList:Array = [] #Point
#var outPointList:Array = [] #Point
#var calculation_level:int = -1

func _init(Pos=Vector2.ZERO,Deg=0).("IO_Input",0,1,Pos,Deg):
	self.inputButton.toggle_mode = true
	self.inputButton.rect_position = -Vector2.ONE * 8
	self.inputButton.texture_normal = load("res://images/Compenents/IO_Input_False.png")
	self.inputButton.texture_pressed = load("res://images/Compenents/IO_Input_True.png")
	self.add_child(self.inputButton)
	self.inputButton.connect("pressed",self,"_on_switched")
	
	self.nameEditer.rect_scale = Vector2(0.4,0.4)
	self.nameEditer.rect_position = Vector2(-58 * 0.2 , 10)
	self.add_child(self.nameEditer)

func _on_switched():
	(self.calNode as CalculatedComponent).data = !(self.calNode as CalculatedComponent).data
#	if self.get_tree().get_nodes_in_group("Map")[0].status == GlobalFunc.STATUS.Simulation:
#		self.get_tree().call_group("Simulation","simulation_main_process")
