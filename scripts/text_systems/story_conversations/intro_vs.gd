extends Node

var out       : Node

func _ready():
	out        = get_node("out")


func link(var enum_link : RichTextLabel, var title_link : Label, var victime : Object, var id : int):
	out.link(enum_link,title_link,victime,id)
	# clean current status
	out.clear_text()

func get_id()-> int:
	return out.get_id()

func end():
	out.end()

func pause():
	out.pause()


func say_t(var char_id : int, var text : String, var wait : float):
	  yield(out.say_t(char_id, text, wait), "completed")

func start():
	var enum_choice
	var t1 : int
	var t2 : int
	var tb : int
	var tB : int

#	enum_choice = out.say_enum(["How are you","Word","Life is a lie"],
#				  [" * he said smiling * ", ""," * he said depressingly * "],
#				  [],[],[] )
#	match enum_choice :
#		0:
#			out.say_t(1,"Good and you ?")
#		1:
#			out.say_t(1,"What ??")
#		2:
#			out.say_t(1,"How is it a lie ?")
	out.set_title("You")
	out.set_char_timer(0.1)
	yield(say_t(9, "I saw only black.",1.0), "completed")
	yield(say_t(9, "Couldn’t open my eyes – or they were open, and blackness turned to nothingness, I could not see. I should be able to see - I know I should, if that’s the one thing I can remember.",0.1),"completed")
	yield(say_t(9, "Of course, I guess you could say I also remember I should be able to remember [i]something[/i]. Like – why are there words, floating in the ether, words I can see while I can’t see, words that I think, these words.",0.1), "completed")
	yield(say_t(9, "Thus, I remembered a third thing – your thoughts are not supposed to jump out like that.",0.1), "completed")
	out.set_title("You and your Ghostly Thought")
	yield(say_t(10, "Hello.",1.0), "completed")
	enum_choice = yield(out.say_enum(["Hello? That wasn’t… me."],[],[]), "completed")
	yield(say_t(10,"Yes and no. It is you, some version of you.",0.1), "completed")
	enum_choice = yield(out.say_enum(["Huh?","What… who…"],[],[]), "completed")
	yield(say_t(10, "Think about it. No memory – trauma, clear as day. You know the interface chip can do all sorts of things when the brain gets damaged.",0.1), "completed")
	yield(say_t(9, "Interface chip. The memory came, of course, brain universal interface. A mess of wires, growing through a brain like a fungus. Connecting what should stay broken.",0.1), "completed")
	out.set_title("You and your Daughter")
	yield(say_t(1,"Are you [url=A]awake[/url]?",0.1), "completed")
	
	enum_choice = yield(out.say_enum(
		["Yes, daughter", "I’m not quite sure… are you… my daughter?"],
		["How would I know if I’m awake?"],
		["A"]
		), "completed")
	
	match enum_choice :
		0 :
			out.set_event( "P03", out.get_event( "P03")- 1)
			yield(say_t(1, "Good, I was worried! We should get out of the room, can you get up?",0.1),"completed")
		1,2 :
			yield(say_t(1, "Yes, are you OK? We should get out of here… can you get up?",0.1),"completed")
		3 :
			out.set_event("P03", out.get_event( "P03") + 1)
			yield(say_t(1, "Well, let’s think… you’re talking to me, and I’m awake, so you’re awake too! But we really should leave this place. Can you get up?",0.1),"completed")
	
	enum_choice = yield(out.say_enum(["Yes, I should be able to. [You swing your feet off the bed, leaving them to dangle over the edge.]", 
									"Yes [You put your feet off the bed, feeling the cold floor underneath] "],
									[],[]),"completed")
	match enum_choice :
		0:
			out.set_event("Short" , out.get_event( "Short") + 1)
			t1 -= 1
		1:
			out.set_event( "Tall" , out.get_event( "Tall") + 1)
			t1 -= 1
	if out.get_event( "Tall") > 0:
		yield(say_t(1, "Careful dad! You know how tall you are – and how cramped it’s [url=B]here[/url].",0.1), "completed")
		enum_choice = yield(out.say_enum(["I think… I have forgotten everything.[As you finish, the uncertainty hits you again. Not knowing who you are, a difficult]",
		"Yeah, how could I have forgotten, right? [The irony does not escape you]"],
			["Here… where even are we? [Asking questions – you did this a lot, you feel, back before… whatever happened, happened]"],
			["B"] ), "completed")
		match enum_choice :
			0:
				out.set_event("P02",out.get_event( "P02")-1)
				t1 = 1 
			1:  
				out.set_event("P01",out.get_event( "P01")+1)
				t2 = 1
			2 :
				out.set_event("P03", out.get_event( "P03")+1)
				tB = 1
	if t1 < 0:
		yield(say_t(1,"But, you remember me, right? Don’t worry, we’ll figure this out!",0.1), "completed")
	yield(say_t(1,"And that was it for the tech demo !",0.1), "completed")
#		enum_choice = yield(out.say_enum(["I guess you’re right. First we should get out.", "Hope is not a sustainable strategy."],["","Lashing out like this, you feel a pang of guilt."]),"completed")
		#match enum_choice :
#			(
#1 I guess you’re right. First we should get out. $t1b $t1-=1 ;
#	2 Hope is not a sustainable strategy. [Lashing out like this, you feel a pang of guilt.] We need to get out of here. $P01+=1 $t2b $t1-=1 ;
#			)
#{if t1b > 0:
#			yield(say_t(1 Right, so, try to stand up. I’m right here if you need help. $t1b-=1
#	}
#	{if t2b > 0:
#			yield(say_t(1 Hope might not be sustainable, but we don’t have much else now, do we? Try to stand up – I’m right here if you fall. $t2b-=1
#	}
#}
#{if t2 > 0:
#		yield(say_t(1 Oh, how could you forget? [she playfully responds] No but really, I bet it’s just temporary.
#			(
#1 I sure hope it’s temporary. Not knowing you own name sucks – but it is out there, I’m sure of it. $t1b+=1 $t2-=1;
#	2 I wonder if I even want to remember? [some doors are closed for a reason, you think] Anyway, we do need to get out. $P01-=1 $t2b+=1 $t2-=1 ;
#			)
#{if t1b > 0:
#			yield(say_t(1 Don’t worry dad, things will get better. Can you try and stand up? I’m here to help you, don’t worry. $t1b-=1
#	}
#	{if t2b > 0:
#			yield(say_t(1 I’m… [she hesitates] I’m not sure you – we – really have a choice, dad… but, do you think you can stand? I’m right here if you need help. $t2b-=1
#	}
#}
#{if tB > 0:
#		yield(say_t(1 The space station, LWS-2. But I don’t know much more, you know tha… sorry - I didn’t mean to…
#			(
#1 It’s fine, it’s an adjustment for me too. [It feels awkward saying that, as if your throat isn’t used to speaking these words] We should… go. $P01-=1 $t1b+=1 $tB-=1 ;
#	2 Well you sure know how to perk me up. Come on, let’s get out of here. $P01+=1 $t2b+=1 $tB-=1 ;
#			)
#{if t1b > 0:
#			yield(say_t(1 Still, I’m sorry. This is all so new… Can you try and stand up? $t1b-=1
#	}
#	{if t2b > 0:
#			yield(say_t(1 Of course, what wouldn’t I do for dear old dad? Anyway, do you think you can stand up? I’m right here to,” [she chuckles,] “catch you if you fall. $t2b-=1
#	}
#}
#}
#	(
#1 Here goes nothing… ;
#	2 I was knocked out, right? Legs don’t hurt, should be fine. P03+=1 ;
#	3 Yeah, gotta get rolling. P02+=1 ;
#	)
#yield(say_t(9 You try to get up, but stumble, your legs weak, and you just barely manage to hold yourself up by the… [url=C]bookshelf?
#Steadying yourself, you feel the feeling and strength return to your lower extremities, slowly letting go of the bookshelf until you can stand on your own.
#But then you stumble as you take the first couple real steps, stepping on all sorts of stuff lying around, just barely avoiding another fall.
#(
#1 Was I really that messy? Doesn’t sound right. $t1+=1 ;
#	2 What happened here? This was not me, that’s for sure. $t2+=1 $P02+=1 ;
#	3 Huh. Didn’t imagine myself to have been so disorderly. $t1+=1 ;
#	C Didn’t you say you would catch me? $tC+=1 ;
#	)
#{if tC > 0:
#	yield(say_t(1 Sorry, I was too far. Not used to this, you know?
#	(
#1 Well, I’m fine. But was I really this messy? These… books are everywhere. [How did you know they were books?] $t1+=1 $tC-=1 ;
#	2 I didn’t fall, that’s what counts. Do you know who trashed this place? $t2+=1 $P02+=1 $tC-=1 ;
#		)
#}
#{if t2 > 0:
#	yield(say_t(1 I don’t know, it was like this [url=F]when I got here[/url].
#		(
#			1 Then someone trashed my room. Assuming they’re not here – where is the door? $t1b+=1 $P02+=1 $t2-=1 ; 
#			2 I guess the books just grew legs and fell down on their own, right? $t2b+=1 $P01+=1 $t2-=1 ;
#			F When did you get here? $tF+=1 $t2-=1 ;
#		)
#	{if tF > 0:
#		yield(say_t(1 Not that long ago. Let’s go, the door’s to your right, no, wait, left. Yeah, left. Sorry – my side, your side…
#		(
#			1 Oh-kay… are you [b]sure[/b] it’s on the left? Alright… $tF-=1 ;
#			2 Is this going to be a rendition of “blind leading the blind”, or what? Let’s get on with the performance! $tF-=1 ;
#		)
#}
#{if t1b > 0:
#		yield(say_t(1 Just like you – looking for a cause. We need to get to the conference room, just outside the bedroom. [Conference room, just outside a bedroom?]
#			(
#				1 Talk about taking your work home. $P01+=1 t1b-=1 ;
#				2 Who would have an office right next to their bedroom? $P03+=1 t1b-=1 ;
#				3 Everything important at one place. Nice, Efficient. $P02+=1 t1b-=1 ;
#			)	
#		yield(say_t(1 Efficient. Yeah, that’s what you called it. The door’s to the right – wait, that’s my right. Right. So, to your left. Want me to [url=E]lead[/url]?
#			(
#				E Are you sure [b]you[/b] aren’t the blind amnesiac here? P01+=1 ;
#			)
#		yield(say_t(1 [You hear air whooshing, she’s probably waving her hand before you] Yep, plenty sure! Let’s go…
#	}
#	{if t2b > 0:
#		yield(say_t(1 It wasn’t me, [she defends herself], been like this when I got here. And we should get out of here.
#			(
#				1 …sure. [you respond tentatively] So where's the door? $t2b-=1 ;
#				2 Wasn’t accusing you. [Weren’t you?] The door… is to the right? [You guess] ;
#			)
#		{if t2b = 0:
#			yield(say_t(1 It’s to the left, I’ll lead.
#		}
#{if t2b > 0:
#			yield(say_t(1 [She laughs] No, to the left. Let me lead. t2b-=1			
#		}
#}
#}
#{if t1 > 0:
#	yield(say_t(1 That’s because it isn’t. You’d freak out over a speck of [url=D]dust[/url].
#		(
#			1 Then someone trashed my room. Assuming they’re not here – where is the door? $t1b+=1 $P02+=1 $t1-=1 ; 
#			2 I guess the books just grew legs and fell down on their own, right? $t2b+=1 $P01+=1 $t1-=1 ;
#			D Funny, I don’t feel like a germophobe… $tD+=1 $t1-=1 ;
#		)
#	{if tD > 0:
#		yield(say_t(1 I think you just wanted things to be nice and neat.
#		(
#			1 Ah, an exaggeration. Nevermind that, who did this then? They would be out there, right? $t1b+=1 $P02+=1 $tD-=1 ;
#			2 I guess the books didn’t like my order, since they apparently fell off the shelves on their own. $t2+=1 $P01+=1 $tD-=1 ;
#		)
#}
#{if t1b > 0:
#		yield(say_t(1 Just like you – looking for a cause. We need to get to the conference room, just outside the bedroom. [Conference room, just outside a bedroom?]
#			(
#				1 Talk about taking your work home. $P01+=1 t1b-=1 ;
#				2 Who would have an office right next to their bedroom? $P03+=1 t1b-=1 ;
#				3 Everything important at one place. Nice, Efficient. $P02+=1 t1b-=1 ;
#			)	
#		yield(say_t(1 Efficient. Yeah, that’s what you called it. The door’s to the right – wait, that’s my right. Right. So, to your left. Want me to [url=E]lead[/url]?
#			(
#				E Are you sure [b]you[/b] aren’t the blind amnesiac here? P01+=1 ;
#			)
#		yield(say_t(1 [You hear air whooshing, she’s probably waving her hand before you] Yep, plenty sure! Let’s go …
#	}
#	{if t2b > 0:
#		yield(say_t(1 It wasn’t me, [she defends herself], been like this when I got here. And we should get out of here.
#			(
#				1 …sure. [you respond tentatively] So where's the door? $t2b-=1 ;
#				2 Wasn’t accusing you. [Weren’t you?] The door… is to the right? [You guess] ;
#			)
#		{if t2b = 0:
#			yield(say_t(1 It’s to the left, I’ll lead.
#		}
#{if t2b > 0:
#			yield(say_t(1 [She laughs] No, to the left. Let me lead. t2b-=1			
#		}
#}
#}
#Initialize location
#Then navigate location to Conference room, as Daughter pops into Storyteller column if the player is lost.
#$LOC.INIT+=1 $LOC.001+=1
