---
title: Receiving Commands from the User
description: "Facilitate efficient communication."
display: article
weight: 2
menu:
  sidebar:
    title: "Receiving Commands"
    parent: "Speechly Design Philosophy"
---
# Onboard the user

When your users first see your voice UI, they will need some guidance on how to use it.

These examples should be placed close to where the visual feedback will appear. You can hide the examples after the user has tried the voice user interface.

# Avoid using a wake word

While voice assistants use a wake word so that they can be activated from a distance, your touch screen application doesn’t need to. Repeating the wake word every time makes the experience jarring, adds latency and decreases the reliability.

The hands free scenario is far less relevant than you might initially think, as the user is already holding the device. There are also privacy risks involved with a wake word.

# Prefer a push-to-talk button mechanism

Push-to-talk is the best way to operate a microphone in a multimodal touch screen application. When the user is required to press a button while talking, it’s completely clear when the application is listening. This also decreases latency by making endpointing very explicit, eliminating the possibility of endpoint false positives (system stops listening prematurely) and false negatives (systems does not finalize request after user has finished the command).

On the desktop you can use the spacebar for activating the microphone.

You can also add a slide as an optional gesture to lock the microphone for a longer period of time. WhatsApp has a good implementation of the design in their app.

# Signal clearly when the microphone button is pushed down.

To make it sure the user knows that the application is listening, signal clearly when the microphone button is pushed down. This is especially important if using the push-to-talk pattern.

You can use sound, animation, tactile feedback (vibration) or a combination to signal the activation. On a handheld touch screen device, make sure that the activated microphone icon is visible from behind the thumb when push-to-talk is activated.