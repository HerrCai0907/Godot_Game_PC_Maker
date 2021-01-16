extends Camera2D

var camera_setting:Dictionary = {}

var click_mouse_pos:Vector2 = Vector2(0,0)
var click_camera_pos:Vector2 = self.offset
var if_click:bool = false

func _ready():
	make_current()
	self.camera_setting = {
		"camera_scale_add" : 0.025,
		"camera_scale_dec" : 0.025,
		"camera_scale_min" : 0
		}

func _input(event):
	# scale change 滚轮控制
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_DOWN:
				if !event.pressed:
					return
				self.offset -= event.position * self.camera_setting.camera_scale_add
				self.zoom += self.camera_setting.camera_scale_add * Vector2.ONE
			BUTTON_WHEEL_UP:
				if !event.pressed:
					return
				if self.zoom[0] >= self.camera_setting.camera_scale_min + self.camera_setting.camera_scale_dec and self.zoom[1] >= self.camera_setting.camera_scale_min + self.camera_setting.camera_scale_dec:
					self.offset += event.position * self.camera_setting.camera_scale_dec
					self.zoom -= self.camera_setting.camera_scale_dec * Vector2.ONE
	# dragging 鼠标拖拽
			BUTTON_RIGHT:
				if !self.if_click and event.pressed:
					self.if_click = true
					self.click_mouse_pos = event.position
					self.click_camera_pos = self.offset
				if self.if_click and !event.pressed:
					self.if_click = false
					self.click_mouse_pos = Vector2(0,0)
	elif event is InputEventMouseMotion and if_click:
		set_position(self.click_camera_pos - (event.position - self.click_mouse_pos) * self.zoom)

func set_position(new_pos:Vector2) -> void:
	self.offset = new_pos
	force_update_scroll()
