---
author: lbrito1
comments: true
created_at: 2017-03-20
kind: article
title: "Don't obsess over code DRYness"
excerpt: "Being clever is a good thing for a developer. Ingenuity allows us to write software that solves complex real-world problems. However, “clever” _code_ is not always a good thing."
categories:
- Code
tags:
- Ruby
- Software Engineering
---

Being clever is a good thing for a developer. Ingenuity allows us to write software that solves complex real-world problems. However, “clever” _code_ is not always a good thing. In many cases — I dare say in _most_ cases — it is a very bad thing. I consciously try to avoid writing code that might be seen as “clever”. The smart thing to do is trying hard not to be smart (yes, very [1984](http://literarydevices.net/war-is-peace/)).

Developers tend to see themselves (quite indulgently) as smart people. Not many people understand what we do, and society sees a developer as a kind of modern wizard, writing unreadable magic spells in a small metal box. In reality, though, we are not half as smart as we think: for instance, if you are a developer, you are certainly familiar with the frustration of trying to understand some cryptic piece of code that seemed perfectly reasonable and straightforward when you wrote it a couple of months earlier.

<!-- more -->

It is a given that any programmer will have to deal with the frustration of trying to understand complex code countless times throughout their career. Of course, there are genuine reasons to write complex code: sometimes there are strict hardware limitations, such as in the early ages of electronic computers, and sometimes the problem’s domain itself is inherently complex. However, if you’re reading this, you’re probably not [living in the 1940s and working on a hydrogen bomb](https://en.wikipedia.org/wiki/ENIAC#Role_in_the_hydrogen_bomb), and it’s more likely you’re working on some kind of web app using a dynamic programming language and a helpful framework, so you can probably take advantage of that and keep things simple.

Why, then, do we insist in writing unnecessarily complex and cryptic code when we don’t absolutely need to? As it turns out, there are many reasons (although very few of them are good): to impress your boss and coworkers, to feel smart or proud of yourself, to challenge yourself, or just out of boredom. Those are all very real reasons why people deliberately write complex code. But people also write complex code unintentionally, and while actually trying their best to do the opposite: this is what happens when a programmer misinterprets genuine programming guidelines and good practices.

A good example of this is the [Don’t Repeat Yourself (DRY)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) guideline, repeated as a mantra in some Computer Science classes and in the industry. As humans, we have the gift and tendency towards recognizing patterns — it is what allows us to recognize a familiar face, appreciate music and understand languages, just to name a few examples. We also recognize patterns in source code, which we refactor following the DRY principle.

The thing about pattern recognition, though, is that humans are very good at it — sometimes _too good_. This can easily lead to the overuse of an otherwise perfectly healthy programming guideline. Psychology has a term for pattern recognition overuse/misuse: [apophenia](https://en.wikipedia.org/wiki/Apophenia). It is what happens when you see a pattern that doesn’t really exist, like a gambler “identifying” patterns in lottery tickets or a programmer “identifying” patterns in source code which aren’t really there.

The original definition of DRY, from Hunt and Thomas’ _The Pragmatic Programmer_, states:

> “Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.”

A _piece_ of knowledge hints at a well-defined knowledge _unit_, which may vary in size depending on the specifics of your code. When a programmer sees a pattern in sections of code that do not belong to a common pattern — that is, are not within the same _piece of knowledge_ -, and still decides to refactor those sections by extracting them into a common piece of code, then _different_ _pieces_ of knowledge are being mashed together, and thus are DRY is not being applied at all.

Let’s use an example to illustrate a misuse of DRY. Suppose you’re working on a car dealership software. The dealership sells and services a single car model, offering 3 scheduled maintenances at 10, 30 and 50 thousand miles:

<div class="highlight"><pre><code class="language-ruby">
# Example 1
class Car
  include Checkups

  def maintenance_10k
    check_break_fluid
    check_battery_terminals
    check_engine_oil
  end

  def maintenance_30k
    check_break_fluid
    check_battery_terminals
    check_engine_oil
    check_spare_wheel
  end

  def maintenance_50k
    check_break_fluid
    check_battery_terminals
    check_engine_oil
    check_spare_wheel
    check_gearbox
  end
end
</code></pre></div>

At a first glance, you may be tempted to DRY the code by extracting the three methods which are called in all maintenances: `check_break_fluid`, `check_battery_terminals` and `check_engine_oil`. The resulting code is more concise:

<div class="highlight"><pre><code class="language-ruby">
# Example 2
class Car
  include Checkups

  def maintenance_10k
    basic_maintenance
  end

  def maintenance_30k
    basic_maintenance
    check_spare_wheel
  end

  def maintenance_50k
    basic_maintenance
    check_spare_wheel
    check_gearbox
  end

  private

  def basic_maintenance
    check_break_fluid
    check_battery_terminals
    check_engine_oil
  end
end
</code></pre></div>

DRYing produces this new basic\_maintenance method. It is not very descriptive: while `maintenance_*` methods convey exactly what it they are expected to do (i.e. “perform a 10, 30 or 50 thousand miles maintenance”), `basic_maintenance` is kind of an arbitrary name we made up that could mean anything. It is an abstract creation that exists only for our convenience and does not represent anything in the real world.

Let’s imagine a very simple change in the requirements: suppose we no longer need to check the break fluid on the 10 thousand miles checkup. Now we must decide between removing `check_break_fluid`from `basic_maintenance` and adding the check only to the 30k and 50k maintenances, thus reducing `basic_maintenance`'s effectiveness at avoiding repetition, or eliminating the method altogether and going back to how things were in Example #1.

Although Example #1 has more repetitions than Example #2, it is arguably more readable and descriptive. It is also less likely to break if there are changes in the requirements like we just described. Bear in mind that this is a very simple example: all the methods do is call other methods that don’t take any parameters; there is no argument passing, no state changes, no transformations, etc. A more complex example would increase even further the abstractness and complexity of DRYing the code.

A little repetition is preferable to a code that was DRYed incorrectly or excessively. If the abstraction resulting from DRY refactoring is more painful to understand than the alternative (going through a few repeated code sections), then the programmer was probably suffering of apophenia, seeing code patterns that did not exist — and thus not applying DRY correctly. Sandi Metz [summarizes this very clearly](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction) in her 2014 RailsConf talk:

> _“Prefer duplication over the wrong abstraction.”_

With that said, there is another acronym that complements DRY: [DAMP](https://codeshelter.wordpress.com/2011/04/07/dry-and-damp-principles-when-developing-and-unit-testing/). DAMP means _descriptive and meaningful phrases_. Although directed mostly at tests, the general principle of acknowledging the value of descriptiveness applies to all sorts of code_:_ good code is not too repetitious, but is also not too abstract and generic. Sometimes there is no general case to be abstracted, there are just a couple of concrete, specific cases which you should treat as concrete, specific cases.

The purpose of DRY, DAMP and all the other fancy programming principles is to guide us towards crafting better code. If the result of DRYing something is a code that is more complex and less maintainable, then we have defeated the purpose of DRY. Programming principles are not laws of nature that will guarantee better code, which means that they are not universally applicable. More than knowing how to cleverly refactor and DRY a code, it is important to know _when_ something should be DRYed and when it should be left alone.

By [Leonardo Brito](https://medium.com/@lbrito) on [March 20, 2017](https://medium.com/p/e9ecc5224ff).

[Canonical link](https://medium.com/@lbrito/dont-obsess-over-code-dryness-e9ecc5224ff)

Exported from [Medium](https://medium.com) on May 1, 2019.
