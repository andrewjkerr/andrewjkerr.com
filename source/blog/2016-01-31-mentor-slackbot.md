---
title:  "SwampHacks Mentor Request Slackbot: Postmortem"
date:   2016-01-31 16:30:00
tags:   hackathon, slack
---

_[SwampHacks](http://swamphacks.com) is a yearly hackathon at the University of Florida that brings four hundred students from various schools to bring a crazy idea to life._

One of the crucial components of hackathons are mentors. Mentors help the hackers overcome issues that Stack Overflow or Google-fu can't help with. However, with a large number of hackers and mentors with varying skillset, handling mentor requests can be overwhelming. To handle this, I decided to create a Slackbot.

## Creating the Slackbot

Deciding to create a Slackbot to handle mentor requests was a no brainer. Hackathons are increasingly using Slack to handle communication between the admin team and the hackers and I thought that Slack would be a great way to request help for a mentor.

The idea was simple: have the Slackbot track the mentor's skills and availability and allow for hackers to request a mentor of either a skill or any skill. To do this, I had a [`config.js`](https://github.com/andrewjkerr/hackathon-mentor-request-slackbot/blob/master/config.sample.js) file store information about the mentors and their skill:

```javascript
module.exports = {
  // Bot config stuff
  mentors: ['bernie', 'andrew'],
  teams : {
    ruby: ['andrew'],
    javascript: ['bernie']
  }
}
```

When the bot was first executed, the mentors would be copied over to an `available` array and that kept track of which mentors were available. If a mentor was assigned, the mentor would be popped off of the `available` array and then re-added once they were done.

Speaking of assigning mentors, I'd say the coolest thing that I did with my bot was to open up a private channel with the mentor and hacker. However, I had some... issues with the `createGroup()` callback (read on to learn why!) so I decided to use the `_apiCall()` function directly to call the Slack `groups.create` API call:

```javascript
slack._apiCall('groups.create', { name: group_name }, function(data) {
  group_id = data.group.id;
  var group = slack.getChannelGroupOrDMByID(group_id);
  invite_user(assigned_mentor_obj, group);
  invite_user(assigned_to_obj, group);

  slack._apiCall('groups.setTopic', { channel: group_id, topic: issue }, function(data) {
    slack_functions.say('Ok, @' + assigned_mentor_obj.name + ' you\'re up! Please join the new group and make sure to `.mentor done` when you are done.', where);

    var index = available.indexOf(assigned_mentor);
    if (index > -1) {
        available.splice(index, 1);
    }
  });
});
```

What the above code snippet does is creates a new private channel (or, group in Slack terminology), invites the mentor and hacker to the group, and then sets the topic of the group with the issue that the hacker set. Pretty cool, eh?

However, after implementing the above, I found out why `createGroup()` did not work. Slack's documentation has this nifty little errors section at the bottom and, if I had scrolled all the way down, I would have realized that `user_is_bot` is an error that `groups.create` throws. Unfortunately, I kept trying with a bot user and never saw the `user_is_bot` error message until much later. Oh well!

After writing the code to create groups, it was time to write up the [README](https://github.com/andrewjkerr/hackathon-mentor-request-slackbot/blob/master/README.md), submit to the [Knight Hack Devpost](http://devpost.com/software/hackathon-mentor-request-slackbot-gpmf4e), and set up for the demo!

## Using the Slackbot

The only instruction given to hackers at SwampHacks was "Use `.mentor` to summon the bot!" and many hackers did. Using just `.mentor` summons help text along with a link to the README. The help text explains the bot's commands (`.mentor available` and `.mentor keywords`) as well as how to request a mentor (`.mentor [keyword] [issue]`).

Along with the hacker commands, I added some mentor commands. Whenever a mentor needed to step away, they could set themselves as unavailable with `.mentor away`. Whenever they were available again (either after setting themselves as away or after helping a hacker), the mentor could use `.mentor done` to add themselves to the available list again.

And, finally, there were some admin commands. Admins could add or delete mentors via their own set of `.mentor add [keyword] [mentor]` and `.mentor delete [mentor]` commands. These were _extremely_ clunky, but I wrote this bot at a hackathon and it worked. Plus, by admin, I meant me and I figured that this setup was good enough for me.

## Deploying the Slackbot

A week later, it was time to deploy the bot for SwampHacks. I had made a [few tweaks and changes](https://github.com/andrewjkerr/hackathon-mentor-request-slackbot/commits/master) since Knight Hacks, but it was game time.

The `tl;dr` of this is that I ran it on a micro EC2 instance with MLH's free AWS credits. I chose AWS over something like Heroku or DigitalOcean because (1) I wasn't entirely sure how to use Node.js with Heroku and (2) I had free AWS credit.

## SwampHacks + hackathon-mentor-request-slackbot

As mentioned above, the only command that we told hackers about was the `.mentor` command. Hackers would normally come in, use `.mentor` and then request a mentor using the `.mentor [keyword] [issue]` format that I had requested. It was great! However, I started to notice that there was one keyword being used more than others...

API. Why was the API keyword being used more? Well, there was an API prize and apparently hackers didn't exactly know how to use it. This meant a _lot_ of requests asking for help "installing [sponsor]'s API". These requests were reasonable, but, unfortunately, the mentors who were labeled with a skill in "api" were mentors who were looking to help hackers _build_ an API not use client libraries. The mentors that had this keyword were understanding with this, but it presented a slight frustration as it was tying up valuable mentors helping hackers install client libraries instead of helping hackers build amazing APIs.

Other than that, it seemed like everything was going smoothly. Hackers were requesting mentors, mentors were helping out via Slack (and in person if needed), and then mentors were returning to the queue. It was great! Until the bot crashed.

When the bot crashes, _everything_ that was added while the bot is running gets erased. That means that the mentors that were added, the mentors that were deleted, and the mentors that were marked as unavailable are deleted. Personally, I thought this was an acceptable risk because:

1. I didn't think the bot would crash
2. I didn't expect to be adding/deleting mentors throughout the event

However, both of these points were poorly thought through as they both turned out to be wildly wrong. Throughout the event, the bot crashed twice and I added probably about 20 mentors. So, what does this "in the field" usage report mean for the hackathon-mentor-request-slackbot?

## Looking to the Future

I still think that organizing mentor requests via a Slackbot is a pretty good idea. The keywords and persistence was definitely an issue, but I have some ideas in order to fix those:

### Fixing Keywords

Keywords is still something that I like, but I think that the keywords need to be more specific. For example, instead of using "javascript", it should be "node" or "jquery". Or, in the case discussed above, "[sponsor]" or "rest" (though, who "rests" during a hackathon, amirite?).

Since this is more of a config change than a bot change, I don't think I'll enforce this at a code level, but hopefully this post will serve as guidance for choosing keywords!

### Fixing Persistence

Fixing persistence can be solved two ways:

1. Add persistence
2. Catch exceptions

I thought about catching exceptions, but, to be honest, I have no idea why exceptions were thrown. The first crash happened because a group didn't have an id. Was this my fault or Slack's fault? No clue. So, I threw out the idea of catching exceptions as I had no idea _where_ to catch exceptions (plus I'm not really a JavaScript pro and the only try catch in my bot is... ugly).

Because of this, I've decided to add a simple API. I'm not sure when I'll have time to work on it, but it might be at the next hackathon I attend!

The API will have the same abilities that the bot currently has, but I'm hoping to also add logging so I can more accurately track the data rather than searching Slack.

### Ruby Re-write

Possibly. I wrote my first [Ruby Slackbot](https://github.com/andrewjkerr/announcebot-slack) about two weeks ago and I thought it was a lot easier than using Node. But, that might be because I love Ruby :)

---

I'm a huge fan of Slack and, now that I'm a hackathoner, I'm always trying to find ways to improve the experience of hackathons by using Slack. If you're interested in helping out, write a Slackbot for a hackathon and [let me know](https://twitter.com/andrewuf)!

Also, if you're interested in how to improve your hackathon with Slack, my next post will be how to set up Slack for a hackathon. I'll be tweeting out whenever that is posted so make sure to follow me on Twitter, [@andrewuf](https://twitter.com/andrewuf)!
