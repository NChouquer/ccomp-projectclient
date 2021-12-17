extends Control

onready var vbox = get_node("VBoxContainer")
onready var hbox = get_node("VBoxContainer/HBoxContainer")
onready var chatLog = get_node("VBoxContainer/RichTextLabel")
onready var inputLabel = get_node("VBoxContainer/HBoxContainer/Label")
onready var inputField = get_node("VBoxContainer/HBoxContainer/LineEdit")

var user_name = "[Player]"
var groups = {"OtherPlayer":Color(1, 1, 1).to_html(false),"Self":Color(0.910156, 0.818217, 0.069571).to_html(false),"Server":Color(0.484536, 0.878906, 0.051375).to_html(false)}

func _ready():
	pass

func set_username(username):
	user_name = username
	inputLabel.text = "["+username+"]"

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
			hbox.visible = true
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()
			hbox.visible = false
	
func add_msg_to_log(msg):
	var own_id = get_tree().get_network_unique_id()
	var use_color = groups["Self"]
	if own_id!= msg["u"]:
		use_color = groups["OtherPlayer"]
	chatLog.bbcode_text += '[color=#'+ use_color+']'
	chatLog.bbcode_text += '\n' +msg["m"]
	chatLog.bbcode_text += '[/color]'

func _on_LineEdit_text_entered(new_text):
	if new_text.empty()==false:
		Server.SendChatMessage(inputLabel.text+": "+ new_text)
		print(new_text)
	inputField.text = ""
	
func clearLog():
	chatLog.bbcode_text=""
