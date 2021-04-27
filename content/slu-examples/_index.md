---
title: Configuring Your Application
description: Every Speechly application needs a configuration for your specific use case. 
weight: 3
category: "User guide"
aliases: [/editing-nlu-examples/]
menu:
  sidebar:
    title: "Configuration"
    weight: 4
---
The Speechly API takes an audio stream as input, and returns a *transcript* of the users speech, together with the identified *intents* and *entities* to your application. The Speechly API achieves this by applying machine learning. However, training the machine learning models requires example utterances annotated with the information specific to your application.

When "configuring" a Speechly application, you are essentially providing this training data. During deployment, this data is used both to adapt a speech-to-text model to the vocabulary present in the training examples, as well as to train NLU models for detecting application-specific intents and entities.

# Getting started
- [Configuration basics](basics) gives a brief introduction to basic configuration concepts.
- [Example configurations](/slu-examples/example-configuration/) are useful learning material.
- [Speechly Annotation Language Syntax](/slu-examples/cheat-sheet/) explains the details of SAL syntax.
- [Speechly Annotation Language Semantics](/slu-examples/semantics) explains the details of SAL semantics.
- [Standard Variables](/slu-examples/standard-variables) are useful when your configuration must support numbers, dates, times, etc.
- [Entity Data Types](/slu-examples/postprocessing) are useful when combined with the Standard Variables to obtain entity values in a normalized format.
- [Imports and Lookups](/slu-examples/imports-and-lookups/) allow you to import external data to your configuration, and have the API return normalised entity values by using simple lookup tables.

# Why must I configure my application?
In general it is necessary to design the utterances for each application separately. With Speechly, the configuration serves *two* equally important purposes:

1. Teaching our speech recognition system the **vocabulary** that is relevant in your application. An application may require the use of uncommon words (e.g. obscure brand names or specialist jargon) that must explicitly be taught to our speech recognition model.

2. Defining the information (**intents** and **entities**) that should be extracted from users' utterances. It is difficult to provide ready-made configurations that would sufficiently suit a variety of use-cases. The set of intents and entities are tightly coupled with the workings of each specific application.
