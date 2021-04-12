---
title: How to design for Speechly?
description: "How Speechly should be used to improve your application's user experience?"
display: article
menu:
  sidebar:
    title: "Design"
    weight: 5
---

Speechly is solving voice in a completely novel way. Our API is fully streaming to enable a few key concepts that we think are the missing piece in voice. When developing your application, follow these best practices for best user experience.

# Real-time visual feedback

Voice assistants and most other voice solutions work in a turn-based fashion: The user says something and then the system processes the input for a while and returns with the result.

This works well for simple tasks, but for anything more complex, this approach is bound to fail. If the user says a 10-15 second utterance that has a small error somewhere in between, the whole utterance fails. 

Speechly starts returning results right after the user starts talking to enable real-time visual feedback. This way, the user sees results happening on their screen based on their voice input as they speak. The user can even use voice to correct themselves.

{{< youtube xI68NT8D1m8 >}}
*Example of real time visual feedback in voice eCommerce*

# Show transcript in field of vision

Show the transcript of user utterance in a central place in the field of vision of the user. This is important so that the end-user can be sure that their input is being received correctly. In case of error, the transcript is the only way for the user to know why the error happened.

This is why the transcript needs to be **always visible** when voice commands are being uttered.

{{< figure src="transcript.png" title="Always show transcript in the users' field of vision" alt="Voice UI app with transcript visible in the users' field of vision" >}}


# Use push-to-talk for activating voice

Instead of wakewords, we prefer users to explicitly activate the voice functions by pressing and holding the microphone button.

This approach is more privacy-sensitive and offers lower latency. While this means that the application can't be used hands-free, this is often the best solution. 

And of course, you can use third party wake word systems with Speechly, too. Most often you shouldn't. 

# Use voice for commands

End users are not using the voice functionalities because they want to talk with someone but because it's the most natural and fastest way to interact with the computer. 

Configure your Speechly model for various ways how users can use your application, but don't make them conversate. Voice is used to make your application faster and more efficient to use, not for dialogue.

# Support multi-modality

Your application should not be voice-only. Voice should be used to complement your current user interface, not to replace it altogether. 

For instance, while filling a form on a desktop is pretty easy and intuitive by using a keyboard, what if your user is on the go and using mobile phone? Maybe voice is the better solution. This is why your form should support both options.

{{< youtube XWqHV1a32LM >}}
*Speechly can turn any form into a voice form*


