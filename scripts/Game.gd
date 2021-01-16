extends Node2D

var welcome_page:Node2D

func _ready():
	self.welcome_page = $Welcome
	self.welcome_page.connect("new_game_button_pressed",self,"_on_new_game_button_pressed")
	self.welcome_page.connect("load_game_button_pressed",self,"_on_load_game_button_pressed")
	self.welcome_page.connect("custom_game_button_pressed",self,"_on_custom_game_button_pressed")

func _on_new_game_button_pressed():
	var main_game = load("res://scenes/BaseMainGame.tscn").instance()
	self.add_child(main_game)
	var guide_info = load("res://scenes/GuideInfo.tscn").instance()
	self.add_child(guide_info)
	guide_info.start("w0")

func _on_load_game_button_pressed():
	var main_game = load("res://scenes/BaseMainGame.tscn").instance()
	self.add_child(main_game)
	var guide_info = load("res://scenes/GuideInfo.tscn").instance()
	self.add_child(guide_info)
	guide_info.info_load()

func _on_custom_game_button_pressed():
	var main_game = load("res://scenes/BaseMainGame.tscn").instance()
	self.add_child(main_game)
