---
author: lbrito1
comments: true
created_at: 2017-06-19
kind: article
title: "How a Unix CLI tool made me care about software feedback"
excerpt: "Providing feedback is one of the most important parts of any software. This is a tale of how the lack of proper feedback (and some laziness) almost cost me an entire HDD filled with personal data."
categories:
- Code
tags:
- Software Engineering
- Unix
---

Providing feedback is one of the most important parts of any software. Unfortunately, more often than not we tend to downplay or ignore the very simple yet crucial task of letting the user know what is going on. In this article I'll use a short cautionary tale of how the lack of proper user feedback (and some laziness, I admit) almost cost me an entire HDD with years of personal data.

<!-- more -->

It was late at night and I was trying to clean up an SD card with some vacation photos. However, a silly media-detection Ubuntu process had hanged at some point and locked down the card, impeding any write operations on it. So I did what any lazy developer would do at 1AM: hastily search StackOverflow and paste into the terminal the first possibly applicable code snippet. Albeit totally overkill, the answer was legit: zero-filling (writing `0`s in the disk, effectively deleting data) the device with the `dd` program. So I copy-pasted the command, hit Enter and waited — without properly understanding what I had just typed, I might add. The command seemed to take too long so I killed it after a few seconds. Much to my surprise, on reboot the OS wouldn't load.

The command I had copy-pasted from StackOverflow used `dev/sdb` as the destination device to be zero-filled, which must have been the original poster's SD card device name. Unfortunately for me, that was the name of my secondary HDD, while my SD card was probably something like `/dev/sdc`. The `dd` program had zero-filled the beginning of the HDD, which contains the partition table information, making it unmountable. After some tinkering around I removed the HDD entry from `/etc/fstab` and was able to boot into Ubuntu. After some research I found out the correct tools to restore the disk's partition table and everything was fine (except for the hours of sleep I lost on that day).

![Can you tell by the output of dd that the device will be completely and irrevocably wiped out? Hint: while the operation is running (i.e. before hitting CTRL+C), there _is no output._](/assets/images/goiabada/1*RUsq0P9vGjQQvjpsbov09g.jpeg)
Can you tell by the output of dd that the device will be completely and irrevocably wiped out? Hint: while the operation is running (i.e. before hitting CTRL+C), there _is no output._

The first and obvious lesson learned here is, of course, don't copy-paste and immediately run things from the Internet. It is potentially dangerous and just plain bad practice. The thing is, though, users will _always_ do something that is bad practice. Real-world users will find themselves tired and frustrated at 1AM, like myself, and will do stuff they're "not supposed to do". That is why feedback is so important: a simple confirmation dialog saying something like "this command will completely overwrite the destination file at device x, are you sure you want to continue?" might have made me think twice, and I might have saved a couple of hours of sleep.

> But you should know better! It is so obvious that `sudo dd if=/dev/zero of=/dev/sdb bs=512` will copy `0x00`s to the output file, `/dev/sdb`, which happens to be the address of your secondary HDD, and will thus erase all your data!

I totally should, and now that I am well-rested and have good hindsight on the subject it does feel like an embarrassingly naive mistake that I'd never want to write about on a blog post and share with my peers. But at the time I was unfamiliar with `dd`, and also tired and impatient. Users will often be tired, impatient or frustrated, and won't always know exactly what some command, button or link is intended to do on your software. Even extremely knowledgeable and competent people [will sometimes make almost unbelievable mistakes](https://twitter.com/gitlabstatus/status/826591961444384768): let's just call it human nature.

So the real lesson to be learned here isn't "scold your user for being stupid", but rather "make sure your software gives the user proper feedback". We can't change human nature, and people will always do something wrong for many different reasons. I am really not talking about anything complex, but just very basic, simple things: it costs nothing to add a confirmation dialog, a well-thought-of label or an informative modal to your software. As developers, we are constantly tempted to thinking that if the code works, then the feature is done; but the user might not even know that the feature is ready and working unless they have proper feedback.

Giving the user some feedback around critical sections of your software will go a long way. At worst, good feedback is harmless, and at best it will save someone from deleting their HDD.

By [Leonardo Brito](https://medium.com/@lbrito) on [June 19, 2017](https://medium.com/p/656f5fe3f6b8).

[Canonical link](https://medium.com/@lbrito/how-a-unix-cli-tool-made-me-care-about-software-feedback-656f5fe3f6b8)

Exported from [Medium](https://medium.com) on May 1, 2019.
