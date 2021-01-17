class_name Line
extends Line2D

var in_point = null setget set_in_point
var out_point = null setget set_out_point
var if_in_active:bool = true
var if_out_active:bool = true

func set_in_point(value):
	if if_in_active:
		in_point = value
		self.points[0] = cal_point_center_pos(value)
		if if_out_active: #if out not defined, set out point pos same as in point, else finish create
			self.points[1] = cal_point_center_pos(value)
		else:
			self.creating_finished()
		print((value as Control).rect_global_position)
		self.if_in_active = false
	else:
		print("in point has defined")
func set_out_point(value):
	if if_out_active:
		out_point = value
		self.points[1] = cal_point_center_pos(value)
		if if_in_active:
			self.points[0] = cal_point_center_pos(value)
		else:
			self.creating_finished()
		print((value as Control).rect_global_position)
		self.if_out_active = false
	else:
		print("out point has defined")
func creating_finished():
	print("Line.gd lin36--------------------------------")
	self.set_process_input(false)
	self.get_tree().get_nodes_in_group("Map")[0].activeNode = null
	self.get_tree().get_nodes_in_group("Map")[0].status = GlobalFunc.STATUS.idle

static func cal_point_center_pos(point) -> Vector2:
	var tmp1:Vector2 = Vector2(2,2).rotated( deg2rad(point.linkedComponent.rotation_degrees) )
	return (point as Control).rect_global_position + tmp1

func _init():
	self.points = [null,null]
	self.width = 1

func _input(event):
	if !self.if_in_active and !self.if_out_active:
		return
	# follow mouse
	if event is InputEventMouseMotion:
		var vCamera:Camera2D = self.get_tree().get_nodes_in_group("Camera")[0]
		if self.if_in_active:
			self.points[0] = event.position * vCamera.zoom  + vCamera.offset
		elif self.if_out_active:
			self.points[1] = event.position * vCamera.zoom  + vCamera.offset
	elif event is InputEventKey and event.is_pressed():
		match (event as InputEventKey).scancode:
			KEY_ESCAPE:
				self.queue_free()
				self.get_tree().call_group("Map","set","status",GlobalFunc.STATUS.idle)
