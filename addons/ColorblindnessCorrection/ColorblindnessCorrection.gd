## Modified by Bytez under GPLv3
## https://github.com/bytezz/godot-ColorblindnessCorrection
## Original by Paul Joannon under MIT License
## https://github.com/paulloz/godot-colorblindness
## ----
## Colorblindness correction shader to better contrast colors.
## (for Godot Game Engine).

tool
class_name ColorblindnessCorrection
extends CanvasLayer

enum TYPE { None, Protanopia, Deuteranopia, Tritanopia }

export(TYPE) onready var Type = TYPE.None setget set_type
var temp = null
var tempIntensity = null

export(float, 0.0, 1.0, 0.1) onready var Intensity = 1.0 setget set_intensity

var rect = ColorRect.new()

func set_type(value):
	if rect.material:
		rect.material.set_shader_param("type", value)
	else:
		temp = value
	Type = value

func set_intensity(value):
	if rect.material:
		rect.material.set_shader_param("intensity", value)
	else:
		tempIntensity = value
	Intensity = value

func _ready():
	self.add_child(self.rect)
	
	self.rect.rect_min_size = self.rect.get_viewport_rect().size
	self.rect.material = load("res://addons/ColorblindnessCorrection/ColorblindnessCorrection.material")
	self.rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	if self.temp:
		self.Type = self.temp
		self.temp = null
	if self.tempIntensity:
		self.Intensity = self.tempIntensity
		self.tempIntensity = null
	
	self.get_tree().root.connect('size_changed', self, '_on_viewport_size_changed')

func _on_viewport_size_changed():
	self.rect.rect_min_size = self.rect.get_viewport_rect().size
