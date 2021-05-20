---
title: Product updates
description: New features and improvements to Speechly SLU API and client libraries 
weight: 3
type: release-notes
menu:
  sidebar:
    title: "Product updates"
    weight: 999
---

# May 11, 2021

- **Browser client**: v1.0.13, stability improvements.
- **SLU engine**: Make entity and intent detectors more robust against inadvertent non-device-directed speech.
- **Speechly CLI Tool**: Version 0.4.1, show amount of annotated audio for each app_id.

# April 23, 2021

- **Speechly CLI Tool**: Version 0.4, with support for displaying utterance statistics for each app_id.
- **Documentation** Major update to developer documentation.
- **Small bugfixes** Several fixes to handling entities and segments.

# April 9, 2021

- **iOS client** Version 0.3 released, includes update UI components and other improvements.
- **Project-based login** Support for logging in using a project_id. This allows an application to easily switch between app_ids.

# March 19, 2021

- **SLU engine** Update to entity detection model with increased accuracy.
- **Documentation** More examples of gRPC API usage.
- **Browser client** More robust audio recording.
- **ASR improvements** New basline ASR model.
- **Small bugfixes**

# March 5, 2021

- **Training time estimates** Changed the way how we estimate deployment times when training the models.
- **Playground** Pressing 'alt' temporarily enables the Try-button so that one can use the Playground with an old model while a new one is being trained.
- **Model deployment** More robust tranining infrastructure that reduces model training times in certain situations.

# February 22, 2021

- **iOS UI Components** Ready-made [UI components](/client-libraries/ios/ui-components/) for microphone and transcript for hastened development on iOS.
- **Android Client** An Android client for easy integration with Speechly is [now available](https://github.com/speechly/android-client/). The Android client enables quick and efficient development of Speechly applications for native Android applications.
- **Support for new entities** Support for natural time expressions such as "fifteen thirty", "20 past nine" or "5 minutes after midnight" with $SPEECHLY.TIME standard variable and entity type Time.
- **Minor bugfixes** Better support for long utterances, Other fixes

# February 8, 2021

- **Debugging models in Speechly CLI tool** New debugging feature in Speechly CLI tool displays example utterances for a given configuration and calculates statistics about occurences of intents and entities.
- **Support for unadapted ASR** Typically Speechly SLU models are adapted for a specific use case, which helps improve speech recognition accuracy. Now you can also use unadapted ASR for pure transcription use cases. You can test the speech recognition performance [here](https://api.speechly.com/dashboard/#/playground/ead4b9e7-e5c4-48ed-9dae-3c530916ed76?language=en-US)
- **Support for new entities** Speechly Annotation Language supports natively phone numbers, emails, person names and website addresses. This enables developers to easily build voice experiences that contain these data types, for example something like "Add contact with name Jack Johnston and email address jack dot johnston at gmail dot com"
- **Minor bugfixes**

# January 25, 2021

- **Improved audio handling in browser clients** Streaming audio and handling API results is done by using multiple threads for improved performance. Main UI thread is never blocked by Speechly, resulting in a faster UI.
- **Minor bugfixes**

# January 11, 2021

- **ASR Improvements** New baseline model for speech recognition improves ASR accuracy in all use cases.
- **Improvements to ASR adaptation** Utterances that are out of domain (ie. no example utterances provided in the model configuration) now have better speech recognition results.
