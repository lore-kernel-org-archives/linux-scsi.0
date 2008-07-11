From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Thu, 10 Jul 2008 17:42:48 -0700 (PDT)
Message-ID: <20080711004249.0688110800B@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbYGKAnS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 20:43:18 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6B0gn6w026016
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2008 17:42:50 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #19 from anonymous@kernel-bugs.osdl.org  2008-07-10 17:42 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Thu, 2008-07-10 at 16:44 -0700, Andrew Morton wrote:
> On Thu, 10 Jul 2008 16:52:01 +0200 kurk <kurk@shiftmail.org> wrote:
> 
> > Prakash, Sathya wrote:
> > > This may  be a problem due to enabling MSI for SPI controllers. I have posted another message in the list providing the correction patch which is already in scsi-misc tree. 
> > > If the problem is gone with changing the module parameter mpt_msi_enable=0 or by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then it might be due to MSI enabling.
> > >   
> > Another good news: I confirm that yes, the problem is also fixed by the 
> > patch linked above by Sathya, and in that case it is not needed to 
> > specify option mpt_msi_enable=0 for mptbase. Any one of the two (patch 
> > or option) is enough to fix the problem.
> > It would be nice to see this patch in the final release of the 2.6.26 kernel
> > Thank you
> 
> James, shouldn't we put that into 2.6.26?

I'm still not sure ... if it's a fault on the board with MSI, then yes,
we need it in ... although the form would then be wrong because we
probably should be identifying the faulty parts and blacklisting them.

If it's actually a fault on the motherboard with MSI, then no, this
isn't the patch series that should be in we need the motherboard strings
to blacklist it.

Unfortunately, I can't seem to get an answer out of LSI on this
question, It looks like the commit will cherry pick easily enough ...
although now I look at it the parameter's description is wrong.

> That whole patch series looks pretty desirable actually..

Well, it was billed as a driver update ... and it has a lot more than
just trivial changes, so on an eve of release quality issue, I'd tend to
say that wouldn't be a good idea.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
