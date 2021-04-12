---
title: Speechly Annotation Language Semantics
description: How is a SAL configuration structured?
weight: 3
menu:
  sidebar:
    parent: "Configuring Your Application"
    title: "SAL Semantics"
---
In this document we first discuss what kind of expressions can be written in a SAL configuration. For beginners we recommend to only skim this section and take a glance at the examples.

Then, we briefly review how SAL [Template expansion](#template-expansion) works. This latter part is advanced material that is not relevant for new users.

# SAL expressions
A SAL configuration consists of *SAL expressions*. A SAL expression is either
- an *Example utterance*,
- a *Template*,
- a *Partial template*, or
- a *Variable definition*.

Every line in a SAL configuration must define an *Example utterance*, a *Template*, or a *Variable definition*.

Importantly: A *Partial template* may only appear as part of a *Template*, but not by itself.

Also, a *Variable definition* must appear before the variable in question is being used / referred to.

## Example utterances
A SAL expression is an *Example utterance* if it does *not contain* any [*Template notation*](/slu-examples/cheat-sheet/#template-notation). That is, it can only be expanded to itself. All the following SAL expressions are *Example utterances*:
```
*search show [red](color) [pants](product)
*book book a flight from [New York](depart_city) to [London](arrival_city)
*greeting hello
```
All SAL expressions that are *Example utterances* **must** start by defining an intent.


## Templates
A SAL expression is a *Template* if it contains [*Template notation*](/slu-examples/cheat-sheet/#template-notation), i.e., at least one of the following: List, Optional part, Variable reference, or a Permutation, *and* can be expanded to an *Example utterance*. All of these SAL expressions are *Templates*:
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

In particular, a *Partial template* can not be used as such, but it must always appear as part of a complete *Template*.


## Variable definitions
A SAL expression is a *Variable definition* if it has the format
```
LHS = RHS
```
where `LHS` is a variable name and `RHS` is either an *Example utterance*, a *Template* or a *Partial Template*. 


# Template expansion

The *Templates* in your SAL configuration are randomly expanded to *Example utterances* during training. The training system does not exhaustively expand all possible utterances from the templates, but randomly generates a sufficient amount of *Example Uttearances*.

A *Template* is expanded by processing it left-to-right. Whenever [Template notation](/slu-examples/cheat-sheet/#template-notation) is encountered, the expansion algorithm expands the part in question according to its expansion rule. These are given below for Lists, Optional parts, Variables, and Permutations. The algorithm is applied recursively if applying the expansion rule resolves to something that can be further expanded.

## Expansion rules

- *Lists* A list item is selected uniformly at random from all list items.
- *Optional parts* The expression enclosed in the Optional part is expanded with probability 0.5, and omitted with probability 0.5.
- *Variables* The variable reference is replaced with the variables value, and the expansion algorithm proceeds from there.
- *Permutations* The expressions in the permutation list are arranged in the resulting *Example utterance* so that every arrangement has equal probability. (That is, with probability 1/N! if there are N expressions in the *Permutation*.)

## An Example
The workings of the expansion algorithm are best illustrated by an example. Suppose we are given the template
```
*search show {[red | green | blue](color)} [pants | shirts | shoes](product)
```
Since running the algorithm involves randomness, the following is an example of one possible outcome:

1. Read token `*search` which does not expand, output `*search`.
2. Read token `show` which does not expand, output `show`.
3. Read the *Optional part* `{[red | green | blue](color)}`, flip a coin, decide to skip the optional part, output nothing.
4. Read the *List* `[pants | shirts | shoes]`, apply its expansion rule and select one of the items uniformly at random. Output `[shoes]`.
5. Read token `(product)` which does not expand, output `(product)`.

Concatenating the output yields the *Example utterance*
```
*search show [shoes](product)
```
