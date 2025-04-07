extends Control

@onready var nLabel: Label = $HFlowContainer2/Name;
@onready var sLabel: Label = $HFlowContainer2/Score;

@export var Name: String;
@export var Score: String;
	
func _ready() -> void:
	nLabel.text = Name
	sLabel.text = Score
