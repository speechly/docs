---
title: "Recovering from Mistakes"
description: "Mistakes are bound to happen, they should be both easy to spot and fix."
display: article
weight: 4
menu:
  sidebar:
    title: "Recovering from Mistakes"
    parent: "Speechly Design Philosophy"
---
# Show the text transcript

Text transcription of users’ voice input is the most important part of the feedback in case of an error. Lack of action tells the user their input was not correctly understood, but in case of an error in speech recognition, the transcript can enable them to understand why that happened.

Transcript can also be valuable for the user when everything goes right. It tells the user they are being understood and encourages them to continue.

The transcript should appear always in the same, center place in the users’ field of vision. If you are using Speechly, you can use the tentative transcript to minimise feedback latency.

# Fail fast: be forward leaning in producing results but offer opportunity to correct

Natural language processing is hard because of many reasons. In addition to the speech recognition failing, even the user might hesitate or mix up their words. This can lead into errors, just like a misclick will lead in to errors in the graphical user interface.

While there are multiple ways to reduce the amount of errors, the most important thing is to offer the user an opportunity to correct themselves quickly. Produce the best guess for a correct action as quickly as possible, and let the user refine that selection by either voice or touch.

# Have an intent for verbal corrections

The more complex and long the sentences your users use, the more likely they are to fail and hesitate. It’s not a problem if the users get real-time feedback and can correct themselves naturally.

Multimodality enables users to use the graphical user interface to correct themselves, but make sure to include an intent for verbal corrections, too. This makes it possible for users to say something like “Show me green, sorry I mean red t-shirts”.

# Use touch for corrections

Another way to make corrections is touch. Touch corrections are typically best done by offering the user a short list of vibale options based on what they have said or done earlier.

If your user is filling a form by using voice commands, for example, they might only need to correct one field. It can be the most intuitive to tap the correct field and make the correction by using touch. Make sure you support both ways for corrections.

# Offer an alternative way to complete the task

The big issue with voice assistants is that they are hard to use by using touch. While voice is a great user interface for many use cases, sometimes it’s not feasible. This is why all features in your application should be usable with both voice and touch. For example, you can use a traditional search filtering with dropdown menus and include a microphone for using the filters by using voice. This enables users to choose the modality they need.
