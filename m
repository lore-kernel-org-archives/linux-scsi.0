From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 00:03:23 +0100
Message-ID: <20090303230323.GA21644@elte.hu>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr> <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757525AbZCCXDx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1236119990.24019.35.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-03-03 at 22:44 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > > So the real question is why does the -rt tree even have 
> > > > > patches not in the vanilla SCSI tree?  This type of cockup 
> > > > > clearly demonstrates why it's a bad idea.
> > > > 
> > > > Believe me, i have better things to do than to track down your 
> > > > regressions. I applied a fix/test patch sent to me by SCSI 
> > > > folks.
> > > 
> > > Look, I've no problem with you collecting random patches.  I 
> > > have a problem when you start pushing random SCSI patches into 
> > > other trees. [...]
> > 
> > Both -tip and -rt are generic trees and there's a connection 
> > between them that the maintainers of both are one and the same 
> > set of people.
> > 
> > So i'm not sure on what grounds you purport to be able to 
> > prevent fixes from flowing from -tip into -rt and vice versa.
> > 
> > You have no monopoly on the propagation and testing of SCSI 
> > fixes. We picked up a v1 patch from the SCSI list and did not 
> > add nor remove anything from it.
> 
> OK, let me try and make the problem simpler for you:  If you pick up
> random patches outside of your area [...]

Dude, lets make it clear to you: it is not "your area" that you 
own in any way and you have no monopoly on SCSI fixes. We acted 
out of necessity because the SCSI tree is taking very long to 
get fixes upstream.

I reported this lockup bug to you on _January 15th_, more than 
one and a half months ago - and it's still unfixed even today. 
Alan sent his v2 fix on Feburary 19th - two weeks ago. We are 
not asking you for much, is it really that hard to act like a 
proper maintainer and get critical fixes upstream in a timely 
manner?

Again, i repeat, i picked up a v1 patch from the SCSI list that 
i reported and which patch was sent to me. I did that in the 
hope to fix a serious lockup bug that is still unfixed in the 
upstream kernel here and today. That kind of bug can cause data 
corruption and is serious and you should have given full, high 
priority attention to it - but you didnt.

A v2 patch was sent too but i missed it because it had the exact 
same subject line and no 'v2' in its title.

I did not do this out of fun - i did it to address a serious 
regression that was unfixed upstream.

If there's a failure here it's yours: your latency and 
unreliability in SCSI bug fixing is forcing generic trees like 
-tip or -rt (or -mm) to carry SCSI fixes while it should be 
_your_ responsibility to act quickly to bugreports and get 
critical fixes upstream as soon as possible.

	Ingo
