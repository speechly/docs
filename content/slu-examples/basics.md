---
title: Speechly Configuration basics
description: The configuration is used both to adapt the speech recognition model, as well as to train models for detecting intents and entities for your specific application.
weight: 1
category: "User guide"
aliases: [/editing-nlu-examples/]
menu:
  sidebar:
    title: "Configuration basics"
    parent: "Configuring Your Application"
---
# What is a configuration?
A Speechly configuration contains **training data for machine learning models**. It describes a number of *example utterances* that your users might be saying, and from which an *intent* and possibly a number of *entities* should be parsed. The example utterances are written in a Markdown-like syntax:
```
*search do you have [blue](color) [jackets](product)
```
The above example defines the user utterance *"do you have blue jackets"*, assigns this to have intent `search`, and defines two entities that are named `color` and `product`, with values `blue` and `jackets`, respectively. The intent and entities are returned to your application, and based on these your voice UI can carry out the action requested by the user. In this case the UI should update a search result view to show only blue jackets.

# How many example utterances must I provide?
A configuration must contain at least a few example utterances for every functionality of your voice UI. In general, the more example utterances you can provide, the better.

However, this is not as tedious as you might think! Even simple Speechly configurations can be written as compact *Templates* that are then expanded into a large set of example utterances during model training. For example, the configuration
```
product = [t shirts | hoodies | jackets | jeans | slacks | shorts | sneakers | sandals]
color = [black | white | blue | red | green | yellow | purple | brown | gray]
*search do you have $color(color) $product(product)
```
declares two variables, `product` and `color`, and assigns to both a list of relevant values. The 3rd line defines a *Template* that generates 72 example utterances that each start with "do you have", followed by a color entity and a product entity, with their values taken from the respective lists:
```
*search do you have [black](color) [t shirts](product)
*search do you have [white](color) [t shirts](product)
*search do you have [blue](color) [t shirts](product)
...
*search do you have [gray](color) [sandals](product)
```
All of these 72 example utterances are compactly defined just by the three lines of "code" above.

It is useful to think of preparing the example utterances as the task of "programming" a data generator. You can learn more about how this is done from the [Speechly Annotation Language Syntax Reference](/slu-examples/cheat-sheet/) as well as [Speechly Annotation Language Semantics](/slu-examples/semantics/).

# What is an intent?
The intent of an utterance that indicates what the user in general wants. It is defined in the beginning of an example with the syntax `*intent_name`, i.e. the name of the intent prefixed by an asterisk. Every example utterance must have an intent assigned to it.

Intents capture the various functionalities of your voice UI. For example, a shopping application might use different intents for *searching products*, *adding products* to the cart, *removing products* from the cart, and *going to the checkout*.

# What are entities?
Entities are "local snippets of information" in an utterance that describe details relevant to the users need. An entity has a `name`, and a `value`. An utterance can contain several entities.

They are defined using the syntax `[entity name](entity value)`.

In the shopping example above, the entities are `color` and `product` that have the values `blue` and `jackets`, respectively. An entity can take different values, and your configuration should give a variety of examples of these.


# How do intents and entities appear in my application?
Our spoken language understanding system extracts intents and entities from the user's speech input, and returns these to your application. When using one of our [Client Libraries](/client-libraries/), handling of intents and entities is done via our [Client API](/client-libraries/client-api-reference). The same API provides your application with a raw transcript of the users speech.

# What is a well-designed example utterance?
Since Speechly is a **spoken language** understanding system, it is important to use example utterances that as precisely as possible reflect how users **talk**. An example utterance is (probably) good, if it sounds natural when spoken out aloud.

Notice that how something spoken can depend on the *context*. For example, the number 16500 could be either the price of a car, or a (US) zip-code. However, it is spoken quite differently depending on the context: *"sixteen thousand five hundred"* (price) vs *"one six five zero zero"* (zip-code). A good configuration takes such contextual details into account.

# Where can I learn more about Speechly Annotation Language?
- Take a look at [example configurations](/slu-examples/example-configuration/) and try to understand how they work.
- The [SAL syntax summary](/slu-examples/cheat-sheet/) should be helpful.
- Try designing your own configurations on the [Dashboard](https://api.speechly.com). Start with something simple, and then expand this little by little.
- [SAL semantics](/slu-examples/semantics) is a useful resource once you have familiarised yourself with the very basics and have written a few simple configurations.

# Other things to remember
- Intent and entity names can only contain letters (a-z) in lower and upper case, numbers, and characters `-` and `_`.
- Our entity detection system is based on machine learning, and can often generalize to entity values that are not present in the configuration. However, entity values that explicitly appear in the example utterances are more likely to be correctly recognized.
