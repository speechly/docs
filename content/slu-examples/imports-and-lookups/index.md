---
title: Imports and lookup entity type
description: Imports are an advanced SAL feature that enables you to define variables outside the SAL view, improving readability. The lookup entity type allows you to define a canonical output value for entities with synonyms.
weight: 3
category: "User guide"
aliases: [/editing-nlu-examples/imports-and-lookup/]
menu:
  sidebar:
    title: "Imports and lookup entity type"
    parent: "Configuring Your Application"
---

{{< info title="Learn more" >}} This part of the documentation expands on what we've previously written about the SLU examples and the Speechly Annotation Language. The best way to start learning Speechly is to complete [Quick Start](/quick-start). You might want to learn about the [Advanced syntax features](/slu-examples/editing-slu-examples/#advanced-syntax-features/) too.{{< /info >}}

## Import a list variable

The imports feature enables you to define a SAL variable list outside the SAL configuration. Normally, the list variables are written in plain SAL, like the following:
```
my_sal_list = [first item|second item|third item]
$my_sal_list # here using the list
```
With the imports, you can put these items in a CSV file and import them to your app configuration. Just add the following lines to your app configuration:
```
imports: 
  - name: my_sal_list
    source: my_sal_list_items.csv
    field: 1
templates: |
    $my_sal_list # here using the list
```
Now one list variable is imported: `my_sal_list`. The key *source* is the path to the file that contains the variable, and the *field* defines the number of the column where the variable is located (direction from left to right, "1" standing for the *first* column). The imported variable can be used in the familiar manner by prepending the dollar (`$`) sign to the variable name: `$my_sal_list`.

## Lookup entity type

The lookup entity type enables defining special outputs for recognized entity values. This is useful, for instance, if you want the Speechly API to return product codes for uttered products.
To use the lookup entity type, add the following lines to your app configuration along with your imports and entities:
```
imports:
  ...
  - name: products
    source: lookup.csv
    field: 1
  - name: inventory_ids
    source: lookup.csv
    field: 2
entities:
  ...
  - name: inventory_id
    type: lookup
    input_items: $products
    output_items: $inventory_ids
```
Here we have defined an entity named `inventory_id` whose type is `lookup`. As the *input_items* we have the imported variable `products`, and as the *output_items* we have the imported variable `inventory_ids`. These variables need to be imported for them to be available for use in the lookup. Also, the number of input and output items must be the same.
The lookup maps the recognized entities, matching one of the values in the input items to the corresponding values in the output items.

Let us demonstrate how this works:

## Example of imports and the lookup entity type

First, we need a training configuration file. Let's call it app_config.yaml:

```
asr_biasing: moderate
imports: 
  - name: device_names
    source: device.csv
    field: 1
  - name: devices
    source: device.csv
    field: 2
  - name: room_names
    source: room.csv
    field: 1
  - name: rooms
    source: room.csv
    field: 2
entities:
  - name: device
    type: lookup
    input_items: $device_names
    output_items: $devices
  - name: room
    type: lookup
    input_items: $room_names
    output_items: $rooms
templates: |
    action = [turn|set|put|switch]

    *turn_on $action on the $device_names(device) 
    *turn_off $action off the $device_names(device)

    *turn_on $action the $device_names(device) on
    *turn_off $action the $device_names(device) off

    *turn_on $action on the $device_names(device) in the $room_names(room)
    *turn_off $action off the $device_names(device) in the $room_names(room)
```

Here we have two imports that point to the file *device.csv*: `device_names` and `devices`. The next two imports point to the file *room.csv*: `room_names` and `rooms`. These CSV files could have the following content:

*device.csv*
```
light,light
lamp,light
tv,tv
telly,tv
television,tv
radio,radio
fm,radio
```

*room.csv*
```
living room,living room
lounge,living room
bedroom,bedroom
chamber,bedroom
kitchen,kitchen
cookery,kitchen
```

We also have defined two lookup entities: *device* and *room*. The *device* lookup entity maps, for example: 'lamp' -> 'light', 'telly' -> 'tv', and 'fm' -> 'radio'. The *room* lookup, then, has mappings like: 'lounge' -> 'living room', 'chamber' -> 'bedroom', and 'cookery' -> 'kitchen'.

## How to deploy an app with imports and the lookup entity type? 

### Install Speechly CLI
The imports and the lookup entity type are only available via the [Speechly CLI](https://github.com/speechly/cli). 

You can install them to macOS, Linux, or Windows. Please follow the installation [instructions](https://github.com/speechly/cli#installation).

After installation, navigate to the Speechly Dashboard. Choose your project (on the top right corner of the screen) and go to Project Settings. Create a new API Token and copy it.

Then configure your Speechly CLI client with the API Token you just created, following the instructions found [here](https://github.com/speechly/cli#usage).

### Deploy using Speechly CLI

Start by creating an app at the Speechly [Dashboard](https://www.speechly.com/dashboard/), if you haven't already, and copy and save your app ID. You can find more information about creating apps in [Quick Start](https://www.speechly.com/docs/client-libraries/web-client/).

Then, go to the directory you want to deploy.

`speechly deploy . -a APP_ID -w`

Here, the APP_ID is your application ID. The flag `-w` means watch; the CLI will hang until the app is deployed or failed.

If the deploy fails, you can see the error message by 

`speechly describe -a APP_ID`
