From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 00:01:01 +0000
Message-ID: <1236124861.24019.78.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
	 <1236115544.15993.22.camel@localhost.localdomain>
	 <20090303214454.GA8288@elte.hu>
	 <1236119990.24019.35.camel@localhost.localdomain>
	 <20090303230323.GA21644@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57123 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbZCDABG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 19:01:06 -0500
In-Reply-To: <20090303230323.GA21644@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Wed, 2009-03-04 at 00:03 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Tue, 2009-03-03 at 22:44 +0100, Ingo Molnar wrote:
> > > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > > > So the real question is why does the -rt tree even have 
> > > > > > patches not in the vanilla SCSI tree?  This type of cockup 
> > > > > > clearly demonstrates why it's a bad idea.
> > > > > 
> > > > > Believe me, i have better things to do than to track down your 
> > > > > regressions. I applied a fix/test patch sent to me by SCSI 
> > > > > folks.
> > > > 
> > > > Look, I've no problem with you collecting random patches.  I 
> > > > have a problem when you start pushing random SCSI patches into 
> > > > other trees. [...]
> > > 
> > > Both -tip and -rt are generic trees and there's a connection 
> > > between them that the maintainers of both are one and the same 
> > > set of people.
> > > 
> > > So i'm not sure on what grounds you purport to be able to 
> > > prevent fixes from flowing from -tip into -rt and vice versa.
> > > 
> > > You have no monopoly on the propagation and testing of SCSI 
> > > fixes. We picked up a v1 patch from the SCSI list and did not 
> > > add nor remove anything from it.
> > 
> > OK, let me try and make the problem simpler for you:  If you pick up
> > random patches outside of your area [...]
> 
> Dude, lets make it clear to you: it is not "your area" that you 
> own in any way and you have no monopoly on SCSI fixes.

The fact that I can spot a missing release buffers and you, apparently,
can't does lend credence to a claim of greater expertise in the SCSI
area.

>  We acted 
> out of necessity because the SCSI tree is taking very long to 
> get fixes upstream.

To get upstream, there first has to be a fix.  I've already explained
why I don't think the patch in question is a fix.

> I reported this lockup bug to you on _January 15th_, more than 
> one and a half months ago - and it's still unfixed even today. 
> Alan sent his v2 fix on Feburary 19th - two weeks ago.

OK, so why don't you humour me and try applying the diagnostic patch I
sent you on the 24th of January?  I think there's a loop in I/O
completion caused by some type of timing race, and starved list handling
is the prime candidate.

>  We are 
> not asking you for much, is it really that hard to act like a 
> proper maintainer and get critical fixes upstream in a timely 
> manner?

You're asking me to ignore root cause analysis and push patches as "bug
fixes" just because they hide the problem on your machine.

> Again, i repeat, i picked up a v1 patch from the SCSI list that 
> i reported and which patch was sent to me. I did that in the 
> hope to fix a serious lockup bug that is still unfixed in the 
> upstream kernel here and today. That kind of bug can cause data 
> corruption and is serious and you should have given full, high 
> priority attention to it - but you didnt.
> 
> A v2 patch was sent too but i missed it because it had the exact 
> same subject line and no 'v2' in its title.
> 
> I did not do this out of fun - i did it to address a serious 
> regression that was unfixed upstream.
> 
> If there's a failure here it's yours: your latency and 
> unreliability in SCSI bug fixing is forcing generic trees like 
> -tip or -rt (or -mm) to carry SCSI fixes while it should be 
> _your_ responsibility to act quickly to bugreports and get 
> critical fixes upstream as soon as possible.

Well, you not responding to requests for information for three weeks
(before deciding the it was unnecessary to provide it) may have helped
elongate the time scale ...

However, I'm not really interested in recriminations.  Since you already
know better than me what the bug is, simply explain here what the patch
actually fixes and it can go upstream with my blessing and whatever ego
boosting praise you require.

James


