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

# Methods

- initialize(project_id: str | app_id: str)
- startContext(app_id: str?)
- stopContext()
- onClientStateChanged(callback: function)
- onSegmentChange(callback: function)


# Segment
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


# Intent
```json
Intent { name: string, isFinal: boolean }
```
| name | type | description |
| ---- | ---- | ----------- |
| name | String | Name of the intent. |
| isFinal | boolean | Boolean that indicates if the intent name is finalised. When isFinal is false it is possible that in subsequent calls to callback the name of the intent can change. When isFinal is true, it is guaranteed that the intent name does not change until the segment changes.|

# Entity
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

# Transcript
```json
Transcript { index: int, value: string, isFinal: boolean }
```
| name | type | description |
| ---- | ---- | ----------- |
| index | int | Position of this Transcript in the complete transcript.|
| value | String | The word of this Transcript.|
| isFinal | boolean | Boolean that indicates if the word associated with this Transcript is final, or if it can change in subsequent calls to callback.|
