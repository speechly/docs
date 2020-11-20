---
title: "Standard Variables and Data Types"
description: "Standard Variables make recognizing common expressions and Data Types easy by parsing them to a normalized format."
weight: 3
category: "User guide"
aliases: [/editing-nlu-examples/standard-variables/]
menu:
  sidebar:
    title: "Standard Variables and Data Types"
    weight: 3
    parent: "Configuring Your Application"
---

## Introduction

{{< info title="Learn more" >}} This part of the documentation expands on what we've previously written about models, intents, and entities. The best way to start learning Speechly is by completing the [Quick Start](/quick-start). You might want to learn about the [SLU basics](/slu-examples/) too.{{< /info >}}

The Speechly SLU applications are built by specifying a set of example utterances for which we use our Speechly Annotation Language (SAL). The example utterances should, as accurately as possible, reflect what your users might say to your application. Your examples are then fed as training data to a fairly complex machine learning system, which takes care of building all the bits and pieces required for a computer to understand human speech.

`Standard Variables` are building blocks that make supporting certain common but somewhat complex expressions in the Speechly SLU applications easier. While you could construct these same expressions yourself with the SAL, our predefined standard types let you focus more on the unique aspects of your application. The Standard Variables look like and are used like normal variables, but you don't have to define them in your configuration, because we've already done it for you. The Standard Variables can be identified by their names, which start with `SPEECHLY.` You can see a standard variable being used in the example utterance below, which now permits various ways of expressing dates to be recognized, without having to define them individually.

~~~
*book book a flight for $SPEECHLY.DATE(departure)
~~~

`Data Types` determine what is done to an entity after it has been recognized. While the default Data Type `String` leaves the entities as they are recognized, the other Data Types, such as `Date` provide normalizations for the entities that make their further use easier. The Data Types are defined in the Speechly Dashboard when listing entities.

While the Standard Variables and Data Types can be used separately, the two features are best when combined. With the entity `departure` defined as `Date` in the example above, an utterance like "Book a flight for August ninth two thousand twenty" would be recognized, and the SLU API would return the recognition as:

~~~
intent: book
entity:
    name: "departure"
    value: "2020-08-09"
~~~

Now one neither has to make the effort to define how the dates look like nor determine how they map into a structured format.


### Supported Standard Variables and the corresponding Data Types

| Standard Variable                 | Recognizes                | Examples                                                 |
| --------------------------------- | ------------------------- | -------------------------------------------------------- |
|`$SPEECHLY.DATE`                   | Arbitrary dates           | _tomorrow_, _next Friday_, _January fifth twenty twenty_ |
|`$SPEECHLY.NUMBER`                 | Arbitrary numbers         | _five million five hundred twenty-eight thousand eight point twelve_, _minus zero point zero five_, _eleven thousand_ | 
|`$SPEECHLY.CARDINAL_NUMBER`        | Arbitrary cardinals       | _five million five hundred twenty-eight thousand eight_, _minus three_, _eleven hundred eleven_       |
|`$SPEECHLY.SMALL_NUMBER`           | Small numbers             | _seventeen point five_, _minus five_ |
|`$SPEECHLY.SMALL_CARDINAL_NUMBER`  | Small cardinal numbers    | _seventeen_, _minus five_, _ninety-five_ |
|`$SPEECHLY.FOUR_DIGIT_NUMBER`      | Four digit numbers        | _five six four nine_, _one nine eight four_ |
|`$SPEECHLY.POSITIVE_NUMBER`        | Positive numbers          | _eleven hundred eleven_, _seventeen_, _five million five hundred_ |
|`$SPEECHLY.NEGATIVE_NUMBER`        | Negative numbers          | _minus five_, _negative twenty-four_
|`$SPEECHLY.SMALL_ORDINAL_NUMBER`   | Ordinal numbers 1-31      | _first_, _second_, _thirty-first_
|`$SPEECHLY.IDENTIFIER_SHORT`       | 1-4 character identifier  | _zero zero seven x_, _alpha dash one_, _two seven_ |
|`$SPEECHLY.IDENTIFIER_MEDIUM`      | 5-8 character identifier  | _a b one two dash nine x_, _delta foxtrot five seven dash two_ |
|`$SPEECHLY.IDENTIFIER_LONG`        | 9-12 character identifier | _one two seven dot zero dot zero dot one slash x y_ |
|`$SPEECHLY.IDENTIFIER`             | 1-12 character identifier | _two seven_, _one two seven dot zero dot zero dot one slash x y_ |

Data Types

* `Date` — expressions that define a date are converted into ISO-8601 as a string (e.g., _January fifth twenty twenty_ → _2020-01-05_). Relative expressions like _tomorrow_ or _next Friday_ are parsed relative to the current date. If the year is missing from the expression, the current year will be used.

* `Number` normalizes all the number Standard Variables into digits (e.g., _five six four nine_ → _5649_, _seventeen point five_ → _17.5_, _three hundred thousand_ → _300000_, _three quarters_ → _0.75_).

* `Identifier` should be used together with alphanumeric identifiers (sequences) that are spelled out one character at a time. Entities of this type are normalized into character sequences representing the identifier (e.g., _zero zero seven x_ → _007x_, _one two seven dot zero dot zero dot one slash x y_ → _127.0.0.1/xy_).


### Dates

In many applications, you need to use dates and concepts such as *tomorrow* or *today*. While, theoretically, you could provide the model with thousands of examples of how the users may refer to certain times, there's a simpler way.

If you use the Standard Variable `$SPEECHLY.DATE`, the model automatically understands dates and relative constructs that can be mapped into a certain date or month:

* _today_
* _tomorrow_
* _day after tomorrow_
* _next Friday_
* _next January_

This allows the end-users to use any sensible way of referring to dates such as, _July the fifth twenty-twenty_ or _fifth of July_.

When you also define the Data Type on the Speechly Dashboard as *Date*, the resulting entity is parsed as ISO-8601 — in the form of a date string (e.g., _2020-07-05_).

Of course, it's not always sensible to have all dates available in all applications. If your application supports a limited range of date expressions, you might want to add a set of examples in your configuration instead, like:

```
weekdays = [monday|tuesday|wednesday|thursday|friday]
*scheduling next week only $weekdays(available) is okay
*scheduling next week only $weekdays(available) [and|or] $weekdays(available) are okay
```

### Numbers

Often SLU applications need to understand numbers, and thus Speechly supports several Standard Variables for recognizing them. In addition, the Speechly Annotation Language has the number range syntax `amount = [1..20]` (explained [here](/slu-examples/editing-slu-examples/)) for defining custom number ranges easily.

* `$SPEECHLY.NUMBER` is the most general of the number variables. It aims to support the widest range of numbers, for example, _five million five hundred twenty-eight thousand eight_, _minus zero point zero five_, and _eleven hundred point sixteen_. 

* `$SPEECHLY.CARDINAL_NUMBER` is otherwise similar in scope, but it does not support decimals or fractions.
`$SPEECHLY.POSITIVE_NUMBER` and `$SPEECHLY.NEGATIVE_NUMBER` are subsets of `$SPEECHLY.CARDINAL_NUMBER` but strictly either positive or negative.

* `$SPEECHLY.SMALL_NUMBER` recognizes small numbers, for example, _seventeen point five_ and _minus five_, and it is optimized for number expressions smaller than two hundred. `$SPEECHLY.SMALL_CARDINAL_NUMBER` is otherwise similar in scope, but it does not support decimals or fractions.

* `$SPEECHLY.FOUR_DIGIT_NUMBER` recognizes numbers that consist of four digits, for example, _five six four nine_.

* `$SPEECHLY.SMALL_ORDINAL_NUMBER` recognizes ordinal numbers from 1 to 31, for example, "fifth" in _fifth floor_.

For the best results, you should choose the most specific Standard Variable for your use case.

All of these Standard Variables can be used with the Data Type `Number`, which parses the recognized expression as a string consisting of digits. For example, _zero zero three five_ would be parsed as _0035_, _nineteen_ as _19_, _seventeen point five_ as _17.5_, and _three hundred thousand_ as _300000_.


### Alphanumeric identifiers

The value of some entities, such as license plates or product codes, can be in the form of a mixed sequence of letters, digits, and special characters. Speechly provides three Standard Variables that can be used to represent such identifiers. These are:

* `$SPEECHLY.IDENTIFIER_SHORT` (for sequences of 1-4 characters)
* `$SPEECHLY.IDENTIFIER_MEDIUM` (for sequences of 5-8 characters)
* `$SPEECHLY.IDENTIFIER_LONG` (for sequences of 9-12 characters)

In addition to letters and digits, these sequences may contain the following symbols: `#` (_hash_), `/` (_slash_), `-` (_dash_), `.` (_point_), and `,` (_comma_).

These variables should be used with the Data Type `Identifier`.
```
*add_product add $SPEECHLY.SMALL_NUMBER(amount) units of $SPEECHLY.IDENTIFIER_MEDIUM(product_id)
```
The example utterance above — with the entity `amount` defined as the Data Type `Number`, and the entity `product_id` as the Data Type `Identifier` — would recognize the utterance _"Add five units of a b one two three slash x,"_ and parse `amount` with the value of `5` and `product_id` with the value of `AB123/X`.

Should your configuration include identifiers that are more than 12 characters in length, you can combine any of the abovementioned Standard Variables in the following fashion:
```
my_super_long_identifier = $SPEECHLY.IDENTIFIER_LONG $SPEECHLY.IDENTIFIER_LONG
```
Now, `my_super_long_identifier` supports identifiers that are up to 24 characters in length. However, do keep in mind that spelling out very long character sequences might not be that easy for your users.

Also, it is good to be aware that some letters and digits are phonetically very close to one another. For example, the letters `A` and `H` can be easily confused with the digit `8`. To help avoid such problems, the Standard Variables that represent identifiers also have support for the International Radiotelephony Spelling Alphabet (also known as the [NATO phonetic alphabet](https://en.wikipedia.org/wiki/NATO_phonetic_alphabet)): _Alfa, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliett, Kilo, Lima, Mike, November, Oscar, Papa, Quebec, Romeo, Sierra, Tango, Uniform, Victor, Whiskey, X-ray, Yankee,_ and _Zulu_. Thereby, an identifier uttered using the NATO phonetic alphabet, for instance, _"charlie delta echo bravo one point five,"_ would thus be parsed as _CDEB1.5_.
