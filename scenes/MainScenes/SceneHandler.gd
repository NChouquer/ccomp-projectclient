extends Node

var scenes = {
	"Map":preload("res://scenes/MainScenes/Map.tscn"),
	"LoginScreen":preload("res://scenes/MainScenes/LoginScreen.tscn")
	}

var current_scenename = "LoginScreen"
var current_scene

func _ready():
	var map_instance = scenes["Map"].instance()
	current_scene = map_instance
	add_child(map_instance)
	
func switch_to_scene(scenename,args = null):
	current_scenename = scenename
	current_scene.start_state("Map",args)
	
