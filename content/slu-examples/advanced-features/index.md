---
title: Advanced SAL Features
description: SAL is a pretty expressive language that can be used to create complex voice configurations easily. 
weight: 3
category: "User guide"
aliases: [/editing-nlu-examples/slu-examples/]
menu:
  sidebar:
    title: "Advanced SAL Features"
    weight: 2
    parent: "Configuring Your Application"
---

This document teaches you through more advanced SAL features. You'll learn how to use SAL more expressively by using:

- Inline lists
- Variables
- Optional input
- Number ranges
- Multi-intent utterances
- List weights
- Optional input weight
- Optional inputs nested
- Permutations

If you are new to SAL, you should start by reading about the [SAL basics](/slu-examples/)

### Inline lists

Templates are a feature of the Speechly Annotation Language that allows you to use a much more compact syntax in order to express a broad set of example sentences. Let's consider the following three examples:

```
*turn_on turn on the [bedroom](room) [lights](device)
*turn_on turn on the [bedroom](room) [ac](device)
*turn_on turn on the [bedroom](room) [music player](device)
```

An equivalent way of expressing the above examples in the SAL is:

```
*turn_on turn on the [bedroom](room) [lights|ac|music player](device)
```

Rather than writing out three different example sentences, we can use something called an *inline list* to indicate that in this part of the sentence one of the items from the list `[lights|ac|music player]` should appear. An inline list is defined by a list of words separated from one another by the "pipe" symbol `|`, and enclosed in square brackets.

Note that the use of inline lists is not restricted to entity values. We can also write:

```
*turn_on [turn|switch] on the [bedroom](room) [lights|ac|music player](device)
```

In this example here, we have used the inline list to provide a selection of alternatives also for the first word in the utterance, which could be either “turn” or “switch”, as both make sense in this context.

As you can probably imagine, nothing prevents us from adding yet another inline list that gives us alternatives for different rooms:

```
*turn_on [turn|switch] on the [bedroom|living room|kitchen](room) [lights|ac|music player](device)
```

The single SAL line above expresses a set of 18 different examples, which are formed by taking into account all the possible combinations from the inline lists in the corresponding locations of the sentence. Behind the scenes, our machine learning system considers all the 18 example variations when building your SLU application.

That's pretty neat! But even writing those lists seems like a lot of work. For example, just by re-introducing the `*turn_off` intent, we should have both of the following lines:

```
*turn_on [turn|switch] on the [bedroom|living room|kitchen](room) [lights|ac|music player](device)
*turn_off [turn|switch] off the [bedroom|living room|kitchen](room) [lights|ac|music player](device)
```

We now have copies of the same inline lists linked to these two intents. Should we want these commands to apply to yet more devices and rooms, the additions need to be done to all of the respective inline lists. That's a lot of error-prone work!

### Variables

Again, the SAL has a feature that helps us avoid this. For example, we can use variables that represent lists, and when writing the examples, we can refer to these variables rather than write the lists in full like above. This can be done in the following way:

```
start_phrase = [turn
                switch]
rooms = [bedroom
         living room
         kitchen]
devices = [lights
           ac
           music player]
*turn_on $start_phrase on the $rooms(room) $devices(device)
*turn_off $start_phrase off the $rooms(room) $devices(device)
```

The SAL code above defines exactly the same set of 18 utterances as the previous example with the inline lists, but this one is easier to read as well as maintain when new rooms or devices are added.

To define a list, write the name of a variable you want to use for it, followed by the `=` sign, and the list enclosed in square brackets - each listed item on its own line. In the example utterances, you simply refer to the variable by prepending the variable name with the `$` sign.

{{< warning title="Define variables before using them" >}} The definition of the variable must be given before referenced for the first time. A good practice is to put all the variable definitions at the beginning of your SAL input and add the example utterances only after these.{{< /warning >}}

The SAL allows you to define whatever is needed within a variable (except the *intent*). The variable definition might contain other variables, lists, entities, optional inputs, or plain text:

```
start_phrase = [turn
                switch
                activate]
rooms = [bedroom
         living room
         kitchen]
devices = [lights
           ac
           music player]

turn_on_device = $start_phrase on the $devices(device)
turn_off_device = $start_phrase off the $devices(device)
increase_temperature = [raise|increase] the temperature

*turn_on $turn_on_device in the $rooms(room)
*turn_off $turn_off_device in the $rooms(room)
*increase_temp $increase_temperature in the $rooms(room)
```

### Optional input

As we saw earlier, it's often useful to specify different variations of the examples to make it easier for your app to understand different ways of expressing the same intent. Also, the intents can have "simple" and "complex" variations. For instance, utterances with the turn on intent could be defined as follows:

```
*turn_on $start_phrase on the $rooms(room) $devices(device)
*turn_on $start_phrase on the $devices(device)
```

In the second example, we have omitted `$rooms(room)` to exemplify the case where the user does not specify in which room they want to turn the device on. The location could be obvious from the context, for if the user happens to be in the living room, it makes sense that the simple utterance, "Turn on the lights," would most likely refer to the living room lights. Again, to save us from specifying all such variations separately, the SAL allows you to annotate some parts of the example utterance as optional. This is done by putting the optional part inside curly brackets `{}`:

```
*turn_on $start_phrase on the {$rooms(room)} $devices(device)
```

The line above captures the same set of examples as the two preceding utterances. As with the inline lists, the optional parts can be placed anywhere in the utterance. They can be useful, for instance, when specifying the so-called *carrier phrases*, as shown below:
```
*turn_on {can you} {please} $start_phrase on the $devices(device)
```

Now, this line captures all of the following examples:

```
*turn_on can you please $start_phrase on the $devices(device)
*turn_on can you $start_phrase on the $devices(device)
*turn_on please $start_phrase on the $devices(device)
*turn_on $start_phrase on the $devices(device)
```

Putting all this together, we get the following SAL input, which is already a step closer toward a well functioning home automation application!

```
start_phrase = [turn
                switch]
rooms = [bedroom
         living room
         kitchen]
devices = [lights
           ac
           music player]

*turn_on {can you} {please} $start_phrase on the $rooms(room) $devices(device)
*turn_off {can you} {please} $start_phrase off the $rooms(room) $devices(device)
```

{{< info title="Copypaste and try!" >}} You can copypaste the examples above and give it a try on the Speechly Dashboard.{{< /info >}}


### Number ranges

Often SLU applications need to understand numbers. For instance, you may have a home automation application with intents that allow the user to adjust the room temperature. Given what we explained above, you could do this in the following way:
```
number = [one
          two
          three
          four
          five
          six
          seven
          eight
          nine
          ten]
rooms = [bedroom
         living room
         kitchen]
*increase_temp [raise|increase] the {$rooms(room)} temperature by $number(degrees) {degrees}
*decrease_temp [lower|decrease] the {$rooms(room)} temperature by $number(degrees) {degrees}
```

This works fine, but we can do something smarter. The SAL has a special notation for expressing numeric ranges. An equivalent, but much shorter way to express that above is:

```
number = [1..10]
rooms = [bedroom
         living room
         kitchen]
*increase_temp [raise|increase] the {$rooms(room)} temperature by $number(degrees) {degrees}
*decrease_temp [lower|decrease] the {$rooms(room)} temperature by $number(degrees) {degrees}
```

A number range is given by specifying its first and last value with two dots between, and thereby "1..10" expands to a list of numbers starting from one and ending at ten.

### Multi-intent utterances

Speechly is a fully streaming voice API for building complex voice user interfaces that can be used in natural language. While what we've already learned can be used to build well-working applications, there's one major part we haven't yet touched upon.

What if a user wants to turn on the TV and raise the room temperature, both at the same time? With the examples we have just defined, the user isn't really able to express a combination like this in the most natural way. That is, by saying something like, "Turn on the TV and raise the temperature by two degrees."

A simple solution would be to add `{and}` as an optional part to all of your example utterances to enable such intent compounds.

```
*turn_on {and} {can you} {please} $start_phrase on the {$rooms(room)} $devices(device)
*increase_temp {and} {can you} {please} raise the temperature by $number(degrees) {degrees}
```

Now one could say, "Can you please turn on the TV, and raise the temperature by four degrees" or "Please raise the temperature by two degrees, and turn on the TV," in either order.

Luckily, Speechly supports another alternative too, as multi-intent utterances are also possible. Here's an example:

```
*turn_on {can you} {please} $start_phrase on the {$rooms(room)} $devices(device) and *increase_temp raise the temperature by $number(degrees) {degrees}
```

### List weights

What if some of the phrases in the input were more probable to occur than others? For example, a phrase like "Turn on the music player," is more likely to be used than "Activate the player" or "Switch on the player". It is a good practice to adjust the model so that it "knows" the probability distribution over the occurring items. In the SAL, it is possible to define the weights for the list items:
```
start_phrase = [3: turn
                1: switch
                1: activate]
```
In this case, the proportion of these words in the generated examples will be 3:1:1. If you don't explicitly set the weights, they all default to 1.

You can also use float numbers to make the weights look more like probabilities:
```
start_phrase = [0.6: turn
                0.2: switch
                0.2: activate]
```
This definition is equal to the previous one.

If you define the weights of only some items on the list, others with undefined weights default to 1 as well.
```
start_phrase = [3: turn
                switch
                activate]
```

Inline lists can also contain the weights:
```
*increase_temp $increase_temperature by [0.4: one|0.4: two|0.2: five] degrees

```

### Optional input weight

The weight of an optional part can be used only in the probability manner, always in the interval [0.1]. Let's assume that we have the following template:
```
*turn_on $start_phrase on the $devices(device) {please}
```
It may happen that the input "please" occurs only in 10% of all the cases when the user wants to activate a device. This we could exemplify by:
```
*turn_on $start_phrase on the $devices(device) {0.1: please}
```
Among the examples generated from the template above, 10% will contain the word "please" and 90% will not.

### Optional inputs nested

Another good thing about the optional input is that you can combine several of them, thus making them nested. Let's take the example we created before.
```
number = [1..10]
rooms = [bedroom
         living room
         kitchen]
*increase_temp [raise|increase] the {$rooms(room)} temperature by $number(degrees) {degrees}
*decrease_temp [lower|decrease] the {$rooms(room)} temperature by $number(degrees) {degrees}
```
It may happen so that the user says, "Raise the bedroom temperature" without specifying how high it should be lifted. This option could be expressed by setting `by $number(degrees) degrees` as an optional input:
```
*increase_temp [raise|increase] the {$rooms(room)} temperature {by $number(degrees) degrees}
```
As we already marked `{degrees}` as an optional input, we can just combine it here like this:
```
*increase_temp [raise|increase] the {$rooms(room)} temperature {by $number(degrees) {degrees}}
```

### Permutation

If you want to build utterances from parts that can go in random order, use the following syntax: `![ item1 | item2 ]`.
This is just like the list syntax but prepended with the exclamation mark (`!`).

You can use the permutation feature in your configuration the following way:
```
city = [vienna|berlin|helsinki]
class = [business|economy] class
*book book a flight ![in $class(class) | from $city(from) to $city(to)]
```

The given templates allow you to say both "Book a flight from Vienna to Helsinki in business class," and
"Book a flight in business class from Vienna to Helsinki."

The example above is equivalent to the following:

```
city = [vienna|berlin|helsinki]
class = [business|economy] class
*book book a flight in $class(class) from $city(from) to $city(to)
*book book a flight from $city(from) to $city(to) in $class(class)
```

This feature is useful if your request has multiple parameters that may occur in different orders.
When booking a flight, the users may want to specify, for instance, the number of passengers, the service class, the airport, and 
the number of transfers, but we don't know the order in which these are said. In such situations, the permutation syntax helps
reducing the number of templates in your configuration.
