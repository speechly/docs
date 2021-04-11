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

SAL allows you to compactly define a possibly very large set of example utterances by using **templates**. These templates are *randomly expanded* to final example utterances during training. The training system does not exhaustively expand all possible utterances from the templates, but randomly generates examples that are sufficient for training.

# Why must I configure my application?
In general it is necessary to design the utterances for each application separately. With Speechly, the configuration serves *two* equally important purposes:

1. Teaching our speech recognition system the **vocabulary** that is relevant in your application. An application may require special vocabulary (e.g. obscure brand names or specialist jargon) that must explicitly be taught to our speech recognition model.

2. Defining the information (**intents** and **entities**) that should be extracted from users' utterances. It is difficult to provide ready-made configurations that would sufficiently suit a variety of use-cases. The set of intents and entities are tightly coupled with the workings of each specific application.


# Getting started
- [Configuration basics](basics) tells more what a Speechly configuration is and what it does.
- [Speechly Annotation Language Syntax](/slu-examples/cheat-sheet/) explains the details of SAL syntax.
- [Example configurations](/example-configuration/) are useful learning material.

# For advanced users
- Imports
- Multi-intent utterances