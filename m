From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
Date: Fri, 22 Oct 2010 17:48:35 -0700
Message-ID: <AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
References: <1287764862.8930.220.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab0JWAs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2010 20:48:59 -0400
In-Reply-To: <1287764862.8930.220.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Oct 22, 2010 at 9:27 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> This represents the usual assortment of driver updates (bnx2i, zfcp,
> qla, lpfc, ipr ..) plus several libfc and fcoe updates and a partial bfa
> cleanup.

Why do you say "bfa cleanup"?

There's a _single_ commit that looks like this:

 220 files changed, 34823 insertions(+), 43478 deletions(-)

and which apparently rewrites the whole f*cking driver, with no
explanations, no nothing. Why should anything like this be considered
acceptable?

I'm going to pull it this once, because let's face it, nobody sane
cares about that idiotic driver to begin with (and it does remove a
lot more lines than it adds). But really, if I see something like that
again, I will just tell you to go away and not send me crap like this
again.

If it's that kind of crap, it should go into staging, or it shouldn't
have been merged into the kernel in the first place.

Seriously. You need to start showing better taste. I realize that most
of SCSI is crazy specialty hardware that is used by just a few people,
but if you don't start pushing back on those vendors and make them do
proper changes in small pieces and with actual commentary, then _I_ am
going to push back at you. Hard. By simply not pulling crap.

This is not the first time I've been disgusted with the SCSI tree. And
quite frankly, drivers like BFA are so totally irrelevant to anything,
that I will have absolutely no problems with just saying "screw it, if
they can't behave, they get removed from the kernel".

And don't blame it on bad vendors that won't do a good job. If they
don't do a good job, then STOP TAKING THEIR CRAP. Make them understand
that they need to work with the process, not do some kind of random
"change everything, with no actual explanations". Blame me if you
can't grow the balls to stand up to them. Tell them that I simply
won't take it unless they clean up their act.

Because I really won't.

                        Linus
