From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Date: Wed, 24 Oct 2007 08:35:21 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0710240818320.30120@woody.linux-foundation.org>
References: <471E6313.1040704@garzik.org>  <1193174424.3434.3.camel@localhost.localdomain>
  <471E707B.1020505@garzik.org>  <20071023.153635.21595587.davem@davemloft.net>
 <1193232490.3396.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbXJXPfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 11:35:31 -0400
In-Reply-To: <1193232490.3396.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>



On Wed, 24 Oct 2007, James Bottomley wrote:
> 
> OK, so it's no secret that I'm the last of the subsystem maintainers
> whose day job isn't working on the linux kernel.  If you want a full
> time person, who did you have in mind?

Quite frankly, at least for me personally, what I would rather have (in 
general: this is really not at all SCSI-specific in any way, shape, or 
form, and not directed at James!) is a less rigid maintainership 
structure.

Let's face it, we are *all* likely to be overworked at different times, 
and even when not overworked, it's just the fact that people need to take 
a breather etc. And there is seldom - if ever - a very strong argument for 
having one person per subsystem.

I think git is excellent for trying to spreading the "joy" of 
maintainership, but even without something like that, I think it's much 
better to try to find people you can trust, rather than strict 
maintainership boundaries. For example, Andrew certainly seems to be very 
productive as a kernel maintainer, and it has nothing to do with git, and 
everything to do with trust.

So I'd rather have less recriminations about "xyz is holding up abc", and 
have people more open to just trying to help out even across strict 
borders. And I don't mean that in a "two fighting people" kind of way 
where there are two or more people who maintain things _despite_ each 
other, but more in a 

  "Hey we know each other, and we trust each other, and no, we won't 
   guarantee that we always agree, but we can work on things, and if it 
   turns out that one person merged somethign that the other person 
   _really_ doesn't like, we'll revert it and/or work it out some other 
   way".

I've personally always been against _strict_ maintainer lines, so I've 
always taken stuff "past" the maintainer anyway (and sometimes maintainers 
have complained, because they feel like they "own" their subsystem, and I 
either tell them to stuff it, or say "my bad", depending on whether they 
had a valid _technical_ complaint or not).

So rather than getting into a pissing match of "ok, who would be the best 
maintainer", I'd much *much* prefer to take this as another "we really 
don't need or even _want_ to have strict maintainer rules" opportunity.

Now, the most important part here is the trust part. I need to be able to 
trust maintainers, but when you have multiple people in the same "box", 
those people need to trust each other even more than usual, because you 
*are* going to get disagreements. And the only way it can work is if you 
acknowledge that disagreements will happen, and that any situation is  not 
a "my way or the highway" kind of thing - the trust also implies a certain 
give and take.

And this really *is* an issue that cuts across subsystem boundaries. 
Anybody who thinks that SCSI is "unique" in this kind of issues is sadly 
mistaken. We've had the exact same thing come up in every single subsystem 
over time, and at every single level of maintainership (from individual 
drivers all the way right up to me) over time.

So I *really* don't want to throw any stones in a glass house here. Quite 
the reverse. I'd like to get rid of some of the glass, and replace it with 
padding. Because you all know we'd all fit better in a padded room than a 
glass house..

Are there any such people that think there s a sufficient mutual trust 
with James that you think a blurring of maintainership lines could work 
out? Or in any other subsystem, for that matter? Hmm?

			Linus
