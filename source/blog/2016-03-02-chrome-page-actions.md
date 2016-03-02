---
title:  "Chrome's New Policy on Page Actions"
date:   2016-03-02 17:00:00
tags:   chrome, development
---

Did you update Chrome and see a longer list of extensions on your menu bar than usual? You're not the only one.

A few months ago, the Chromium team decided to make all extensions have a persistent icon in the Chrome toolbar [[1]](#footnote-1). I'm assuming the goal was to make installed extensions more visible to the user for security, privacy, and performance reasons, but it has a consequence of making Page Actions useless.

According to the Google Group post [[1]](#footnote-1), extensions with a Page Action will:

> be given a persistent icon in the toolbar.  On pages where the extension's page action wouldn't normally be visible, the action will be greyed out, indicating that it doesn't want to act.  On pages it does want to act, it will be fully-colored.

What does that mean? Well, for my Twitter AutoRefresh extension, that means that the very subtle Page Action that used to live in the navbar now lives in the toolbar. And, to make it worse, it's visible (albeit grayed out) on _every_ page. Here's a before and after:

![Before](assets/images/page-action/before.png)
<div class='caption'>_Before: a Page Action_</div>

![After](assets/images/page-action/after.png)
<div class='caption'>_After: a Browser Action_</div>

While this is annoying at first (it's only used for Twitter - why is it showing up on every page?!), the security side of me is welcoming the change as people are more likely to notice that malicious extension that got installed for them.

What do you think about it? Tweet at me: [@andrewuf](https://twitter.com/andrewuf)!

---

<div id='footnote-1'>[1] <a href="https://groups.google.com/a/chromium.org/forum/#!msg/chromium-extensions/7As9MKhav5E/dNiZDoSCCQAJ">https://groups.google.com/a/chromium.org/forum/#!msg/chromium-extensions/7As9MKhav5E/dNiZDoSCCQAJ</a></div>

---
