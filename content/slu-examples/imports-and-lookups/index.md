---
title: Imports and Lookups
description: Imports are an advanced SAL feature that enables you to define long lists outside the SAL syntax. The lookup entity type allows you to define a normalized return value for entities that have several synonyms.
weight: 7
category: "User guide"
aliases: [/editing-nlu-examples/imports-and-lookup/]
menu:
  sidebar:
    title: "Imports and Lookups"
    parent: "Configuring Your Application"
---

***Note!** These functionalities are not available on the Dashboard. Using Imports and Lookups requires deploying your application using the [Command Line Tool](/dev-tools/command-line-client/)!*

# Importing a List from file

The imports feature enables you to define lists outside the SAL configuration, and load them to variables that you can use as part of your SAL templates.

Normally, a *List* is assigned to a variable in SAL as follows:
```
fruit = [apple | orange | blood orange | banana | lemon | apricot | peach | pineapple]
```
However, if your list contains hundreds of items, the above becomes cumbersome to write and maintain.

Using the import functionality, you can import the list from a CSV file. The CSV file must have the list items in one of its columns, and the file must be located in the same directory as your [Configuration YAML file](/dev-tools/command-line-client/#configuration-yaml).

## A simple import example

In the simplest case the CSV file to be imported contains only one column, with one list item per row. Suppose the file is called `fruits.csv`, and it has the following content:
```bash
apple
orange
blood orange
banana
lemon
apricot
peach
pineapple
```
To import this list from `fruits.csv` and store it in a variable called `fruit`, add the following lines to your Configuration YAML:
```yaml
imports: 
  - name: fruit
    source: fruits.csv
    field: 1
```
Now, you can use `$fruit` in your templates, exactly as you would after having defined it in a SAL expression. The imported variable is like any other variable in SAL.

You can specify as many imports as you like. If you had a similar list in another file called `vegetables.csv`, you can import both lists to their respective variables (`fruit` and `vegetable`) by defining:
```yaml
imports: 
  - name: fruit
    source: fruits.csv
    field: 1
  - name: vegetable
    source: vegetables.csv
    field: 1
```

## Import Reference
Imports are defined by adding the `imports` key to your [Configuration YAML](/dev-tools/command-line-client/#configuration-yaml). The value of `imports` must be a list of dictionaries that each have the keys `name`, `source` and `field`:
```yaml
imports:
  ...
  - name: name of the variable to which the list is stored
    source: name of the CSV file that contains the list items
    field: the column index (1-based) in the source file that contains the list items
  ...
```

# The lookup Entity Data Type

The returned values of entities having Entity Data Type `lookup` are normalized according to a simple lookup mechanism. This is useful for mapping synonyms to a normalized value, such as always returning the entity value `TV` even if the user said "television", "TV", or "telly".

## A simple Lookup example

To define a `lookup` entity, you must specify an *explicit mapping that provides for every synonym its normalized value* that is returned by the API. This is done by preparing a CSV file with two columns, one of which contains a list of synonyms, and another that contains the normalized values.

For example, suppose the file `devices.csv` has the following content:
```bash
light,light
lights,light
lamp,light
tv,tv
telly,tv
television,tv
radio,radio
stereo,radio
```
Above, each row defines synonym in the 1st column, and its normalised value in the 2nd column. That is, the synonyms "light", "lights", and "lamp" are all mapped to *light*, the synonyms "tv", "telly", and "television" are mapped to *tv*, and "radio" and "stereo" are both mapped to *radio*.

Defining a *Lookup* entity is done by first importing both columns of `devices.csv` into two variables using the list import mechanism described [above](#importing-a-list-from-file):
```yaml
imports:
  - name: device_as_spoken
    source: devices.csv
    field: 1
  - name: device_normalized
    source: devices.csv
    field: 2
```
Now `$device_as_spoken` is a list that contains the 1st column of `devices.csv`, and `$device_normalized` contains the 2nd column.

The lookup entity itself is defined using these two variables in the `entities` section of your Configuration YAML, by specifying the `type` of the entity as `lookup`, and defining two additional keys: `input_items` and `output_items` as follows:
```yaml
entities:
  - name: device
    type: lookup
    input_items: $device_as_spoken
    output_items: $device_normalized
```
Unlike other [Entity Data Types](/slu-examples/postprocessing) that are defined simply by specifying the `name` of the entity together with its type, the `lookup` type  requires two additional parameters: `input_items` and `output_items`, which here are assigned the `$device_as_spoken` and `$device_as_normalized` lists, respectively.

When defining your SAL templates, you should only use `$device_as_spoken`, because remember that the *Example utterances* you define must accurately reflect how your users talk. For example:
```yaml
templates: |
  *turn_on [turn | switch] on the $device_as_spoken(device)
  *turn_on [turn | switch] the $device_as_spoken(device) on
```
Now, when the user says "turn on the stereo", the returned `device` entity has the value `radio`.

## Some remarks about lookup entities
There are a couple of things to remember when using lookups:
1. If the user says something that the entity detector can identify as a `device`, but the corresponding synonym is *not* present in the lookup mapping, the system returns verbatim the user's expression. For example, if the user says "turn the music player on", the entity detector probably identifies "music player" as a `device`, but since "music player" is not defined in the lookup, the returned `device` entity would have the value `music player`.

## Lookup reference
Lookups are defined by
1. importing two lists of equal length, called *input list* and *output list*, using the list import mechanism,
2. defining one of these lists as the `input_items`, and the other as `output_items` of the lookup entity.

The lookup entity definition has the fields:
```yaml
entities:
  ...
  - name: name of the entity
    type: lookup
    input_items: reference to the variable with the imported input list
    output_items: reference to the variable with the imported output list
  ...
```
While we recommend to import both lists from the same CSV file, this is not a requirement. But it is important that the two lists are of equal length, and that the item in the *i*th position of the *output list* is the normalized value of the item in the *i*th position of the *input list*.
