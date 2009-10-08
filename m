From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 08 Oct 2009 14:56:50 +0000
Message-ID: <1255013810.4187.34.camel@mulgrave.site>
References: <1254844007.4383.85.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	 <1254862442.4383.183.camel@mulgrave.site>
	 <1255012399.4187.24.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932483AbZJHO5f@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-10-08 at 07:39 -0700, Linus Torvalds wrote:
> 
> On Thu, 8 Oct 2009, James Bottomley wrote:
> > 
> > So what do you want to do about this? 
> 
> I'm taking it (and the parisc one I was also unhappy with), but I'm a bit 
> grumpy as usual. The parisc pull came totally outside the merge window, 
> and the SCSI fix pull is technically perfectly fine, but what makes me 
> grumpy is that I get the strong feeling that people aren't even _trying_ 
> to hit the merge window with new drivers, because they decide that they 
> instead can just push them any time.

OK, so we still have a bit of a mismatch here.  I *do* tell people who
come to SCSI with new drivers that for the *first* submission they don't
need to worry about the merge window because of the new driver
exception.  This allows us to clean them up ready for going in without
the submitter feeling huge pressure to hit the merge window rather than
concentrating on code quality and what we need to make a technically
correct submission.

I think this is the correct thing to do for new drivers (which often
come with new writers) because training people to hit the merge window
is often long an painful (when I say not yet to their important driver
enhancements) ... starting people off with the carrot is better than the
stick.

> So I don't think I necessarily want to change the "new driver" policy per 
> se, but I want people to see the merge window as the _primary_ time you 
> get any new code in. The "yes, we'll take new drivers" thing should be the 
> exception rather than the rule. It doesn't seem to be an exception.

Like I said, this will be my fourth new driver under the exception in
the whole year it's been going.  On the other hand, I do have pm8001
still going ... it just got resubmitted after another round of fixes.
If it's ready for the next rc submissions round, it will be my fifth ...

James
