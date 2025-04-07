extends Control

var hsItem = preload("res://Menu/HighscoreItem.tscn")

@onready var hsList: VFlowContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HighscoreList;
@onready var loadLabel: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Loading;
@onready var req: HTTPRequest = $HTTPRequest;

func Exit():
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
	pass

func _ready() -> void:
	req.request("https://ld57.j-software.dk/highscores")

func loadData(data) -> void:
	for i in data:
		var item = hsItem.instantiate() as Control
		item.update_minimum_size()
		item.Name = i["name"]
		item.Score = str(int(i["score"]))
		hsList.add_child(item)
	
	loadLabel.visible = false

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if (result == 0) && (response_code == 200):
		loadData(JSON.parse_string(body.get_string_from_utf8()))
	else:
		loadLabel.text = "Error: {0}, {1}".format([result, response_code])
