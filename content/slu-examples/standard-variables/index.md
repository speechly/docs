---
title: "Standard Variables"
description: "Standard Variables make it easier to use common expressions in your configuration without having to write everything from scratch yourself"
weight: 5
category: "User guide"
aliases: [/editing-nlu-examples/standard-variables/]
menu:
  sidebar:
    title: "Standard Variables"
    parent: "Configuring Your Application"
---

# Introduction

`Standard Variables` are building blocks that make supporting certain common but somewhat complex expressions easier in your configuration. While you could construct these same expressions yourself in SAL, our predefined standard variables let you focus more on the unique aspects of your application.

The Standard Variables look like and are used like normal [Variables](/slu-examples/cheat-sheet/#variables), but you don't have to define them in your configuration, because we've already done it for you. The Standard Variables can be identified by their names, which start with `SPEECHLY.`

You can see a standard variable being used in the example utterance below, which now permits various ways of expressing dates to be recognized by your application:
```
*book book a flight for $SPEECHLY.DATE(departure)
```
The above *Template* can expand for example to the following (just to name a few):
```
*book book a flight for january fifth twenty twenty one
*book book a flight for tomorrow
*book book a flight for second of november two thousand and twenty one
```

While Standard Variables can be used as such, if they appear as entity values, we also recommend assigning the entity in question the appropriate [Data Type](/slu-examples/postprocessing).



# Supported Standard Variables

| Standard Variable                 | Expands to                | Examples                                                 |
| --------------------------------- | ------------------------- | -------------------------------------------------------- |
|`$SPEECHLY.DATE`                   | Date expressions          | _tomorrow_, _next Friday_, _January fifth twenty twenty_ |
|`$SPEECHLY.TIME`                   | Time expressions          | _three thirty pm_, _quarter past eleven_, _fifteen twenty five_ |
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
|`$SPEECHLY.PHONE_NUMBER`           | Phone numbers             | _plus three five eight four zero one two three four five six_, _one two three four five six_ |
|`$SPEECHLY.PERSON_NAME`            | Person names              | _amelia m earhart_, _john smith_, _c o n a n o'brien |
|`$SPEECHLY.EMAIL_ADDRESS`          | Email addresses           | _hello at speechly dot com_, _john dot smith at company dot com_ |
|`$SPEECHLY.WEB_ADDRESS`            | Website addresses         | _w w w dot speechly dot com_, _h t t p s colon slash slash docs dot speechly dot com_ |
