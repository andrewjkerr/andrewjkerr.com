---
title:  "Assignments in Markdown"
date:   2015-09-08 15:15:00
tags:   school, tutorial
---

Something I've started doing recently is doing assignments in markdown. I already type my [(digital) notes in markdown](https://github.com/andrewjkerr/CIS4301-Exam-2-Review) so I figured that I might as well start doing reports and such in markdown as well.

## Why Markdown?

The question most of you will have is: why markdown? Well, I choose to do assignments and things in markdown for the simple fact that markdown is just text. Since my notes/assignments are in plain text, I can easily use version control (git, mainly) to manage my notes/assignments and easily upload to GitHub.

Ok, but why not just use plain text to take notes? Because, plaintext doesn't give me the ability to easily _italicize_ or __bold__ words or create headings (\#) or insert [links](#do-not-click-this-plz) or insert images or add syntax highlighting to code or insert tables (on GitHub). With markdown, all of this is possible! Markdown is just a simple way of formatting text that will turn into HTML eventually or, in my case, PDF documents to submit to my professors.

## How to Use Markdown

I'm not going to give a markdown tutorial (GitHub does a fantastic job [here](https://help.github.com/articles/markdown-basics/)), but I will talk about my markdown editing flow.

I use [Sublime Text](https://www.sublimetext.com/) with a plugin called [Markdown Preview](https://github.com/revolunet/sublimetext-markdown-preview). What this allows me to do is preview my markdown document in a web browser.

For example, this is this post in Sublime Text:

![../assets/images/md-assignments/sublime.png](/assets/images/md-assignments/sublime.png)

And this is that text rendered in a web browser with Markdown Preview:

![../assets/images/md-assignments/md-preview.png](/assets/images/md-assignments/md-preview.png)

Pretty cool, eh?

Once you have the Markdown Preview plugin installed, you can hit `cmd + shift + p` to open the command pallete and select 'Markdown Preview: Preview in Browser'. This will give you two options: 'github' and 'markdown'. Selecting github will give you the ability to add syntax highlighting, tables and other [special flavored markdown GitHub provides](https://help.github.com/articles/github-flavored-markdown/). However, I've had issues with this so I normally use normal markdown which is plain ol' markdown.

After I have it opened in a browser, I preview it and then print it to PDF and submit that. So far, none of the people grading my assignments have complained about it and I've found that I'm _way_ quicker using markdown than using something like Word - especially for things that contain code (unformatted text) and a lot of images.

As with most things, your milage may vary and, while I find this to be super quick, you might not be as lucky. But, I'd recommend you give it a shot and think of markdown as an option for formatting things like lab reports and homework assignments!
