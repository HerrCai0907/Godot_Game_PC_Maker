class_name IO_Output
extends BasisComponent

#var componentID:String = "Null" setget set_componentID

#var img:Sprite = Sprite.new()
var nameEditer = LineEdit.new()
#var inPointList:Array = [] #Point
#var outPointList:Array = [] #Point
#var calculation_level:int = -1

func _init(Pos=Vector2.ZERO,Deg=0).("IO_Output",1,0,Pos,Deg):
	self.nameEditer.rect_scale = Vector2(0.4,0.4)
	self.nameEditer.rect_position = Vector2(-58 * 0.2 , 10)
	self.add_child(self.nameEditer)
