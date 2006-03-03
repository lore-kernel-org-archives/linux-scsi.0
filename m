From: Linus Torvalds <torvalds@osdl.org>
Subject: RE: sg regression in 2.6.16-rc5
Date: Fri, 3 Mar 2006 13:54:01 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603031334530.22647@g5.osdl.org>
References: <085C28F775E1B74F82122EF0975E6E76045F08E3@sdcexc02.emea.cpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55452 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751630AbWCCVyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 16:54:09 -0500
In-Reply-To: <085C28F775E1B74F82122EF0975E6E76045F08E3@sdcexc02.emea.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Falkinder, David Malcolm" <david.falkinder@hp.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net



On Fri, 3 Mar 2006, Falkinder, David Malcolm wrote:
> 
> To succinctly re-iterate - you're breaking functionality (albeit an
> exploited defect), without providing a timeline / plan for it's
> restoration.

No. 

To succintly re-iterate: you're complaining, without actually having any 
basis for your complaints.

Point to actual breakage, and we'll see what the limitations are, and 
we'll fix it. Until you do, you are only a whining cry-baby.

As it is, the limits are _different_. For some hardware, the new limits 
may actually be _higher_ than the old limits for all I know. No, I haven't 
gone through them. Maybe there's some silly limit in the SCSI code itself 
that says that they always end up being lower, but the point is, we can 
fix it. It's just a limit. Usually it's a single constant somewhere.

And no, it has nothing to do with disks, per se. The limits are about more 
than sector counts aka "total transfer size" (which is independent of 
"sectors", but we just happen to talk about them in sectors). The limits 
are about things like how many scatter-gather elements the hardware will 
take, and about the rules for clustering physically contiguous regions.

And yes, there may be mis-features there, but so far, a lot of the people 
who complain seem to do it because they like to _complain_, not because 
they have a problem.

So instead of whining, do what the _productive_ reported did: make a 
trivial code snippet or binary available that actually shows the problem. 
Or just _test_ the damn current kernel. The code has been there since -rc1 
(that's six weeks ago), and quite frankly, if you're complaining without 
having tested it, you're not part of the solution, you're part of the 
_real_ problem.

Guess what happened with that productive reporter? He had a suggestion on 
how to fix it from Kai Makisara within a couple of hours, and could report 
that it fixed his problems the very same day. That was over a week ago.

Compare that to your post: absolutely _zero_ actual useful content, and 
just whining about something breaking without you apparently knowing what 
it is, or at least showing any actual breakage.

And you some people apparently expect me to _respect_ whining like that 
and be polite about it?

So here's me being REALLY impolite: "Shut the f*ck up until you can 
actually point to a particular regression".

Ok? Btw, patches are also welcome. The pointless whining just isn't.

Do I make myself clear? 

		Linus
