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

In order to build a voice based user interface, your application needs to understand what is being said. This is done by providing example utterances, which are annotated using our unique Speechly Annotation Language (SAL).

During deployment, we adapt the speech recognition model to the vocabulary present in your cofiguration, as well as train models for detecting **intents** and **entities** from users speech. The intents and entities are returned to your application by our API.

# Getting started
- [Configuration basics](basics) gives a brief introduction to basic configuration concepts.
- [Example configurations](/slu-examples/example-configuration/) are useful learning material.
- [Speechly Annotation Language Syntax](/slu-examples/cheat-sheet/) explains the details of SAL syntax.
- [Speechly Annotation Language Semantics](/slu-examples/semantics) explains the details of SAL semantics.
- [Standard Variables](/slu-examples/standard-variables) are useful when your configuration must support numbers, dates, times, etc.
- [Entity Data Types](/slu-examples/postprocessing) are useful when combined with the Standard Variables to obtain entity values in a normalized format.

# Why must I configure my application?
In general it is necessary to design the utterances for each application separately. With Speechly, the configuration serves *two* equally important purposes:

1. Teaching our speech recognition system the **vocabulary** that is relevant in your application. An application may require the use of uncommon words (e.g. obscure brand names or specialist jargon) that must explicitly be taught to our speech recognition model.

2. Defining the information (**intents** and **entities**) that should be extracted from users' utterances. It is difficult to provide ready-made configurations that would sufficiently suit a variety of use-cases. The set of intents and entities are tightly coupled with the workings of each specific application.
