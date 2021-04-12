---
title: Speechly Annotation Language Syntax
description: Reference of all SAL features with simple usage examples
weight: 2
menu:
  sidebar:
    parent: "Configuring Your Application"
    title: "SAL Syntax"
---
SAL syntax consists of *Annotation syntax* and *Template notation*.

# Annotation syntax
The annotation syntax is used to annotate intents and entities.

## Intent

Intents are defined by prepending the example with `*intent_name`. The remaining sentence after the `*intent_name` part will be recognized as having intent `intent_name`.

For example:

```
*show_products show all products
```

*An end user utterance "Show all products" will return the intent `show_products`*


## Entity

Entities are defined by `[entity value](entity name)` notation.

For example:

```
*show_products show [jeans](category)
```
*An end user utterance "Show jeans" will return the value `jeans` for entity name `category`.*

# Template notation
Template notation is used to define *Templates* that are expanded to *Example utterances* during deployment. See also [SAL Semantics](/slu-examples/semantics) for a more detailed description about how *Example utterances* and *Templates* relate to each other.

## Lists

Lists are defined by `[exp1 | exp2 | ... | exp_N]`, where `exp1`, `exp2` ... are arbitrary SAL expressions.

When a template having a list is expanded, only one of the list elements is used in the final example utterance. For example, the template:

```
*show_products [show | view | i want to see] products
```
Is equivalent to writing
```
*show_products show products
*show_products view products
*show_products i want to see products
```

## Optional parts
A substring of an example utterance can be declared as optional by enclosing it in curly braces `{this substring is optional}`. The optional part can be an arbitrary SAL expression.

The optional parts of an example utterance may or may not exist. The template
```
*show_products {show} products {please}
```
is equivalent to writing
```
*show_products show products please
*show_products show products
*show_products products please
*show_products products
```

## Variables

Variables are declared with the syntax `variable_name = arbitrary-SAL-expression`, and their value is accessed by `$variable_name`. You can assign any arbitrary SAL expression to a variable.

For example, a common use case for variables are lists of various entity values:
```
categories = [jeans | shoes | shirts | accessories]
*show_products show $categories(category)
```
Note that above `$categories(category)` is shorthand for `[$categories](category)`. When the entity value is looked up from a variable, the brackets are not necessary.

Variables can also be used to assemble complex phrases from simple components
```
digit = [one | two | three | four | five | six | seven | eight | nine | zero]
symbol = [hash | slash | dash]
product_code = $digit $digit $symbol $digit $digit $digit $digit
```
Above, `product_code` defines a template that expands to all possible utterances that start with two digits, followed by one of the symbols, followed by four digits, such as *"six four dash nine nine zero four"* or "*one two hash three four five six"*.

*Note: We provide you with several predefined [Standard Variables](/slu-examples/standard-variables/) that you can take into use in your configuration! These are useful when your configuration must support numbers, dates, times, sequences of alphanumeric characters, email addresses, etc.*

Note that any varible `x` *must* be declared in your configuration before it can be used with the `$x` notation. This is ok:
```
x = [hello | hi | greetings]
*greet $x
```
This is **not** ok:
```
*greet $x
x = [hello | hi | greetings]
```

## Permutations

A permutation generates all possible permutations of the given list of expressions. It is defined with the syntax `![exp1 | exp2 | ... | exp_N]`, where `exp1`, `exp2`, ... can be arbitrary SAL expressions.

For example:
```
*book Book a ticket ![from [New York](from) | to [London](to) | for [two](num_passengers)]
```
is equivalent to writing:
```
*book Book a ticket from [New York](from) to [London](to) for [two](num_passengers)
*book Book a ticket from [New York](from) for [two](num_passengers)] to [London](to)
*book Book a ticket to [London](to) from [New York](from) for [two](num_passengers)
*book Book a ticket to [London](to) for [two](num_passengers) from [New York](from)
*book Book a ticket for [two](num_passengers) from [New York](from) to [London](to)
*book Book a ticket for [two](num_passengers) to [London](to) from [New York](from)
```
