extends Node

signal updated_text
signal finished_text
signal message_list_empty

func speak(message):
	done = false
	spoken_text = ""
	for character in message:
		soundQueue.append(character)
	play_audio()

var message_list = []
func speak_lines(list_of_messages : Array = []):
	message_list = message_list + list_of_messages
	if len(message_list) > 0:
		speak(message_list.pop_front())
	else:
		emit_signal("message_list_empty")

var audio_player : AudioStreamPlayer
var speaking_timer : Timer
var speaker = "default"
var soundQueue = []
var spoken_text = ""
var playing_speech = false
var done = true
export var voice_pitch : float = 1

func play_audio():
	playing_speech = true
	if not audio_player:
		audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
	if not speaking_timer:
		speaking_timer = Timer.new()
		speaking_timer.connect("timeout", self, "play_audio")
		add_child(speaking_timer)
		
	audio_player.pitch_scale = voice_pitch
	
	if len(soundQueue) > 0:
		var letter = soundQueue.pop_front()
		var audio_file = "res://Assets/Sfx/Speakers/" + speaker + ".wav"
		var track : AudioStream
		
		spoken_text = spoken_text + letter
		emit_signal("updated_text")
		if letter in " ,-'\"\n":
			speaking_timer.start(0.05)
			return
		elif letter in ".!":
			speaking_timer.start(0.15)
			return
		elif load(audio_file):
			track = load(audio_file)
			audio_player.stream = track
			audio_player.play()
			speaking_timer.start(track.get_length())
		else:
			print("No sound for: " + str(speaker))
	else:
		playing_speech = false
		if len(soundQueue) == 0:
			if not done:
				emit_signal("finished_text")
				done = true
			
func del_obj(obj):
	obj.queue_free()
