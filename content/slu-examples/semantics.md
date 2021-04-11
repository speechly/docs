---
title: Speechly Annotation Language Semantics
description: How is a SAL configuration structured?
weight: 3
menu:
  sidebar:
    parent: "Configuring Your Application"
    title: "SAL Semantics"
---
# Introduction
A SAL configuration defines *example utterances* that users should say to your application. These are used for

1. *adapting the speech recognition model*, as well as
2. *training the intent and entity detectors*

for your application.

SAL allows you to compactly define a possibly very large set of example utterances by using **templates**. These templates are *randomly expanded* to final example utterances during training. The training system does not exhaustively expand all possible utterances from the templates, but randomly generates examples that are sufficient for training.

# SAL expressions
A SAL expression is either
- an *Example utterance*,
- a *Template*,
- a *Partial template*, or
- a *Variable definition*.

Every line in a SAL configuration must define an *Example utterance*, a *Template*, or a *Variable definition*.

Importantly: A *Partial template* may only appear as part of a *Template*, but not by itself.

Also, a *Variable definition* must appear before the variable in question is being used / referred to.

## Example utterances
A SAL expression is an *Example utterance* if it does not contain any *template notation*. That is, it can only be expanded to itself. All the following SAL expressions are *Example utterances*:
```
*search show [red](color) [pants](product)
*book book a flight from [New York](depart_city) to [London](arrival_city)
*greeting hello
```
All SAL expressions that are *Example utterances* **must** start by defining an intent.


## Templates
A SAL expression is a *Template* if it contains *template notation*, i.e., at least one of the following: List, Optional part, Variable reference, or a Permutation, *and* can be expanded to an *Example utterance*. All of these SAL expressions are *Templates*:
```
*search show {[red | green | blue](color)} [pants | shirts | shoes](product)
*book book a flight ![from $city(depart_city) | to $city(arrival_city)]
*greeting $all_greeting_phrases
```
In general a *Template* starts with an intent definition. However, *if* a *Variable definition* expands to a *Template*, then a reference to this variable is also a *Template*. That is, this is okay:
```
all_my_intents = [
  *buy buy $company(stock_name) for $amount(value) dollars
  *sell sell $company(stock_name) for $amount(value) dollars
]
$all_my_intents
```
But the following is **not okay**:
```
all_my_intents = [
  buy $company(stock_name) for $amount(value) dollars
  sell $company(stock_name) for $amount(value) dollars
]
$all_my_intents
```
This is because the expressions in the `all_my_intents` list do not expand to valid *Example utterances* as they are missing the intent definition.

## Partial templates
A *Partial Template* is just like a *Template*, but it does not expand to a valid *Example utterance*. That is, it is missing the intent definition.
Examples of Partial templates are:
```
hello
[New York | London | Paris | Berlin | Tokyo]
{can i have} a [large](size) [coffee](product)
```
A *Partial Template* is meaningful only as

- a List item,
- an Optional part,
- a Permutation item,
- the right-hand-side of a *Varible definition*.

In particular, a *Partial template* can not be used as such, but it must always appear as part of a bigger *Template*.


## Variable definitions
A SAL expression is a *Variable definition* if it has the format
```
LHS = RHS
```
where `LHS` is a variable name and `RHS` is either an *Example utterance*, a *Template* or a *Partial Template*. 


