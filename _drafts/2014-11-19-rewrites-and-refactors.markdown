---
layout: post
title:  "Rewrites and Refactors"
date:   2014-11-19 16:24:40
categories: sysblog
---

I've started to read [Refactoring by Martin Fowler](http://martinfowler.com/books/refactoring.html), and it's inspiring.
The book starts out with an example of a small project that has theoretically overgrown its original implementation and
must be refactored. The thing is, I've got a project that's perfect to perfect my refactoring-foo (okay, I'll be honest, 
I've never actually undertaken a refactoring project). My Java City Generator, cleverly named 
["citygen"](https://github.com/wolfd/citygen), was written in a time where I really didn't understand programming, 
much less OOP or version control.

The code is ugly, it has commented out code blocks everywhere, [it's barely documented](http://youtu.be/lKXe3HUG2l4?t=10m28s), 
and is mostly procedural. It looks and feels a lot like legacy code that I've had the opportunity to work on.

It's bad. But it's not so bad that it's impossible to refactor, which is why I'm going to refactor it.

If you've been watching my github for a year or so 
(if you do watch my github, you are statistically also likely to parse /robots.txt), you may notice that I have a 
repository called "citigen", which was my short-lived attempt to rewrite the city generator from scratch.

## Rewrites are hard, and refactors are harder.
but wait.

Every programmer, sometime in their career, thinks something like this:

> "Holy hell, this code is awful."

which leads to

> "I should just rewrite it."

And maybe they succeed. I have; the citygen repository you see today is a complete rewrite of an older city generator
I wrote. And that city generator was in turn a rewrite of another city generator I wrote.

{% include image.html url="/assets/rewrites-and-refactors/citygen-1.jpg" description="my first city generator, written in one Lua file at the end of 2010" %}

{% include image.html url="/assets/rewrites-and-refactors/citygen-2.jpg" description="the second city generator, now in Java (2011)" %}

It was when I started realizing that my second generation of city generator was starting to cause me immense pain that I
decided to trash it all, and start writing the third generation. What a good idea! In a few weeks time, I had the 
functionality of the second generator without the bugs, and it was beautiful.

{% include image.html url="/assets/rewrites-and-refactors/citygen-3.jpg" description="the third city generator, now in 3D (May 2012)" %}

Then I think college applications were a thing. The next time I touched the project was at the beginning of 2014, when I
created a new repository and said to myself, "I'm going to do this right this time." I quickly forgot about the project,
and didn't think about it until a few days ago when I picked up "Refactoring".

[But rewrites can fail, and they do](http://programmers.stackexchange.com/questions/141754/are-there-any-actual-case-studies-on-rewrites-of-software-success-failure-rates), and everyone is scared of them.

Management hates rewrites. And they have reason to hate rewrites. 
[Rewrites are bad](http://onstartups.com/tabid/3339/bid/2596/Why-You-Should-Almost-Never-Rewrite-Your-Software.aspx)
and
[kill companies](http://steveblank.com/2011/01/25/startup-suicide-%E2%80%93-rewriting-the-code/). The bigger a project
gets, the more the programmers working on it will hate it, and the more push there will be to convince management to
dedicate time to rewriting it. And managment has been trained to say "no". Managment has been trained to say "no",
because they've learned that the company has survived this long without anything disasterous happening, and therefore
the developers are full of shit, and should just continue developing features.

## The sandbox
My city generator is a sandbox, it's all mine, and I can do whatever I want with it and no one can tell me not to.
I have no customers or clients, and I don't need to worry about breaking outward-facing APIs or making anyone mad, which is
exactly why I chose to rewrite it three times. Whenever I felt that my velocity was impeded by my code, I abandoned it.

You see, rewriting code is the easiest decision to make. You immediately feel relieved that you aren't working on that
crap that you just wrote, because you're smarter now! You know how to write maintainable code! You're going to do it
the right way now!

But, rewriting code is often the worst decision to make. The scale of how bad that decision is lines up pretty well with
the magnitude of the codebase. Additionally, the urge to rewrite code lines up pretty well with the size of the codebase.

Some of the time, it works, like it has for me two times out of three. But other times, you're out of luck.

## It's time for me (and you) to learn how to refactor.

I find myself trying to do too many things all the time. Maybe you noticed that this post is rambling on about a dozen
things that are somewhat related, and there's no end in sight. That's how my brain works, by default, I jump from topic
to topic and never find myself working on a single thing.

I'm trying to condition myself though, trying to work on one thing at a time. I'm being more careful with my commits,
attempting to solve one issue at a time, instead of everything that I see. I think a number of programmers have the same
problems I have, and I think that this failure to discipline oneself is why rewrites don't work.

Rewrites fail because the point of them is to change everything: behavior, implementation, language, etc. 
The wide scope of a rewrite is inherently wrong, because humans flounder when there's too much to be done.

In a refactor, the programmer has one task at a time; changing one part of an application without affecting the overall 
behavior. If the developer does the process correctly, the program will operate in the exact same way. That's rather
unexciting. Why not improve the behavior while you're at it? You see, if I make a change here and a change there...

And then your refactoring project begins to suffer from the problems a rewrite has and dies.

So, when you find yourself hating the code you are working on, don't argue for a rewrite, argue for a refactor.

TL;DR: I have no idea what I'm talking about.