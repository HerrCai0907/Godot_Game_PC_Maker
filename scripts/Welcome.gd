extends Node2D

var new_game_button:Button
signal new_game_button_pressed
var load_game_button:Button
signal load_game_button_pressed
var custom_game_button:Button
signal custom_game_button_pressed

func _ready():
	self.new_game_button = $NewGameButton
	self.new_game_button.connect("pressed",self,"_on_new_game_button_pressed")
	self.load_game_button = $LoadGameButton
	self.load_game_button.connect("pressed",self,"_on_load_game_button_pressed")
	self.custom_game_button = $CustomGameButton
	self.custom_game_button.connect("pressed",self,"_on_custom_game_button_pressed")

func _on_new_game_button_pressed():
	print("Begin New Game")
	emit_signal("new_game_button_pressed")
	self.queue_free()
func _on_load_game_button_pressed():
	print("Load Game")
	emit_signal("load_game_button_pressed")
	self.queue_free()
func _on_custom_game_button_pressed():
	print("Begin Custom Game")
	emit_signal("custom_game_button_pressed")
	self.queue_free()
