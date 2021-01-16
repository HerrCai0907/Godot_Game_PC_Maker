extends CanvasLayer

onready var history_button:TextureButton = $HistoryButton
onready var help_button:TextureButton = $HelpButton
onready var mission_button:TextureButton = $MissionButton
onready var text_label:RichTextLabel = $TextLabel
onready var history_label:RichTextLabel = $HistoryLabel

var text_dic:Dictionary = {}
var text_key:String = "null"

var history:String = ""

enum STATUS {
	ACTIVE,
	DISACTIVE,
	HISTORY,
	HELP
}

var display_status:int = 0 setget set_display_status
var if_mission_finished:bool = false setget set_if_mission_finished
#-------------------------------------------
#---------------setget----------------------
#-------------------------------------------
func set_display_status(value:int):
	match display_status:
		STATUS.HISTORY:
			self.history_label.visible = false
			self.history_label.bbcode_text = ""
		STATUS.HELP:
			self.text_label.visible = false
	match value:
		STATUS.ACTIVE:
			self.text_label.visible = true
		STATUS.DISACTIVE:
			self.text_label.visible = false
		STATUS.HISTORY:
			self.history_label.visible = true
			self.history_label.bbcode_text = self.history
		STATUS.HELP:
			self.text_label.visible = true
	display_status = value

func set_if_mission_finished(value):
	if_mission_finished = value
	self.mission_button.pressed = value
#-------------------------------------------
#---------------system----------------------
#-------------------------------------------
func _ready():
	var err
	err = self.history_button.connect("pressed",self,"_on_history_button_pressed")
	assert(err==OK)
	err = self.help_button.connect("pressed",self,"_on_help_button_pressed")
	assert(err==OK)
	err = self.mission_button.connect("pressed",self,"_on_mission_button_pressed")
	assert(err==OK)

	self.history_label.visible = false

	self.text_dic = GlobalFunc.get_from_json("res://texts/main_text_ZH.dat")

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		match self.display_status:
			STATUS.ACTIVE:
				get_tree().set_input_as_handled() # stop input
				if if_mission_finished:
					display()
				else:
					self.display_status = STATUS.DISACTIVE
			STATUS.DISACTIVE:
				return
			STATUS.HISTORY:
				self.display_status = STATUS.DISACTIVE
			STATUS.HELP:
				self.display_status = STATUS.DISACTIVE

#-------------------------------------------
#---------------signal---------------------
#-------------------------------------------
func _on_history_button_pressed():
	if self.display_status == STATUS.DISACTIVE:
		self.display_status = STATUS.HISTORY

func _on_help_button_pressed():
	if self.display_status == STATUS.DISACTIVE:
		self.display_status = STATUS.HELP
		display_help()

func _on_mission_button_pressed():
	self.if_mission_finished = self.mission_button.pressed
	if self.if_mission_finished:
		self.info_save()
		self.display_status = STATUS.ACTIVE
		display()
#-------------------------------------------
#---------------function--------------------
#-------------------------------------------
func display():
# display next text from text_key
	if self.text_key == "null": # if null, stop display
		self.display_status = STATUS.DISACTIVE
		return
	self.text_key = self.text_dic[self.text_key]["next"] # goto next key
	if !self.text_dic.has(self.text_key): # if next key not exist, stop display
		self.display_status = STATUS.DISACTIVE
		return
	self.text_label.bbcode_text = self.text_dic[self.text_key]["text"]
	# update if_mission_finished
	self.if_mission_finished = !self.text_dic[self.text_key].has("mission")
	# add into history
	if self.text_dic[self.text_key].text != "":
		self.history += self.text_dic[self.text_key].text + "\n"

func display_help():
	if !self.text_dic[text_key].has("help"): # if this key not have help, stop display
		self.display_status = STATUS.DISACTIVE
		return
	self.text_key = self.text_dic[self.text_key]["help"] # goto help
	self.text_label.bbcode_text = self.text_dic[self.text_key]["text"]
	if self.text_dic[self.text_key].text != "":
		self.history += self.text_dic[self.text_key].text + "\n"

func start(key=self.text_key):
	self.text_key = key
	self.display_status = STATUS.ACTIVE
	display()

func info_save():
	var err:int = 0
	var file = File.new()
	err = file.open("user://archives1.sav",File.WRITE)#File.WRITE是写模式，并且如果文件不存在会自动新建文件
	assert(err == OK)
	file.store_string(self.text_key)
	file.close()
	err = file.open("user://archives2.sav",File.WRITE)#File.WRITE是写模式，并且如果文件不存在会自动新建文件
	assert(err == OK)
	file.store_string(self.history)
	file.close()

func info_load():
	var err:int = 0
	var file = File.new()
	err = file.open("user://archives1.sav",File.READ)#File.WRITE是写模式，并且如果文件不存在会自动新建文件
	assert(err == OK)
	self.text_key = file.get_as_text()
	file.close()
	err = file.open("user://archives2.sav",File.READ)#File.WRITE是写模式，并且如果文件不存在会自动新建文件
	assert(err == OK)
	self.history = file.get_as_text()
	file.close()
	
	start()





