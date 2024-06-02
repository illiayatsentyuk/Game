extends Area2D

var tween
var tween1

func _on_body_entered(body):
	
	if body.name == "Player":
		tween = get_tree().create_tween()
		tween1 = get_tree().create_tween()
		tween.tween_property(self,'position',position - Vector2(0,25),0.5)
		tween1.tween_property(self,'modulate:a',0,0.3)
		tween.tween_callback(queue_free)
		body.gold+=1
