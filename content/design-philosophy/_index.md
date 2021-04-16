---
title: Speechly Design Philosophy
description: "How Speechly should be used to improve your application's user experience?"
display: article
weight: 5
menu:
  sidebar:
    title: "Design Philosophy"
---

Speechly is solving voice in a completely novel way. Our API is fully streaming to enable a few key concepts that we think are the missing piece in voice. We have put together a number of best practices that are worth considering when developing your application.

They are split into four short "chapters", with the following content:

# [Chapter 1: Setting the right Context](/design-philosophy/set-right-context/)
- Resist the temptation to build an assistant
- Design the interactions around commanding not conversing
- Give visual guidance on what the user can say
- Use voice for the tasks it is good for

# [Chapter 2: Receiving Commands from the User](/design-philosophy/receive-commands/)
- Onboard the user
- Avoid using a wake word
- Prefer a push-to-talk button mechanism
- Signal clearly when the microphone button is pushed down

# [Chapter 3: Giving Feedback to the User](/design-philosophy/give-feedback/)
- Use non-interruptive modalities for feedback
- Minimize latency with streaming natural language understanding
- Steer user’s gaze and visual attention
- Minimize visual unrest in triggered events

# [Chapter 4: Recovering from Mistakes](/design-philosophy/mitigate-fails/)
- Show the text transcript
- Fail fast
- Enable corrections both verbally and by using touch
- Offer an alternative way to complete the task
