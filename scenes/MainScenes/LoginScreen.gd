extends Control

onready var username_input = get_node("Panel/username_input")
onready var password_input = get_node("Panel/password_input")
onready var newacct_button = get_node("Panel/newacct_button")
onready var login_button = get_node("Panel/login_button")

func _ready():
	pass

func _process(delta):
	if username_input.text.empty() or password_input.text.empty():
		newacct_button.disabled = true
		login_button.disabled = true
	else:
		newacct_button.disabled = false
		login_button.disabled = false

func _on_login_button_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	Server.SendLogIn(username,password)


func _on_newacct_button_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	Server.SendCreateAccount(username,password)
