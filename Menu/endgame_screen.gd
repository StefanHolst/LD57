extends Control

@onready var TimeLbl: Label = $Panel/StatusLbl
@onready var ScoreLbl: Label = $Panel/ScoreLbl
@onready var nameEdit: LineEdit = $Panel/nameEdit
@onready var submitButton: Button = $Panel/Button
@onready var statusLbl: Label = $Panel/StatusLbl
@onready var req: HTTPRequest = $HTTPRequest;

var t: float;
var s: float;

@export var won: bool:
	get:
		return t
	set(value):
		t = value
		if value == true:
			TimeLbl.text = "YOU WON!"
		else:
			TimeLbl.text = "Game over"

@export var credits: float:
	get:
		return s
	set(value):
		s = value
		ScoreLbl.text = "You earned {0} credits".format([value])

func name_changed(new_text: String) -> void:
	var name: String = nameEdit.text
	var isValid = name != ""
	submitButton.disabled = !isValid

func onSubmit() -> void:
	var name: String = nameEdit.text
	print("Submitted '{0}'".format([name]))
	
	statusLbl.text = "Submitting..."
	statusLbl.visible = true
	
	var headers = ["Content-Type: application/json"]
	var data = JSON.stringify({"Score": int(credits), "Name": name })
	req.request("https://ld57.j-software.dk/highscores", headers, HTTPClient.METHOD_POST, data)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if (result == 0) && (response_code == 200):
		get_tree().change_scene_to_file("res://Menu/Highscore.tscn")
	else:
		statusLbl.text = "Error: {0}, {1}".format([result, response_code])

func _on_name_edit_text_submitted(new_text: String) -> void:
	onSubmit()
