extends Node

var IngameMenu: Node2D
var _unitKilledLabel: Label
var _shotsFiredLabel: Label

func ready():
	_unitKilledLabel = IngameMenu.find_child("UnitsKilled")
	_shotsFiredLabel = IngameMenu.find_child("ShotsFired")

var _money: float = 1000.0
var Money: float :
	get:
		return _money
	set(value):
		_money = value

var _health: int = 5
var Health: int:
	get:
		return _health
	set(value):
		_health = value

var _unit_killed: int = 0
var UnitsKilled : int :
	get:
		return _unit_killed
	set(value):
		_unit_killed = value
		_unitKilledLabel.text = str(value)
		
var _shots_fired: int = 0
var ShotsFired : int :
	get:
		return _shots_fired
	set(value):
		_shots_fired = value
		_shotsFiredLabel.text = str(value)
