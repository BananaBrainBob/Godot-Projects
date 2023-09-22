extends CanvasLayer

func _ready():
	$"MarginContainer/Score Label".text = str(Global.score)

func update_score(value):
	Global.score += value
	$"MarginContainer/Score Label".text = str(Global.score)

