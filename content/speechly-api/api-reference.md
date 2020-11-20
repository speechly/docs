---
title: API Reference
description: API reference for the Speechly API 
weight: 99
category: "References"
display: article
menu:
  sidebar:
    title: "API Reference"
    parent: "Speechly API"
---

# Description 

The Speechly SLU service provides spoken language understanding in a bidirectional stream. It takes the [`SLURequest`]({{< relref "api-reference.md#slurequest">}}) stream as an input and outputs the [`SLUResponse`]({{< relref "api-reference.md#sluresponse" >}}) stream in real-time.

A new stream is started by initializing the SLU engine with a `config` value. 

The Speechly API requires that a user has an access token from the [`Identity`]({{< relref "api-reference.md#identity-service" >}}) service. The token must be included in the metadata as an `Authorization` key with value `Bearer TOKEN_HERE`.

When a new `SLU.Stream` is started, the client must first send the `config` value, which configures the SLU engine. Should it not be the first message sent, the stream closes with an error.

When the client sends the [`SLUevent.START`](/speechly-api/api-reference#sluevent) message to start the audio stream and starts sending data, the server responds with [`SLUResponse`]({{< relref "api-reference.md#sluresponse" >}}) messages until the stream gets ended by the client sending [`SLUEvent.STOP`]({{< relref "api-reference.md#sluevent" >}}).

{{< warning title="Stream requires config" >}} If the first message to the [`SLU`](/speechly-api/api-reference#slu-service) service is not `config`, the stream closes with an error. You'll need a Speechly app ID for creating the configuration. You can get your app ID by signing up to the Speechly Dashboard. {{< /warning >}}

<!-- ## Services
* Identity
* SLU
* WLU

## Requests

* LoginRequest
* SLURequest
* WLURequest

## Responses

* LoginResponse
* SLUResponse
* WLUResponse
 -->

# Identity service

{{< highlight "protocol buffer" >}}

service Identity {
    rpc Login(LoginRequest) returns (LoginResponse) {}
}
{{</ highlight >}}

The Identity service provides client login. When successful, it returns an access token to access the [`SLU`]({{< relref "api-reference.md#slu-service" >}}) and [`WLU`]({{< relref "api-reference.md#wlu-service" >}}) services.

### LoginRequest

{{< highlight "protocol buffer" >}}

message LoginRequest {
    string device_id = 1;
    string app_id = 2;
}
{{</ highlight >}}


|Name|Type|Description|
|---|---|---|
|intent|string|A unique identifier for the end-user. | required |
|intent|string|An application ID registered with Speechly. | required |

#### Example

```javascript

const identity = new Speechly.v1.Identity(host, credentials);
identity.login({ appId, deviceId }, (err, response) => {
  if (err) {
    return reject(err);
  }
  const token = response.token;
});

```

### LoginResponse

{{< highlight "protocol buffer" >}}

message LoginResponse {
    string token = 1; 
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|intent|string|An access token to be used for the [`SLU`]({{< relref "api-reference.md#slu-service" >}}) and [`WLU`]({{< relref "api-reference.md#wlu-service" >}}) services.


# SLU service

{{< highlight "protocol buffer">}}
service SLU {
    rpc Stream(stream SLURequest) returns (stream SLUResponse) {}
}
{{</ highlight >}}

```javascript
const metadata = new grpc.Metadata();
metadata.add("Authorization", `Bearer ${token}`);
const client = new Speechly.v1.SLU(host, credentials);
const slu = client.Stream(metadata);
````

## Messages

### SLURequest

{{< highlight "protocol buffer"  >}}
message SLURequest {
    oneof streaming_request {
        SLUConfig config = 1;
        SLUEvent event = 2;
        bytes audio = 3;
    }
}
{{< /highlight >}}

|Name|Type|Description|
|---|---|---|
|config|SLUConfig|Provides the configuration for initializing the SLU service.|
|event|SLUEvent|Either ´START´ or ´STOP´ to begin or end the stream.|
|audio|bytes|The actual audio stream.|

#### Example 

{{< highlight "protocol buffer"  >}}

slu.write({ config: { channels: 1, sampleRateHertz: 16000 } });
slu.write({ event: { event: "START" } });
const audio = new wav.Reader();
audio.on("data", audioData => {
  if (slu.writable) {
    slu.write({ audio: audioData });
  }
});
slu.on("data", data => {
  console.dir(data, { depth: null });
});
audio.on("end", () => {
  slu.write({ event: { event: "STOP" } });
  slu.end();
});
fs.createReadStream("../audio.wav").pipe(audio);
{{< /highlight >}}


See the complete example.

### SLUConfig

{{< highlight "protocol buffer"  >}}
message SLURequest {
    enum Encoding {
        LINEAR16 = 0; 
    }
    Encoding encoding = 1;
    int32 channels = 2;
    int32 sample_rate_hertz = 3;
    string language_code = 4;
  }
}
{{< /highlight >}}

|Name|Type|Description|
|---|---|---|
|encoding|Encoding|The choice of audio encoding as an object; ´LINEAR16 = 0´ is for raw, linear 16-bit PCM audio. | required |
|channels|int32|The number of channels in the audio stream must be at least 1.| required |
|sample_rate_hertz|int32|The audio stream sampling rate must be at least 8000Hz, but 16000Hz is preferred. | required |
|language_code|string|A valid language code, such as `en_US`. Must match one of the languages defined in the app ID configuration. | required |

### SLUEvent

The `SLUEvent` is a control event sent by the client in the `SLU.Stream` RPC.

{{< highlight "protocol buffer"  >}}
message SLUEvent {
    enum Event {
        START = 0; 
        STOP = 1; 
    }
    Event event = 1;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|enum|Event|Either START or STOP to start and stop the audio stream.|


### SLUResponse


{{< highlight "protocol buffer"  >}}

message SLUResponse {
    string audio_context = 1;  
    int32 segment_id = 2;
    oneof streaming_response {
        SLUTranscript transcript = 3;
        SLUEntity entity = 4;
        SLUIntent intent = 5;
        SLUSegmentEnd segment_end = 6;

        SLUTentativeTranscript tentative_transcript = 7;
        SLUTentativeEntities tentative_entities = 8;
        SLUIntent tentative_intent = 9;

        SLUStarted started = 10;
        SLUFinished finished = 11;
    }
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|audio_context|string|The identifier to match the server response to the audio context. 
|segment_id|int32|The identifier to match the server reponse to the segment context.
|streaming_response|oneof|One of nine possible streaming responses from the server.
|transcript|SLUTranscript|The final transcript of an utterance, once the segment is finished.
|entity|SLUEntity|The final entity of the segment.
|intent|SLUIntent|The final intent of the segment.
|tentative_transcript|SLUTentativeTranscript|The tentative transcript of the utterance. Sent continuosly while a segment is being processed. Subject to change.
|tentative_entities|SLUTentativeEntities|The tentative entities in the utterance. Sent continously while a segment is being processed. Subject to change.
|tentative_intent|SLUIntent|The tentative intent of a segment. Subject to change.
|started|SLUStarted|Sent when the server is ready to receive audio stream.
|finished|SLUFinished|Sent when the server has closed the audio stream.


Responses sent by the server in the `SLU.Stream` RPC when receiving audio stream. The stream always starts with `SLUStarted`, and either ends to an error or in `SLUFinished`. 

The actual responses are either tentative or final. The tentative responses are subject to change until finalized. They are discarded once the server has sent the final response.

### SLUTentativeTranscript

{{< highlight "protocol buffer"  >}}

message SLUTentativeTranscript {
    string tentative_transcript = 1;
    repeated SLUTranscript tentative_words = 2;
}

{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|tentative_transcript|string|The tentative transcript of the utterance. 
|tentative_words|SLUTranscript|The array of words in the transcript. 

The message sent by the server for the tentative transcript of the voice data before the SLU stream is finished either by an error or the client sending `SLUEvent.STOP`.

{{< info title="Tentative results can change" >}} The tentative results are subject to change until the SLU stream is finished. {{< /warning >}}


### SLUTentativeEntities

{{< highlight "protocol buffer"  >}}
message SLUTentativeEntities {
    repeated SLUEntity tentative_entities = 1;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|tentative_entities|SLUEntity|The array of entities in the transcript. 

The message sent by the server for the tentative entitites in an utterance.

{{< info title="Tentative results can change" >}} Tentative results are subject to change until the SLU stream is finished. {{< /warning >}}

### SLUEntity

{{< highlight "protocol buffer"  >}}

message SLUEntity {
    string entity = 1;
    string value = 2;
    int32 start_position = 3;
    int32 end_position = 4;
}

{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|tentative_transcript|string|An entity from the utterance. 
|value|string|The value of the entity.
|start_position|int32|The starting position of the entity in the transcript. Inclusive.
|end_position|int32|The ending position of the entity in the transcript. Exclusive. 

The message sent by the server for the final entity results. 


### SLUIntent

{{< highlight "protocol buffer"  >}}

message SLUIntent {
    string intent = 1;
}

{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|intent|string|The intent of the segment.  

The message sent by the server for the final intent results.

### SLUSegmentEnd 

{{< highlight "protocol buffer"  >}}

message SLUSegmentEnd {
}
{{</ highlight >}}


The message sent by the server at the end of a SLU segment.

### SLUStarted 

{{< highlight "protocol buffer"  >}}

message SLUStarted {
}

{{</ highlight >}}


The message sent by the server when the audio context is initialized. Once initialized, the server sends the `SluStarted` message, which contains the `audio_context` for matching the rest of the response messages to that specific utterance.

While processing the audio, the server sends `SLUTentativeEvents` messages continuously. 

### SLUFinished

{{< highlight "protocol buffer" >}}

message SLUFinished {
    // If the audio context finished with an error, then this field
    // contains a value.
    SLUError error = 2;
}

{{</ highlight >}}

The message sent by the server when the audio context is finished either by an error or the client sending `SLUEvent.STOP`. If the context is finished due to an error, the `SLUError` contains an error message. 

### SLUError

{{< highlight "protocol buffer" >}}

message SLUError {
    string code = 1; 
    string message = 2; 
}

{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|code|string|The error code.
|message|string|A human-readable error message.


## Example code 

### JavaScript

{{< highlight javascript >}}

const fs = require("fs");
const protoLoader = require("@grpc/proto-loader");
const grpc = require("grpc");
const wav = require("wav");

const appId = process.env.APP_ID;
if (appId === undefined) {
  throw new Error("APP_ID environment variable needs to be set");
}

let host = "api.speechgrinder.com";
let credentials = grpc.credentials.createSsl();

const SgGrpc = grpc.loadPackageDefinition(
  protoLoader.loadSync("../sg.proto", {
    keepCase: false,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true
  })
);

const login = (deviceId, appId) => {
  return new Promise((resolve, reject) => {
    const identity = new SgGrpc.speechgrinder.sgapi.v1.Identity(host, credentials);
    identity.login({ appId, deviceId }, (err, response) => {
      if (err) {
        return reject(err);
      }
      return resolve(response.token);
    });
  });
};

const start = slu => {
  const audio = new wav.Reader();

  slu.write({ config: { channels: 1, sampleRateHertz: 16000 } });
  slu.write({ event: { event: "START" } });

  audio.on("data", audioData => {
    if (slu.writable) {
      slu.write({ audio: audioData });
    }
  });
  slu.on("data", data => {
    console.dir(data, { depth: null });
  });
  audio.on("end", () => {
    slu.write({ event: { event: "STOP" } });
    slu.end();
  });
  fs.createReadStream("../audio.wav").pipe(audio);
};

Promise.resolve()
  .then(() => login("node-simple-test", appId))
  .catch(err => {
    console.error(err);
    process.exit();
  })
  .then(token => {
    const metadata = new grpc.Metadata();
    metadata.add("Authorization", `Bearer ${token}`);
    const client = new SgGrpc.speechgrinder.sgapi.v1.Slu(host, credentials);
    const slu = client.Stream(metadata);
    return start(slu);
  })
  .catch(err => {
    console.error(err);
  });

  {{</ highlight >}}

### Python

{{< highlight python >}}

import os
import wave
import uuid

import grpc

from speechly_pb2 import SLURequest, SLUConfig, SLUEvent, LoginRequest
from speechly_pb2_grpc import IdentityStub as IdentityService
from speechly_pb2_grpc import SLUStub as SLUService

chunk_size = 8000

def audio_iterator():
    yield SLURequest(config=SLUConfig(channels=1, sample_rate_hertz=16000))
    yield SLURequest(event=SLUEvent(event='START'))
    with wave.open('output.wav', mode='r') as audio_file:
        audio_bytes = audio_file.readframes(chunk_size)
        while audio_bytes:
            yield SLURequest(audio=audio_bytes)
            audio_bytes = audio_file.readframes(chunk_size)
    yield SLURequest(event=SLUEvent(event='STOP'))

with grpc.secure_channel('api.speechly.com', grpc.ssl_channel_credentials()) as channel:
    token = IdentityService(channel) \
        .Login(LoginRequest(device_id=str(uuid.uuid4()), app_id=os.environ['APP_ID'])) \
        .token

with grpc.secure_channel('api.speechly.com', grpc.ssl_channel_credentials()) as channel:
    slu = SLUService(channel)
    responses = slu.Stream(
        audio_iterator(),
        None,
        [('authorization', 'Bearer {}'.format(token))])
    for response in responses:
        print(response)

{{</ highlight >}}


# WLU service

The Speechly written language understanding service provides natural language understanding for written languages. It uses the same model as the `SLU` service; hence, it returns the same results for the same transcripts.

When a string is sent to the service, it returns with intents, entities, and transcripts for each segment as a response. The maximum size of a message is 16KB.

{{< highlight "protocol buffer" >}}
service WLU { 
    rpc Text(WLURequest) returns (WLUResponse) {}
}
{{</ highlight >}}

## Messages

### WLURequest

{{< highlight "protocol buffer" >}}

message WLURequest {
    string language_code = 1;
    string text = 2;
}

{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|language_code|string|A valid language for the model used in the application.  
|text|string|The text from which the intents, entities, and transcripts are extracted.

### WLUResponse

{{< highlight "protocol buffer" >}}

message WLUResponse {
    repeated WLUSegment segments = 1;
}

{{</ highlight >}}


|Name|Type|Description|
|---|---|---|
|segments|WLUSegment|Any number of segments extracted from a string sent to [`WLURequest`]({{< relref "api-reference.md#wlurequest" >}}).  

### WLUSegment

{{< highlight "protocol buffer" >}}

message WLUSegment {
    string text = 1;
    repeated WLUToken tokens = 2;
    repeated WLUEntity entities = 3;
    WLUIntent intent = 4;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|text|string|A segment extracted from [`WLURequest`]({{< relref "api-reference.md#wlurequest" >}}). 
|token|WLUToken|Any number of words extracted from the segment.  
|entities|WLUEntity|Any number of entities extracted from the segment.
|intent|WLUIntent|The intent of the segment. 

### WLUToken

{{< highlight "protocol buffer" >}}

message WLUToken {
    string word = 1;
    int32 index = 2;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|word|string|A word in a segment.  
|index|int32|The position of the word in the segment.  

### WLUEntity

{{< highlight "protocol buffer" >}}

message WLUEntity {
    string entity = 1;
    string value = 2;
    int32 start_position = 3;
    int32 end_position = 4;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|entity|string|An entity extracted from a segment.
|value|string|The value of the entity. 
|start_position|int32|The starting position of the word/words containing the entity and its value. Inclusive. 
|end_position|int32|The ending position of the word/words containing the entity and its value. Exclusive.

### WLUIntent 

{{< highlight "protocol buffer" >}}

message WLUIntent {
    string intent = 1;
}
{{</ highlight >}}

|Name|Type|Description|
|---|---|---|
|intent|string|The intent of a segment.

