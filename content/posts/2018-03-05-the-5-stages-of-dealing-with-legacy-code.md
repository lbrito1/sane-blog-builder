---
author: lbrito1
comments: true
created_at: 2018-03-05
kind: article
title: "The 5 stages of dealing with legacy code"
excerpt: "Working on a legacy project sometimes feels like a journey through grief. It kind of is, but not really: there's always something important we can learn in the process."
categories:
- Engineering
tags:
- Legacy code
---

Yes, this article will use the [5 stages of grief](https://en.wikipedia.org/wiki/K%C3%BCbler-Ross_model) as an analogy for something software development-related. There are at least a few thousand other articles with a similar motif (424,000 results for "grief stages software" according to [Google](https://www.google.es/search?q=grief+stages+software&oq=grief+stages+software)). But bear with me for the next 5 minutes and I promise you'll get something out of this — if nothing else, at least the smirk of those who read their past follies put on text by someone else.

I have been working on a rather big Rails project for the past year and half. The project is nearly 7 years old, and has an all-too-common successful-startup-bought-by-industry-giant background story. In a project with this kind of background, some things are bound to happen: many developers of many skill ranges have come and gone, many software fads (cough, Meteor, cough), and above all else _a lot_ of legacy code that is, well, let's put it nicely, _not so great_. None of this should be taken personally in any way — it is just natural for such things to occur in such projects.

<!-- more -->

These kinds of projects might be a bit unwelcoming and overwhelming to newcomers. In particular, the aforementioned _not so great_ legacy code might become a huge source of distress for the developer. Some degree of unpleasantness is probably unavoidable in any real-world software project, but choosing to deal with _not so great_ code in a productive, edifying way definitively helps to alleviate the potential nastinesses of working on legacy projects.

Let us begin our analogy. The backstory is that you, dear reader, are assigned to work on a monolithic web app which is company X's flagship product. It has been live for 5+ years and has thousands of customers. Three dozen developers have helped build the app over the years. The monolith uses a certain web framework since one of its earliest versions, and the team has haphazardly updated it to the latest stable version every once in a while. Leftovers are everywhere, and you have no clue if something is mission-critical code or just the remains of a failed, forgotten or otherwise removed feature or experiment. You are dumbstruck at the gigantic code-spaghetti and say to yourself:

## Nope, this can’t be right. I’m just going to ignore it and it’ll go away.

> This code is just so terrible, confusing or complex. I just can’t fathom any of it. It just can’t be right. It surely wasn't meant for a human being to understand. I'm going to ignore it for a while so it can go away and get replaced by something nice and shiny.

You're in **Denial**. Take all the time you want — by the end of the day, the same code will still remain committed. Instead of ignoring it, take a deep breath and spend a couple of hours reading and trying to understand it. This is easier said than done for many reasons: the domain of your software might be complex, and thus the code might be as well; the code might be excessively complex or over-engineered; your employer might not be so keen of waiting for you to grasp the intricacies of some small code section; you might feel bad for not delivering the same performance you had on the last project/feature, when you were right up there in the productivity plateau and so on. Alas, the problem remains: at some point you will have to grasp the meaning of that code, even though it is pretty terrible.

Time, patience and an understanding employer are the only things you need to get through. It also helps to have a senior coworker in this project that can guide you through the process. After some time you will begin to understand the codebase. You might start thinking that:

## I hate this.

> Ugh, _now_ I get it. Now I can see how the code is badly written, so underoptimized, naive or otherwise **plain wrong**. What on Earth were they _thinking_? This statement is so non-idiomatic it seems like another programming language; this query is so unnecessarily slow that I could go for a walk while the DB toils away; this Javascript is so ugly it could be used as a your-mom joke; …

**Anger** is what follows when you finally get just how bad the code really is. I don't know if everything happens for a reason, but I believe every line of code exists for a reason — bad code included. [Very rarely](https://softwareengineering.stackexchange.com/questions/7530/how-do-you-deal-with-intentionally-bad-code) it is the case that a developer knowingly chose to make a bad decision. More often:

The developer might have been inexperienced, tired or overworked. The idiom of your programming language might have changed. The specifications might have changed mid-development. The libraries that are mature and well-known today might have not even existed. So much could have happened that explains why the code is the way it is.

It is fine to try to understand the reason something is written the way it is, but try to resist the urge of blaming someone out of anger over the wretchedness of their code (you might find yourself in their shoes some day!). Once you decide not to `git blame`all the time, you might start avoiding the elephant in the room:

## I’m just going to write this new feature and everything will be fine.

> I know the old code exists, but I'm just going to pretend it doesn't for a while. I don't want to deal with this right now. Besides, I don't even know where to start, or whether I should start at all… is refactoring worth the trouble? Is it even possible?

If you have the luxury of picking your own assignments, then it might be tempting to do some **bargaining** and just ignore the bad legacy code for a while, promising to refactor some of it later— which is totally fine. At least for some time. But the problem never solves itself, and delaying improvements might have some nasty long term consequences. Once you start working around the limitations of bad code instead of addressing its problems, you are actually contributing to its evil legacy by creating more unwanted dependencies, more nonsensical interfaces, more unnecessarily complex methods, etc.

But you can't avoid the smelly code forever. One of these days, your boss will assign you to a certain issue…


## I've been assigned to solve this issue which relates to some nasty old code and I'm miserable.

> I can't believe I've been assigned to improve this legacy stuff — I've successfully avoided it for months now! This just _sucks_.

You knew what was coming towards your plate for some time, but now that it's finally here, you're suddenly **depressed**. That's fine too, but don't fall into self-pity: having to deal with bad code might greatly benefit your knowledge as a software developer. Think of it as _having room for improvement._ Which nicely leads us to…

## Hmmm, maybe I can improve things…

> Wait a minute, I think I know how to improve this…

This is the a-ha! moment. You **accept** the reality of legacy code, and instead of mulling over how bad it is, you realize that those columns — or tables — are useless, that those dependencies are no longer used, that there are many methods that are now superfluous, and so on. The tipping point here is when you gain enough knowledge of the codebase to start systematically questioning why the code is the way it is — and not just assuming that it is right, or that all of it is necessary.

This last stage of legacy code grief takes, of course, the most time to arrive. In my case it started arriving many months into the project, when I found out a few ways to optimize our spec suite which [resulted in a 41% speedup in CI execution](https://goiabada.blog/improving-spec-speed-in-a-huge-old-rails-app-8f3ab05a33f9). As time passes and I understand the project more deeply, new ideas of how to optimize or otherwise improve some part of it start popping up more naturally. Eventually you reach a point in which you can see bad code more as an opportunity to improve something (and maybe learn something new in the process) or even try out different solutions or technologies rather than a huge grief you have to deal with as a part of your day job.

## It's all part of the process

Working on a legacy project might not be as exciting as building a shiny new software from scratch, but it has its own merits. Unlike working on something new, on a legacy project you will need to understand how _other people_ solved some problem — which includes understanding all the limitations they might have had at that time. It is also a humbling experience: the bright glow of hindsight exposes all the scars of bad programming and bad decisions made in the past, and if you're being honest with yourself you'll have no other option than to admit that _it could have been you_.

By [Leonardo Brito](https://medium.com/@lbrito) on [March 5, 2018](https://medium.com/p/6d578205beeb).

[Canonical link](https://medium.com/@lbrito/the-5-stages-of-dealing-with-legacy-code-6d578205beeb)

Exported from [Medium](https://medium.com) on May 1, 2019.
