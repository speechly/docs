---
title: SAL Cheat Sheet
description: All supported SAL features and when to use them
menu:
  sidebar:
    weight: 5
    parent: "Configuring Your Application"
---

## Intent

`*show_products Show all products`

*An end user utterance "Show all products" will return an intent `show_products`*

Intents are defined by an asterisk `*`. The whole sentence after the `*`-sign will be recognized as this intent.

## Entity

`*show_products Show [jeans](category)`

Entities are defined by `[entity value](entity type)` notation.

*An end user utterance "Show jeans" will return an entity `jeans` for entity type `category`.*

## Variables

```
category = [
    jeans
    shoes
]

*show_products Show $category(category)
```

Variables are defined by `variable = []` notation and used by `$variable`. Variables can contain all valid SAL syntax.

## Inline lists

`*show_products [Show|view] products` 

Inline lists are a type of variable shorthand that can be used for simple substations.

## Optional input

`*show_products Show products {please}`

Optional input is a part of end user utterance that may or may not exist.

## Multi-intent utterances

`*show_products Show products {and} *order order by price`

You can define multiple intents in one sentence. This example would return two intents for the end user utterance "Show products and order by price"

## Dates

`*book Book a restaurant for $SPEECHLY.DATE(date)`

*Supports end user utterances such as "Book a resturant for next Monday" or "Book a restaurant for the fifth of July"*

`$SPEECHLY.DATE` is a [standard entity](/slu-examples/standard-variables/) type for dates. 

## Numbers

`*add_expense Add an expense for $SPEECHLY.NUMBER(amount) dollars"`

*Supports end user utterances such as "Add an expense for two thousand five hundred and sixty dollars"*

`$SPEECHLY.NUMBER` is a [standard entity](/slu-examples/standard-variables/) type for numbers.

## Alphanumeric sequences

`*add_product add $SPEECHLY.IDENTIFIER_MEDIUM(product_id) to cart`

*Supports end user utterance such as "Add ABC123 to cart" or "Add 4FG13L to cart"

`$SPEECHLY.IDENTIFIER_SHORT, $SPEECHLY.IDENTIFIER_MEDIUM and $SPEECHLY.IDENTIFIER_LONG` are [standard entity](/slu-examples/standard-variables/) types for alphanumeric sequences of various lengths. These can be used for product codes, license plates or other identifiers.