---
layout: post
title:  "Rewrites and Refactors"
date:   2014-11-19 16:24:40
categories: sysblog
---

I've started to read [Refactoring by Martin Fowler](http://martinfowler.com/books/refactoring.html), and it's inspiring.
The book starts out with an example of a small project that has theoretically overgrown its original implementation and
must be refactored. The thing is, I've got a project that is in the same state. My Java City Generator, cleverly named 
"[citygen](https://github.com/wolfd/citygen)", was written in a time where I really didn't understand programming, 
much less OOP or version control.

The code is ugly, it has commented out code blocks everywhere, 
[it's barely documented](http://youtu.be/lKXe3HUG2l4?t=10m28s), and is mostly procedural. It looks and feels a lot like 
legacy code that I've had the opportunity to work on.

And it's my third try. Over the past four years, I've thrown out everything in hopes that -- this time -- this time I'll
do it right.

I had the thought that every programmer has sometime in their career:

> "Holy hell, this code is awful."

which leads to

> "I should just rewrite it."

## Rewrite heaven.

This has worked pretty well for me so far. The citygen repository you see today is a complete rewrite of an older city 
generator I wrote. And that city generator was in turn a rewrite of another city generator I wrote.

{% include image.html url="/assets/rewrites-and-refactors/citygen-1.jpg" description="my first city generator, written in one Lua file. (Dec 2010)" %}

{% include image.html url="/assets/rewrites-and-refactors/citygen-2.jpg" description="the second city generator, now in Java (2011)" %}

It was when I started realizing that my second generation of city generator was starting to cause me immense pain that I
decided to trash it all, and start writing the third generation. What a good idea! In a few weeks time, I had the 
functionality of the second generator without the bugs, and it was beautiful. And then I started developing features,
and with features comes complexity, and with complexity comes ugliness.

{% include image.html url="/assets/rewrites-and-refactors/citygen-3.jpg" description="the third city generator, now in 3D (May 2012)" %}

Then I think college applications were a thing. The next time I touched the project was at the beginning of 2014, when I
created a new repository and said to myself, "I'm going to do this right this time." I quickly forgot about the project,
and didn't think about it until a few days ago when I picked up "Refactoring".

## I live in a land of unicorns and happiness.

My city generator is a sandbox, it's all mine, and I can do whatever I want with it and no one can tell me not to.
I have no customers or clients, and I don't need to worry about breaking outward-facing APIs or making anyone mad, which 
is exactly why I chose to rewrite it three times. Whenever I felt that my velocity was impeded by my code, I abandoned 
it.

## The sad truth.

[Rewrites can fail, and they do](http://programmers.stackexchange.com/questions/141754/are-there-any-actual-case-studies-on-rewrites-of-software-success-failure-rates), and everyone is scared of them. Management hates rewrites, and they have reason to 
do so.
[Rewrites are bad](http://onstartups.com/tabid/3339/bid/2596/Why-You-Should-Almost-Never-Rewrite-Your-Software.aspx)
and
[kill companies](http://steveblank.com/2011/01/25/startup-suicide-%E2%80%93-rewriting-the-code/). The bigger a project
gets, the more the programmers working on it will hate it, and the more push there will be to convince management to
dedicate time to rewriting it. And managment has been trained to say "no" because they've learned that the company has 
survived this long without anything disasterous happening, and therefore the developers are full of shit, and should 
just continue developing features.

## Rewrites are easy, and refactors are hard.

Rewriting code is the easiest decision to make. You immediately feel relieved that you aren't working on that
crap that you just wrote, because you're smarter now! You know how to write maintainable code! You're going to do it
the right way now! You know how to lie to yourself!

Rewriting code is often the worst decision to make. The scale of how bad that decision is lines up pretty well with
the magnitude of the codebase. 

{% include image.html url="/assets/rewrites-and-refactors/code-amount-vs-bad-idea.png" description="super scientific graph" %}

Additionally, the urge to rewrite code lines up pretty well with the size of the codebase. This is the natural 
progression of a codebase. This is why monoliths are broken up into parts. This is why you refactor.

## It's time for me (and you) to learn how to refactor.

I find myself trying to do too many things all the time. That's how my brain works, by default, I jump from topic
to topic and find myself working on everything at once and therefore nothing.

I'm trying to condition myself though, trying to work on one thing at a time. I'm being more careful with my commits,
attempting to solve one issue at a time, instead of everything that I see. I think a number of programmers have the same
problems I have, and I think that this failure to discipline oneself is why rewrites don't work.

Rewrites fail because the point of them is to change everything: behavior, implementation, language, etc. 
The wide scope of a rewrite is inherently wrong, because humans flounder when there's too much to be done.

In a refactor, the programmer has one task at a time; changing one part of an application without affecting the overall 
behavior. If the developer does the process correctly, the program will operate in the exact same way. That's rather
unexciting, which is why it's so hard for us.

Code tends to become unmaintainable in the same iterative development that a refactor needs to be to work. Developers
are lazy, and shortest-path is attractive, especially in a startup culture. But all startups (and developers) eventually
face code that must be fixed, that prevents velocity, that is scary, that causes burnouts. The hard part fixing it 
without killing the project.

TL;DR: I have no idea what I'm talking about.