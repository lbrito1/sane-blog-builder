---
author: lbrito1
comments: true
created_at: 2018-09-03
kind: article
title: "10 ways not to do a big deploy"
excerpt: "Ideally, deploys should be small, concise and easily revertible. However, sometimes everything just goes kaput. Let's take a look on just how miserable a deploy can get."
categories:
- Engineering
tags:
- Devops
---

Ideally, deploys should be small, concise, easily revertible, fast and with a small or nil footprint on the database. However, no matter how awesome you are, sometimes that is just unattainable and you end up needing to deploy something that is just the opposite: big, messy, hard to revert, painfully slow and rubbing the DB the wrong way. If the deploy messes with a mission-critical part of your software, all the worse for you.

But there are actually many ways you can make those situations even worse. Here are a few bullet points you can follow to guarantee a nightmarish deploy complete with nasty side-effects that will haunt you and your coworkers for days to come.

<!-- more -->

## 1\. Don't make a plan

Plans suck. They take time and effort, and don't add any new features to your software. Planning a deploy requires thinking carefully about what it should do and, more importantly, what it shouldn't do (but potentially could). A good deploy plan is a step-by-step happy path that is written clearly and concisely, followed by a list of everything nasty that can happen. Making a deploy plan is basically trying to cover as many blind spots as you can before pulling the trigger. But, of course, you and your team are code ninjas or master software crafters or whatever the hippest term is nowadays, and you don't need a plan! Just wing it. Press the button and solve every problem that might arise in an ad-hoc fashion. What could go wrong?

## 2\. Don't schedule downtime

Downtime sucks: it usually is in odd hours, late in the night or early in the morning, when customers are fast asleep (and you would very much like to be as well). Why bother blocking public access and redirecting customers to a nice "scheduled maintenance page"? Why gift you and your team with peace of mind and a clear timeframe to work with if you can feel the rush of breaking stuff in production with live customers? Production debugging is the best kind of debugging! Confuse your customers with inconsistent states and leave them waiting while your team tries to fix those bugs that were definitively fixed last Friday night.

## 3\. Don't have a great log system

Logs are for buggy software, you won't need them. Why spend time and possibly money with a great logging-as-a-service (LaaS) platform? Just have your whole team `ssh` into production and watch the log tails. Or, even better, use a terrible LaaS that is slow, unreliable and has a confusing user interface so everyone can get frustrated trying to find errors during the deploy.

## 4\. Don't have a bug tracker

See above: just like logs, bug trackers are also lame. Your awesome PR won't have any bugs, now, will it? Regressions never happen under your watch. Also, who needs to track exceptions with a great, fast, reliable bug tracking platform when you have logs available? Aren't you hacker enough to `grep` every single exception that might be raised?

## 5\. Don't have a staging server

Staging servers are a waste of resources, both time and money. What is the point of having a close-to-exact copy of your production servers, which by this point are radically different from your development environment? Sure, containerization already _kind of_ abstracts many of those differences, but (hopefully) you have network settings, 3rd-party APIs and other stuff that aren't the same in development, even with containers. So be bold and make the leap from development right to production!

## 6\. Don't check your env vars

Your project only has like 80 different access tokens, API keys, DB credentials and cache store credentials spread over half a dozen YAMLs. Super easy to keep track of and super hard to mess up with your production, development and (hopefully) staging environments. Don't triple-check the variables that might have been changed in the deploy, and you'll secure a few hours of painful debugging in the near future.

## 7\. Don't guarantee data consistency post-deploy

In a previous step you were told already to make sure that customers can keep using your software mid-deploy, so we're halfway there already to guaranteeing poor data consistency. Make sure you haven't mapped out all the points your new code might touch the DB, particularly the DB structure itself. If anything goes wrong, just revert the commit and rollback — don't ever worry about becoming orphaned or inconsistent.

## 8\. Don't prepare for a late rollback

If everything else fails… wait, it won't! Some problems can surface during the deploy, sure, but we won't need to rollback _after_ it is done, right? Right? After everything is settled, and you made a plan (which you totally shouldn't, remember?) and followed it step-by-step, and all went well, you shouldn't need to rollback. But let's say it happens, and a few hours (or days) after the deploy you need to go back to the previous commit/tag/whatever you use. New data will have flowed which might need to be manually converted back to something manageable by the previous version of your software. Don't think about it, don't plan for it — it isn't likely to happen. And if it does, you will have a heck of a time working on oddball and edge cases late in the night. What is not to love?

## 9\. Don't communicate efficiently with your team

You already know you should have terrible log and error tracking systems. Add insult to injury and don't talk to your coworkers in a quick, direct and clear way. Long pauses are great for dramatic effect, especially when your coworkers are waiting for a timely answer. Be vague about what you're doing. Hit the rollback button and "forget" to tell people about it. In general, just be as confusing and unavailable as possible.

Following all of the points above might lead to a "perfect storm" situation, and making sure you don't follow them will surely make things easier on you and your team. But even if you have great deploy practices in place, sometimes things just fall apart. There will always be blind spots, and it is in their nature to be more or less unpredictable. That is just the way things are with software development. Which leads us to our 10th and final point in this guide to terrible deploys:

## 10\. Don't be patient and understanding with your coworkers if everything falls apart!

By [Leonardo Brito](https://medium.com/@lbrito) on [September 3, 2018](https://medium.com/p/f536d1ad9a5a).

[Canonical link](https://medium.com/@lbrito/10-ways-not-to-do-a-big-deploy-f536d1ad9a5a)

Exported from [Medium](https://medium.com) on May 1, 2019.
