extends Node2D

@onready var light = $DirectionalLight2D
@onready var poinLight1 = $PointLight2D
@onready var pointLight=$PointLight2D2
@onready var DayText = $CanvasLayer/Days
@onready var animPlayer = $CanvasLayer/AnimationPlayer
var days_count: int

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}
var state = MORNING
func _ready():
	light.enabled = true
	days_count = 1
	set_day_text()
	day_text_fade()
func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light,'energy',0.2,20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(poinLight1,'energy',0,20)
	tween1.tween_property(pointLight,'energy',0,20)

func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light,'energy',0.95,20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(poinLight1,'energy',1.5,20)
	tween1.tween_property(pointLight,'energy',1.5,20)

func _on_daynight_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		state += 1
	else:
		state = MORNING
		days_count += 1
		set_day_text()
		day_text_fade()
func day_text_fade():
	animPlayer.play("day_text_appearing")
	await  get_tree().create_timer(2).timeout
	animPlayer.play("day_text_dissapearing")
func set_day_text():
	DayText.text = 'DAY: ' + str(days_count)
