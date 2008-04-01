From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 14:14:54 -0700 (PDT)
Message-ID: <20080401211454.0C77411D108@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbYDAVP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 17:15:27 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m31LEs9S017086
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 14:14:55 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #8 from anonymous@kernel-bugs.osdl.org  2008-04-01 14:14 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-04-01 at 22:57 +0200, Jos van der Ende wrote:
> On Tue, 01 Apr 2008 15:19:29 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > That's odd ... it's behaving like a resource conflict.  However, the
> > ports and interrupt trace didn't betray anything.  What does lspci -vv
> > say for each of the devices?
> 
> Output from lspci -vv attached.

Thanks ... unfortunately looks normal too.  The gem has a single memory
region; the sym2 has 2 mem and one IO region, all of which show up in
the /proc/iomem|ports.

> > Also, if you remove the sym2 module in the
> > problem case, does the sungem come back to life?
> 
> No, once it is hosed it stays hosed until the next boot. Fiddling with the wrong ioports maybe?

Yes ... that's what I guess.  Just as one last grasp at a straw, is
there any difference in /proc/iomem or /proc/ioports for the working
case (sungem loaded first followed by sym2)?

> > I'm afraid I can't see anything relevant looking over the sym2 changes,
> > so you might need to bisect this to identify the culprit.
> 
> Working on that, but it is a hassle as this bitty-box needs some time to compile a kernel. 2.6.23-rc1 didn't boot, for starters.

Sorry ... can't think of much else that will help.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
