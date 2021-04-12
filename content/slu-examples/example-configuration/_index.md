---
title: Example configurations
description: See some examples of SAL configurations. Use them as the scaffold for your application, or learn how to improve your own configuration.
weight: 4
aliases: [/editing-nlu-examples/example-configuration/]
menu:
  sidebar:
    title: "Example Configurations"
    parent: "Configuring Your Application"
---
The [SAL Syntax Reference](/slu-examples/cheat-sheet/) should come in handy as well.

# Home Automation
A simple home automation application for turning devices located in different rooms on and off.

- Intents: `turn_on`, `turn_off`
- Entities: `device`, `location`

## Example utterances
- turn on the lights in the kitchen
- turn off the lights in the bedroom and in the living room
- turn everything off

[Try in Playground &raquo;](https://www.speechly.com/dashboard/#/playground/a0e00927-51e6-4f7f-9259-d3efaf19ddc4?language=en-US&title=Home%20Automation&example=turn%20on%20the%20lights%20in%20the%20kitchen&example=turn%20off%20the%20lights%20in%20the%20bedroom%20and%20in%20the%20living%20room&example=turn%20everything%20off)

## Configuration
```
rooms = [kitchen|bedroom|living room|closet|pantry|hallway|everywhere|all rooms|every room](location)
room = [{in} {the} $rooms]
list_of_rooms = [$room {{and} $room {{and} $room}}]
devices = [lights|television|radio|everything|all devices|every device](device)
device = [{the} {$rooms} $devices]
list_of_devices = [$device {and $device {and $device}}]
command = [turn|set|switch|put]
intent = [
    *turn_on {$command} $list_of_devices on {$list_of_rooms}
    *turn_on $command on $list_of_devices {$list_of_rooms}
    *turn_off {$command} $list_of_devices off {$list_of_rooms}
    *turn_off $command off $list_of_devices {$list_of_rooms}
]
$intent {and $intent}
```

---

# Coffee Ordering
A simple customer service application for placing orders for different types of coffee.

- Intents: `order`
- Entities: `size`, `type`, `addition`, `shot`

## Example utterances
- can I have a double espresso please
- large cappuccino
- make me a large cappuccino and a regular coffee

[Try in Playground &raquo;](https://www.speechly.com/dashboard/#/playground/c994d68e-4504-459b-9029-4078274023a5?language=en-US&title=Coffee%20Order&example=can%20I%20have%20a%20double%20Espresso%20please&example=large%20Capuccino&example=make%20me%20a%20large%20cappuccino%20and%20regular%20coffee)

## Configuration
```
ask = [i'd like to have | make me | order | i want | can I have | may I have] {[a | an]}
size = [small | medium | large](size)
shot = [single | double | triple](shot)
coffee = [coffee|regular coffee|americano|cappuccino|espresso|latte|cafe latte](coffee)
addition = [milk | cream | sugar | syrup](addition)
order = *order {$ask} {$size} {$shot} $coffee {with $addition {and $addition}} {please}
$order {{and} $order}
```

---

# Calculator
A simple voice calculator that supports basic arithmetic operations (`+`, `-`, `x`, `/`, and raising to a power).

- Intents: `calculate`, `append`
- Entities: `number`, `operation`

## Example utterances
- 36 plus 5
- 4 times 20 plus 5
- 77 plus 9 plus 4

[Try in Playground &raquo;](https://www.speechly.com/dashboard/#/playground/1d657c98-ec00-4ac6-88af-1e21648262fd?language=en-US&title=Calculator&example=36%20plus%205&example=4%20times%2020%20plus%205&example=77%20plus%209%20plus%204)

## Configuration
```
number = $SPEECHLY.CARDINAL_NUMBER(number)
operation = [plus|minus|times|divided by|to the power of](operation)
calculate = *calculate $number $operation $number
append = *append $operation $number
$calculate {$append {$append {$append}}}
$append
```
