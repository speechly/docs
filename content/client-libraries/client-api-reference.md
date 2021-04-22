---
title: Client Library API Reference
description: All speechly [client libraries](/client-libraries/) implement the same API, irrespectively of platform or programming language.
category: "References"
display: article
weight: 6
menu:
  sidebar:
    title: "Client API Reference"
    parent: "Client Libraries"
---
This is a high-level overview of the Client Library API. The specifics depend on the Client Library being used, but all Client Libraries implement this API subject to some platform specific variations.

# Methods

The most important methods especially for new users involve initialising the client, as well as registering a segment handler with `onSegmentChange`.

## initialize(app_id: string | proj_id: string)
Creates and initialises the Client. In most of our Client Libraries this is implemented by the constructor of the client object. For most applications you must pass as argument the `app_id` (available from the Dashboard or Command Line Tool). All connections initated by the client will be targeted to this `app_id`.

You can also pass a `project_id`. This is a more advanced feature, where you must identify the application for each context separately (see `startContext`).

---

## onSegmentChange(segment_handler: function)
Define the segment handling callback function. How this is precisely done varies a little across Client Libraries. See [Basic usage](/client-libraries/usage/#handle-speech-input) for a brief example for each Client library. In general, `segment_handler` is passed a [Segment](#the-segment-data-structures) object from which you can look up the intent and entities.

---

## startContext(app_id: string?)
Starts an "audio context", i.e., opens the microphone, starts streaming audio, and starts receiving events (intents, entities and segment changes) from the gRPC API. If you have initialised the client by providing a `proj_id`, you **must** also give the `app_id` to which the recording is directed. If you initialised the client by providing an `app_id`, no arguments are needed.

---

## stopContext()
Stops the "audio context", i.e., closes the microphone, stops streaming audio. Events are still being received until the server stops the stream.

---

## onClientStateChanged(state_handler: function)
Defines a callback function for handling client state changes.

---

# The Segment data structures
The callback function registered with `onSegmentChange` is called repeatedly with a `Segment` object that is updated with new transcript, intent, and entities as the user speaks.

## Segment
```json
Segment {
    contextId: string (UUID),
    segmentId: int,
    isFinal: boolean,
    intent: Intent,
    entities: list of Entity objects,
    transcripts: list of Transcript objects
}
```
| name | type | description |
| ---- | ---- | ----------- |
| contextId | string | The audio context to which this segment belongs to. |
| segmentId | int | The index (zero-based) of this segment within the audio context. An audio context can consist of several consecutive segments. |
| isFinal | boolean | A boolean that indicates if this is the last time callback is called with this segment. Subsequent calls to callback within the same audio context refer to the next segment. Note that none of the data associated with this segment will no longer be attached to the next segment. |
| intent | SpeechIntent | The intent associated with this segment. There can only be one intent for a segment. |
| entities | List<Entity> | A list of entities. There can be several entities that belong to the same segment. |
| transcripts | List<Transcript> | A list of Transcript objects. Together these contain the text produced by speech recognition. |


## Intent
```json
Intent { name: string, isFinal: boolean }
```
| name | type | description |
| ---- | ---- | ----------- |
| name | String | Name of the intent. |
| isFinal | boolean | Boolean that indicates if the intent name is finalised. When isFinal is false it is possible that in subsequent calls to callback the name of the intent can change. When isFinal is true, it is guaranteed that the intent name does not change until the segment changes.|

## Entity
```json
Entity { name: string, value: string, isFinal: boolean,
         startIndex: int, endIndex: int }
```
| name | type | description |
| ---- | ---- | ----------- |
| type | String | The name of the entity.|
| value | String | The value of the entity.|
| isFinal | boolean | Boolean that indicates if the entity is finalised. Behaves in the same way as Intent.isFinal.|
| startIndex | int | Index of the Transcript that contains the first token of the transcript span this entity was extracted from.|
| endIndex | int | Index of the Transcript that contains the first token of the transcript span this entity was extracted from.|

## Transcript
```json
Transcript { index: int, value: string, isFinal: boolean }
```
| name | type | description |
| ---- | ---- | ----------- |
| index | int | Position of this Transcript in the complete transcript.|
| value | String | The word of this Transcript.|
| isFinal | boolean | Boolean that indicates if the word associated with this Transcript is final, or if it can change in subsequent calls to callback.|
