---
title: "Entity Data Types"
description: "Speechly can post-process some entity values so that they are returned in a more structured format. This is done by assigning the entity to have an appropriate Data Type in the Dashboard."
weight: 6
category: "User guide"
menu:
  sidebar:
    title: "Entity Data Types"
    parent: "Configuring Your Application"
---
# Introduction
Unless otherwise specified, the entity values returned from the Speechly API are *verbatim what the user said*. If you have configured the template
```
*book book a flight for $SPEECHLY.DATE(departure)
```
and the user says "book a flight for july third twenty twenty one", without using a *Data Type* the API returns
```
intent: book
entity:
    name: "departure"
    value: "july third twenty twenty one"
```
However, if you explicitly designate the entity `departure` to have *Data Type* `Date` in the Dashboard, the API returns
```
intent: book
entity:
    name: "departure"
    value: "2021-07-03"
```
The `Data Type` of an entity thus determines what is done to the entity value after it has been recognized. While the default Data Type `String` returns the value verbatim, the other Data Types, such as `Date`, provide normalizations for the entities that make their further use easier. The Data Types are defined in the Speechly Dashboard when listing entities.

And while [Standard Variables](/slu-examples/standard-variables/) and Data Types can be used separately, the two features are best when combined.


# Entity Data Type Reference

Here are all Entity Data Types that we support, a brief description of what they do, and with what [Standard Variable](/slu-examples/standard-variables/) they are designed to work.

* `Date` — expressions that define a date are converted into ISO-8601 as a string (e.g., _January fifth twenty twenty_ → _2020-01-05_). Relative expressions like _tomorrow_ or _next Friday_ are parsed relative to the current date. If the year is missing from the expression, the current year will be used. Works together with the `$SPEECHLY.DATE` standard variable.

* `Time` - expressions that define a time of day are returned as a `hh:mm` formatted string using a 24-hour clock (e.g., _three thirty pm_ → _15:30_, _quarter past two in the morning_ → _02:15_, _twenty past nine pm_ → _21:20_). Works together with `$SPEECHLY.TIME`.

* `Number` normalizes all numeric utterances into digits (e.g., _five six four nine_ → _5649_, _seventeen point five_ → _17.5_, _three hundred thousand_ → _300000_, _three quarters_ → _0.75_). Works together with `$SPEECHLY.*_NUMBER` standard variables.

* `Identifier` should be used together with alphanumeric identifiers (sequences) that are spelled out one character at a time. Entities of this type are normalized into character sequences representing the identifier (e.g., _zero zero seven x_ → _007x_, _one two seven dot zero dot zero dot one slash x y_ → _127.0.0.1/xy_). Works together with `$SPEECHLY.IDENTIFIER*` standard variables.

* `Phone` is the recommended data type for expressions that are phone numbers. Entities with this type are formatted according to common conventions for writing telephone numbers (_plus four four two oh seven seven three oh one two three four_ → _+44 207 730 1234_). Works together with `$SPEECHLY.PHONE_NUMBER` standard variable.

* `Person Name` is a data type that should be used with entities that are person names. The returned entity value should in most cases have appropriate capitalization, and parts of the name that were spelled letter by letter should be combined to a single word (_c o n a n o'brien_ → _Conan O'Brien_). Works together with `$SPEECHLY.PERSON_NAME` standard variable.

* `Email` formats the returned entity value as an email address (_john dot smith at company dot com_ → _john.smith@company.com_, this data type also supports spelling parts of the entity: _a n t t i at speechly dot com_ → _antti@speechly.com_). Works together with `$SPEECHLY.EMAIL_ADDRESS` standard variable.

* `Website` formats the returned entity value as a website URL (_h t t p s colon slash slash docs dot speechly dot com_ → _https://docs.speechly.com_). Works together with `$SPEECHLY.WEB_ADDRESS` standard variable.
