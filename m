From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
Date: Sun, 24 Oct 2010 00:12:36 -0500
Message-ID: <1287897156.3003.373.camel@mulgrave.site>
References: <1287764862.8930.220.camel@mulgrave.site>
	 <AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-10-22 at 17:48 -0700, Linus Torvalds wrote:
> On Fri, Oct 22, 2010 at 9:27 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > This represents the usual assortment of driver updates (bnx2i, zfcp,
> > qla, lpfc, ipr ..) plus several libfc and fcoe updates and a partial bfa
> > cleanup.
> 
> Why do you say "bfa cleanup"?
> 
> There's a _single_ commit that looks like this:
> 
>  220 files changed, 34823 insertions(+), 43478 deletions(-)
> 
> and which apparently rewrites the whole f*cking driver, with no
> explanations, no nothing. Why should anything like this be considered
> acceptable?
> 
> I'm going to pull it this once, because let's face it, nobody sane
> cares about that idiotic driver to begin with (and it does remove a
> lot more lines than it adds). But really, if I see something like that
> again, I will just tell you to go away and not send me crap like this
> again.
> 
> If it's that kind of crap, it should go into staging, or it shouldn't
> have been merged into the kernel in the first place.
> 
> Seriously. You need to start showing better taste. I realize that most
> of SCSI is crazy specialty hardware that is used by just a few people,
> but if you don't start pushing back on those vendors and make them do
> proper changes in small pieces and with actual commentary, then _I_ am
> going to push back at you. Hard. By simply not pulling crap.
> 
> This is not the first time I've been disgusted with the SCSI tree. And
> quite frankly, drivers like BFA are so totally irrelevant to anything,
> that I will have absolutely no problems with just saying "screw it, if
> they can't behave, they get removed from the kernel".
> 
> And don't blame it on bad vendors that won't do a good job. If they
> don't do a good job, then STOP TAKING THEIR CRAP. Make them understand
> that they need to work with the process, not do some kind of random
> "change everything, with no actual explanations". Blame me if you
> can't grow the balls to stand up to them. Tell them that I simply
> won't take it unless they clean up their act.
> 
> Because I really won't.

OK, so message received and understood.   The warning has already been
conveyed to the bfa maintainers (over a month ago). All of us appreciate
the one time grace.  I think this driver will finally start moving in
the right direction.

James
