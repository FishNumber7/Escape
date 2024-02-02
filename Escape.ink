VAR box_cutter = false
VAR hammer = false
VAR little_key = false
VAR number_one = 0
VAR number_two = 0
VAR number_three = 0
VAR number_four = 0
VAR wrench = false
VAR lockpick = false
VAR broken_chain = false
VAR unlocked_door = false
VAR intercom = false
VAR found_safe = false

VAR turn_count = 0
-> beginning

=== beginning ===
You wake up in an unfamiliar location. Dust hangs in the air. Light streaks through cracks in the wall, but it's dark... too dark to make out anything.

+ [Examine your surroundings] You get up to examine your surroundings.

As you stand up, you hear jangling and feel cold metal against your ankle.

+ + [Examine your ankle] You bend down to investigate the sound. There's a metal clasp and chain attached to your ankle. You are unsure as to where the chain leads. 

- Your vision starts adjusting to the darkness, and you can make out basic shapes. It appears that you awoke on a thin mattress on the floor. You can make out a door, a table, a shelf, and some frames on the wall.
-> darkness

//im not sure how to implement the time loop thing so im doing it like this... :P
=== darkness===
+ [Examine the table] You walk over to the table. You can't make out anything in this darkness.
-> darkness

+ [Examine the shelf] You look in the shelf. You can see the faint silhoutte of books, but it's too dark for reading.
-> darkness

+ [Examine the frames] You're sure these are beautiful works of art, but it's too dark to see.
-> darkness

+ [Open the door] You walk over to the door. The wood is frayed like twine. The paint has all but chipped off.

You grab the handly tightly and turn, but it won't budge. It appears you're locked in.

However, you notice what appears to be a light switch to the left of the door.

+ + [Flick the switch] You flick the switch.
-> light


=== light ===
A dirty overhead lightbulb lights up. You can see the room more clearly now. The mattress is covered in dirt. Cheap art is hang on the wall, the kind you would find in a thrift store. One is a painting sailboat, the other is a picture of the Eiffel Tower, and another a film poster.

You notice the chain is attached to the wall firmly with a bolt. You're not escaping anytime soon.

Bizarrely, you see a blinking light and a speaker in the corner of the room. It reminds you of an intercom.

- (exploration)

{turn_count >= 3 && not intercom: The intercom hums to life. A deep voice booms out of the speaker: "Escape this room soon, or you may perish..." You don't like the sound of that!}

 {intercom && turn_count >= 17: -> failure}


{turn_count >= 3:
    ~ intercom = true
}

+ [Examine the table] You decide to examine the table.
-> table

+ [Examine the shelf] You decide to examine the shelf.
-> shelf

+ [Examine the sailboat painting] You decide to examine the sailboat painting.
-> sailboat

+ [Examine the Eiffel Tower photograph] You decide to examine the Eiffel Tower photograph.
-> eiffel_tower

+ [Examine the film poster] You decide to examine the film poster.
-> film_poster

+ {not broken_chain} [Examine the chain] Maybe there's some way to break the chain...
-> chain

+ {not unlocked_door} [Attempt to open the door] There's gotta be some way to get this door open...
-> door

+ {broken_chain && unlocked_door} [Escape] You run out of the room.
-> victory

=== door ===

+ {lockpick} [Attempt to lockpick the door] You decide to try to lockpick the door.
{ wrench:
Using the tension wrench to apply force on the lock, you eventually succeed in opening the door. It opens to the outside
    { broken_chain: 
    With nothing stopping you, you run outside.
    -> victory
    - else: 
    Still, you've got to do something about that chain.
    ~ turn_count++
    ~ unlocked_door = true
    -> light.exploration
    }
- else:
You try to lockpick the door, but without any tension you can't get it open.
    ~ turn_count++
    -> door
}

+ [Try to break the door open] You slam into the door, but it does not budge.
~turn_count++
-> door

+ [Look elsewhere] You step away from the door.
-> light.exploration


=== chain ===
The chain is attached to the wall.

+ {not hammer} [Yank on the chain] You yank the chain. It does not budge.
~turn_count++
-> chain

+ {hammer} [Try breaking the chain with the hammer] You hit the hammer against the chain. After a while it breaks.
~broken_chain = true
~turn_count++
-> light.exploration

+ [Look elsewhere] You decide the chain can wait.
-> light.exploration

=== film_poster ===
You stand in front of the film poster.

+ {not found_safe} [Examine the poster] You look for clues on the film poster. No luck. However, you notice a hole behind the poster, and take it off the wall. Behind the poster is safe.
~ found_safe = true
-> film_poster

+ {found_safe && not lockpick} [Input safe combination] You decide to input the combination.
-> combination(1) -> combination(2) -> combination(3) ->
You input {number_one}{number_two}{number_three}.
{ number_one == 1 && number_two == 8 && number_three == 7:
The safe opens. Inside is a lockpick. You put it in your pocket.
~ lockpick = true
- else:
The safe remains closed. You must've put in the wrong combination.
}
~turn_count++
-> film_poster

+[Look elsewhere] You step away from the poster.
-> light.exploration

=== eiffel_tower ===
You stand in front of the photograph

+ [Examine the photograph] You look at the photograph for clues. Picking the frame off the wall, you turn it around. On the back, it says: "1992 trip."
~turn_count++
-> eiffel_tower

+ [Look elsewhere] You step away from the photograph.
-> light.exploration

=== sailboat ===
You stand in front of the painting. 

+ [Examine the painting] You feel around the painting, searching for clues. No luck.
~ turn_count++
-> sailboat

+ {box_cutter and not little_key} [Cut into the canvas] You cut into the canvas. Inside is a little key. You put it into your pocket.
~ little_key = true
-> sailboat

+ [Look elsewhere] You step away from the painting.
-> light.exploration

=== table ===
On top of the table is a box with a small lock{not box_cutter: and a boxcutter}.

+ {not box_cutter} [Grab the box cutter] You grab the box cutter and stick it in your pocket.

~ turn_count++
~ box_cutter = true 

-> table

+ {not hammer} [Attempt to open the box]

{- little_key:
    You insert the key into the lock and turn. It opens easily. The box contains a hammer. Maybe it will be useful. You put the hammer in your pocket.
    ~ hammer = true
- else: You try with all your might to open the box, but to not avail. The lock won't budge.
}
~ turn_count++
-> table

+ [Look elsewhere] You step away from the table.
-> light.exploration

=== shelf ===
On the shelf there are three dust covered books and a small box with a 4 number combination lock.

- (shelf_explore)

+ [Examine the first book] You pick up the first book. Dusting off the cover, you read "The Little Prince." Skimming through the book, you find nothing of note.
~ turn_count++
-> shelf_explore

+ [Examine the second book] You pick up the second book. Dusting off the cover, you read "The Hobbit." Skimming through the book, you notice a dog ear on page 187.
~ turn_count++
-> shelf_explore

+ [Examine the third book] You pick up the third book. The covered is unreadable, and the pages are torn. You're sure there's nothing of value in this book.
~ turn_count++
-> shelf_explore

+ {not wrench} [Attempt to open the box] You attempt to open the box. Input your combination:
-> combination(1) -> combination(2) -> combination(3) -> combination(4) ->
You input {number_one}{number_two}{number_three}{number_four}.
You put in a combination. You pull on the lock { number_one == 1 && number_two == 9 && number_three == 9 && number_four == 2: -> wrench_found} -> incorrect_combination

- - (wrench_found) and the lock opens. Inside the box, you find a tension wrench. You put it in your pocket 
~wrench = true 
~turn_count++
->shelf_explore

- - (incorrect_combination) and nothing happens.
~turn_count++
->shelf_explore

+ [Look elsewhere] You step away from the shelf.
-> light.exploration


=== combination(number) ===
+ 0

{combination_helper(number, 0)}

+ 1

{combination_helper(number, 1)}

+ 2

{combination_helper(number, 2)}

+ 3

{combination_helper(number, 3)}

+ 4

{combination_helper(number, 4)}

+ 5

{combination_helper(number, 5)}

+ 6

{combination_helper(number, 6)}

+ 7

{combination_helper(number, 7)}

+ 8

{combination_helper(number, 8)}

+ 9

{combination_helper(number, 9)}

- ->->

=== function combination_helper(number, input) ===
{ number:
-1: ~ number_one = input
-2: ~ number_two = input
-3: ~ number_three = input
-4: ~ number_four = input
}


=== failure ===
Green gas starts flooding through the vents. You fall quickly unconscious. It appears you may. Maybe if you had one more shot, you could escape the room.

+ [Try Again] You decide to try again.
~ box_cutter = false
~ hammer = false
~ little_key = false
~ number_one = 0
~ number_two = 0
~ number_three = 0
~ number_four = 0
~ wrench = false
~ lockpick = false
~ broken_chain = false
~ unlocked_door = false
~ intercom = false
~ turn_count = 0
~ found_safe = false
-> beginning

+ [Give Up] You decide to give up. Loser!
-> END

=== victory ===
You made it outside with your life... You won!
-> END