---
title: Give Feedback to the User
description: "With Speechly you can give real-time feedback to the user while they talk."
display: article
weight: 3
menu:
  sidebar:
    title: "Giving Feedback"
    parent: "Speechly Design Philosophy"
---
# Use non-interruptive modalities for feedback

Non-interruptive modalities include haptic, non-linguistic auditory, and perhaps most importantly visual feedback. Using these modalities, the application can react fast and without interruption to the user. For instance, in the case of “I’m interested in t-shirts,” the UI would swiftly show the most popular t-shirt products, instantly enabling the user to continue with a refining utterance, ”do you have Boss.” This narrows further down the displayed products to show only the Boss branded t-shirts.

On the other hand, voice synthesis is a bad idea for feedback, as any ongoing user utterance will be abruptly interrupted. Voice is also a pretty slow channel for transmitting information and for returning users, hearing the same speech synthesises every time gets annoying very fast.

# Minimize latency with streaming natural language understanding

One important part of user experience is the perceived responsiveness of the application. Designers are using tricks such as lazy loading, doing tasks on background, visual illusions and preloading of content to make their applications seem faster and this should be done with voice, too.

In voice applications, immediate UI reaction is even more important. Immediate UI reaction encourages the user to use longer expression and to continue the voice experience. In case of an error, it enables the user to recover fast.

# Steer user’s gaze and visual attention

When using voice effectively the user can control the UI an order of magnitude faster compared to tapping and clicking. This means that a lot of stuff might be happening in the UI. It is important that the user can keep up with these UI reactions.

Typically UI reactions manifest themselves in some sort of visual queues, micro animations and transitions. There is an instinctive inclination in the human visual cognition system to move visual focus to where movement is happening.

Therefore it is an antipattern to scatter visual ui reactions all over the visual field of the user, e.g. streaming transcription animation on top of the screen and other ui reactions at the bottom of the screen. This will result in the user's gaze bouncing back and forth on the screen making it very hard to understand what is happening in the user interface and inflicting unnecessary cognitive load and annoyance to the user.

For this reason it is important to either centralize all visual UI reactions near one focal point,meaning that both the transcript as well as the visual transitions resulting from the user commands are shown very close to each other. The other option is to steer the users gaze linearly on the screen with a cascade of animations happening e.g. top down, left to right.

# Minimize visual unrest in triggered events.

While a voice user interface needs to be as close to real-time as possible, minimize flicker and visual unrest. You can use placeholder images and elements to make sure the application looks smooth and reacts fast.
