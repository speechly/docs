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

{{< figure src="speechly-api-image.png" title="A client sends audio and the SLU configuration defines the form of the results that are received from the API" alt="A figure explaining how Speechly configuration works">}}

Speechly is a tool for building complex voice user interfaces. In order to build a voice based user interface, your application needs to understand what is being said. 

Speechly is configured by providing example utterances, which are annotated using our unique Speechly Annotation Language (SAL). The configuration defines the form of the user utterances and the important parts (intents and entities) that you want to get back.

{{< figure src="utterance-intent-entities.png" title="An utterance annotated using the Speechly Annotation Language." alt="A figure explaining one utterance with its intent and entities tagged by using Speechly Annotation Language">}}

## Intents and entities

For each example utterance, an **intent** and one or more **entities** need to be annotated. 

Whether a user says, "One pizza Margherita, please" or "I'd like to have one pizza Margherita," the intent there is the same – to get some pizza – but the way it is said differs quite a lot. That's why we have to provide our model with examples of how the intent of ordering pizza may be expressed.

Entities can be thought of as modifiers for the intent. The utterances, "One pizza Margherita, please" and "I'd like to have one pizza Diavola," express the same intent – that of ordering pizza – but they have one significant difference: the particular pizza the customer wants. So, the actual pizza (i.e., "pizza Margherita" and "pizza Diavola") can be thought of modifying the order intent.

Because of the machine learning algorithms we employ, you don't have to write every single possible utterance to your examples. That's precisely why they are called examples. On the other hand, the more examples the model is provided with, the better it works. It's impossible to say the exact number of example utterances a model should be given, but on a general note, the bigger the sample size, the better. Collecting real-life data from users and updating the model periodically is also recommended.

Your model can have as many intents and entities as needed. 

{{< info title="Allowed characters" >}}Intent and entity names can only contain letters (a-z) in lower and upper case, numbers, and characters `-` and `_`. {{< /info >}}


