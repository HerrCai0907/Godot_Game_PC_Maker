extends Sprite

var if_active:bool = false
const TEXTURE_SIZE = Vector2(64,64)

var pos1:Vector2 = Vector2.ZERO
var pos2:Vector2 = Vector2.ZERO

signal area_selected

func _init():
	self.centered = false
	self.z_index = 1
	self.visible = false
	self.scale = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if !self.if_active:
			self.if_active = true
			self.visible = true
			self.pos1 = event.position
		else:
			self.pos2 = event.position
			emit_signal("area_selected",self.parameters_emit())
			self.visible = false
			self.queue_free()
	elif event is InputEventMouseMotion:
		if self.if_active:
			self.pos2 = event.position
			self.display_update()

func display_update():
	self.position = Vector2(min(pos1.x,pos2.x),min(pos1.y,pos2.y))
	self.scale = Vector2(abs(pos1.x - pos2.x),abs(pos1.y - pos2.y)) / TEXTURE_SIZE

func parameters_emit() -> Rect2:
	return Rect2(min(pos1.x,pos2.x),min(pos1.y,pos2.y),abs(pos1.x - pos2.x),abs(pos1.y - pos2.y))

