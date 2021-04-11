---
title: Speechly Annotation Language (SAL)
description: Applications are configured by creating example utterances that are annotated with the Speechly Annotation Language (SAL). The configuration defines how the users can interact with the voice user interface.
weight: 10
category: "User guide"
aliases: [/editing-nlu-examples/slu-examples/]
draft: True
menu:
  sidebar:
    title: "Speechly Annotation Language (SAL)"
    parent: "Configuring Your Application"
---

This page is about the basics of Speechly Annotation Language (SAL). SAL is the annotation language that is used to configure the model. 

On this page, you'll learn about configuring your application through example utterances, basic concepts intents and entities and the Speechly Dashboard basic functionalities

{{< info title="Example configurations" >}} If you want to get up and running fast, you can copypaste our [example configurations](/slu-examples/example-configuration/) and try them out.{{< /info >}}


## Example utterances

The Speechly SLU applications are built by specifying a set of example utterances, for which we use our Speechly Annotation Language (SAL). The example utterances should, as accurately as possible, reflect what your users might say to your application. Your examples are then fed as training data to a fairly complex machine learning system, which takes care of building all the bits and pieces required for a computer to understand human speech.

Luckily, to build an SLU app with Speechly, you don't have to understand what's going on under the hood. It is useful, however, to know a bit what the example utterances are used for. You can think of them as a way to explain to the computer what a particular sentence means and which words or phrases in the utterance are important.

{{< info title="Feeling lost?" >}} This part of the documentation expands on what we've previously written about models, intents, and entities. The best way to start learning Speechly is by completing the [Quick Start](/quick-start/). You might want to learn about the [SLU basics](/slu-examples/) too.{{< /info >}}

We'll use a simple home automation application as a running example when walking through the different SAL features. Let's start with something simple, and then progressively move on to more complicated stuff.

Before continuing, you should get acquainted with the basic concepts of SLU applications: *utterances, intents*, and *entities*. You can familiarize yourself with them [here](/slu-examples/). If you haven't done that yet, please do so now. It will make following this tutorial a lot easier! If you already know the SLU basics, let's move on!

## Intents

The Speechly Annotation Language defines a set of example utterances that can be used when talking to your SLU application. These examples essentially capture the language your users use and what your application should understand. For example, suppose we wanted to describe how to bid someone turn on the lights, the simplest SAL example toward this goal would look like this:

```
*turn_lights_on turn on the lights
```

The first element in the example above, `*turn_lights_on`, signifies that the text that follows has the intent of turning the lights on (*turn_lights_on*). The intent names in the SAL appear as special tokens indicated by the asterisk (`*`) as the word-initial character.

Since natural language is incredibly diverse, it affords a variety of expressions to be used for a single intent. Just think of how many ways of asking someone to turn the lights on you can come up with! By giving your model a few variations of the same intent in the SAL will help with the accuracy of the system. So, let's add a couple of example utterances for an intent:

```
*turn_lights_on turn on the lights
*turn_lights_on put the lights on please
*turn_lights_on switch the lights on
```

Note that all of these examples are prefixed with the intent name they correspond to.

You may want to include more than one intent to your model to enable more functions for your users. In our running home automation example, a reasonable additional intent could be that of turning the lights off. So, let’s add some example utterances for that purpose next:

```
*turn_lights_on turn on the lights
*turn_lights_on put the lights on please
*turn_lights_on switch the lights on
*turn_lights_off turn off the lights
*turn_lights_off put the lights off please
*turn_lights_off switch the lights off
```

Here we made the `*turn_lights_off` utterances simply by copypasting the example utterances for the `*turn_lights_on` intent, and then replaced the word "on" with the word "off". Please note that there is no need for the examples of different intents to look almost identical, as they do here. In fact, it's better if the utterances of different intents were unsimilar, but sometimes that's just not feasible.

So far, we haven't identified any entities in our examples. Consider now building an application where the users could control multiple devices at home, such as the air conditioner or the music player, in addition to just lights. Now, you may see that the use of entities in the configuration could be useful.

Basically, we could do everything with intents; we could define the same on and off intents for the AC as we did for the lights:

```
*turn_ac_on turn on the ac
*turn_ac_on put the ac on please
*turn_ac_on switch the ac on
*turn_ac_off turn off the ac
*turn_ac_off put the ac off please
*turn_ac_off switch the ac off
```

And for the music player, you could add two intents more: `*turn_music_on` and `*turn_music_off`. You'd then end up with three or more near-identical sets of intents for controlling your different electric devices at home.

As you probably can see, it could get very tedious - especially, if we had several of these devices, in different rooms. We could have a music player in the bedroom as well as in the living room, and for sure we'd have lights in all rooms. You'd soon have intent names like `*turn_on_bedroom_lights` and `*turn_off_living_room_music`. Dealing with all this as separate intents is very complicated to write and maintain.

## Entities

When we look at the home automation example, we can identify two kinds of things in the utterances: actions, and objects (i.e., the things that receive the action). In this case, the action turns something on or off, and the objects that receive the action are the various devices, possibly located in different rooms.

This structure applies to many other SLU applications as well. The intents are useful for capturing the action the user eventually wants to achieve. Entities, on the other hand, are modifiers for intents. They help specify what the target or some attribute of the action is.

Now, let's rewrite our SAL examples. We'll use two intents: `*turn_on` and `*turn_off`. This time, however, we list the devices and their locations as entities. Let's start again with a single example:

```
*turn_on turn on the [bedroom](room) [lights](device)
```

Again, the utterance starts with the intent name, which is identified by the `*`. This time the example also contains some new syntax. In `[bedroom](room)`, the latter part in parenthesis signifies the entity name, and "bedroom" in square brackets its value. Likewise, `[lights](device)` means that we have defined an entity called "device" of which value is "lights". So, in the SAL syntax, the entity value is enclosed in square brackets, followed by the entity name in parentheses.

There can be several different values that a given entity can take. Let's add a couple of examples:

```
*turn_on turn on the [bedroom](room) [lights](device)
*turn_on please turn on the [living room](room) [ac](device)
*turn_on switch the [kitchen](room) [music player](device) on
```

Now we have three different room entities (bedroom, living room, kitchen) and three device entities (lights, ac, music player). Also, we included some variation in the example utterances, just like before. Let's then add examples for the turning off intent:

```
*turn_off turn off the [bedroom](room) [lights](device)
*turn_off please turn off the [living room](room) [ac](device)
*turn_off switch the [kitchen](room) [music player](device) off
```

This minimal set of SAL examples is already a start for building a simple SLU application.

To make the system more robust, you'll need to add more examples. The set of example phrases above does not yet train the model to control the living room or the kitchen lights. And it might not even be necessary. If you're in luck, the machine learning system figures out even from a very small set of examples that sometimes you might want to talk about the bedroom air conditioner or the music player in the living room. But, to ensure that this will happen rather than leave it to luck, it's always best to give as many examples as you can.

You can imagine, though, that writing these examples might get a bit tedious. Especially, if there are a lot of different possible entity combinations. Luckily, you don't have to do all that, as we will see next!

## Annotating in the Speechly Dashboard

{{< figure src="rule-editor.png" title="The SLU Examples configuration view." alt="Screenshot from the Speechly Dashboard SLU Examples configuration view">}}

Annotation is a major part of your application, and you should spend some time building and developing your examples. When you add a new intent or entity, make sure to add it to the correct list on the right-hand-side in the SLU example editor. This helps you spot typos in your configuration.

The Speechly Annotation Language is pretty expressive, and we only cover the bare minimum here. You can read about the more advanced features in [Standard Variables in Data Types](/slu-examples/standard-variables/) and [Imports and lookup entity type](/slu-examples/imports-and-lookups/).

