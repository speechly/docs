---
title: Setting the right context
description: "A voice UI can be much more than an assistant."
display: article
weight: 1
menu:
  sidebar:
    title: "Setting the Context"
    parent: "Speechly Design Philosophy"
---
# Resist the temptation to build an assistant

Voice assistants are digital assistants that react to voice commands, most often by using voice themselves, too. While there are good use cases for voice assistants, their way of using voice is not suitable for touch screen devices.

Instead of question-answer based dialogues, touch screen voice experiences should be based on direct voice input and real-time visual feedback. As the user speaks, the user interface should be instantaneously updated.

# Design the interactions around commanding not conversing

When we humans talk with each other, we do more than transmit information by using words. We might greet, persuade, declare, ask or apologize and even the same words can have a different meaning, depending on how we say it and in which situations. This is very human-like, but not the way we want to communicate with a computer.

With a voice user interface, speech has only one function and it is to command the system to do what the user wants. Be clear that the user is talking with a computer, don’t try to imitate a human. In most cases, the application should not answer in natural language. It should react by updating the user interface, just like when clicking a button.

# Give visual guidance on what the user can say

{{< youtube XWqHV1a32LM >}}
*Example of a graphical user interface supporting the voice user interface*

An issue commonly described in voice user interfaces (VUI) users is the uncertainty related to what commands are supported.

The problem arises from the fact that the typical voice assistant experience begins from a blank slate, where the assistants start listening and is expected to be able to help the user with pretty much anything. This is of course not really true as anybody who has tried these services understands.

Understanding the supported functionality with traditional graphical user interfaces (GUI) is less of a problem. Placing a button in the users shopping cart that reads “proceed to checkout” is a very strong signal to the users that checkout is supported and by pressing the button the user will indeed proceed to the checkout process. This aspect is missing from voice-only solutions which cases uncertainty in terms of supported features.

This is why a good voice user interface should be supported if possible by a graphical user interface.

# Use voice for the tasks it is good for

{{< youtube xI68NT8D1m8 >}}
*Voice is a great input modality when setting search filters*

Good design is about providing the user with the best tools for their use task.

Voice works great for use tasks such as search filtering – “Show me the nearest seafood restaurants with three or more stars”, accessing items from a known inventory – “Add milk, bread, chicken and potatoes”, inputting information: “Book a double room for two in Los Angeles next Friday” and unambiguous commands, such as “Show sports news”.

On the other hand, touch is often the better option for selecting from a couple of options, typing things such as email addresses and passwords and browsing by scrolling a large unknown inventory, for example.

There’s no need to replace your current user interface with a voice user interface. Rather you should evaluate which tasks in your application are the most tedious and easiest to do by using voice and add voice as a modality to those features.
