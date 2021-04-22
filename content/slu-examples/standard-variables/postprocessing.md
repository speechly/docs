---
title: "Entity postprocessing"
description: "Speechly can post-process some entity values so that they are returned in a more structured format."
weight: 6
category: "User guide"
draft: True
menu:
  sidebar:
    title: "Entity postprocessing"
    parent: "Configuring Your Application"
---

`Data Types` determine what is done to an entity after it has been recognized. While the default Data Type `String` leaves the entities as they are recognized, the other Data Types, such as `Date` provide normalizations for the entities that make their further use easier. The Data Types are defined in the Speechly Dashboard when listing entities.

While the Standard Variables and Data Types can be used separately, the two features are best when combined. With the entity `departure` defined as `Date` in the example above, an utterance like "Book a flight for August ninth two thousand twenty" would be recognized, and the SLU API would return the recognition as:

~~~
intent: book
entity:
    name: "departure"
    value: "2020-08-09"
~~~

Now one neither has to make the effort to define how the dates look like nor determine how they map into a structured format.

