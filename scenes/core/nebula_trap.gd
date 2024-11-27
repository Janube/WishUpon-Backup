extends CharacterBody2D



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		#var audio_effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(0,0)
		body.nebula_enter()
		var lpf := AudioEffectLowPassFilter.new()
		lpf.cutoff_hz = 20500
		AudioServer.add_bus_effect(0,lpf,0)
		lpf.set_resonance(1)
		lpf.set_db(AudioEffectFilter.FILTER_24DB)
		var reverb := AudioEffectReverb.new()
		AudioServer.add_bus_effect(0,reverb,1)
		reverb.set_room_size(0)
		var audio_tween = create_tween()
		audio_tween.tween_property(lpf,"resonance",0.15,0.5)
		audio_tween.parallel().tween_property(lpf,"cutoff_hz",2000,0.5)
		audio_tween.parallel().tween_property(reverb,"room_size",0.8,0.5)
		

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.nebula_leave()
		var lpf = AudioServer.get_bus_effect(0,0)
		var reverb = AudioServer.get_bus_effect(0,1)
		var audio_tween = get_tree().create_tween()
		#audio_tween.tween_method(lpf.set_resonance,0.15,1,0.5)
		audio_tween.tween_property(lpf,"resonance",1,0.5)
		audio_tween.parallel().tween_property(lpf,"cutoff_hz",20500,0.5)
		audio_tween.parallel().tween_property(reverb,"room_size",0,0.5)
		await audio_tween.finished
		AudioServer.set_bus_effect_enabled(0,0,false)
		AudioServer.set_bus_effect_enabled(0,1,false)
