From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Thu,  6 Nov 2008 17:04:39 -0800 (PST)
Message-ID: <20081107010439.38A52108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYKGBFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 20:05:10 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA714d4f020863
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2008 17:04:40 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #27 from yanmin_zhang@linux.intel.com  2008-11-06 17:04 -------
(In reply to comment #26)
> Reply-To: James.Bottomley@HansenPartnership.com
> 
> On Wed, 2008-11-05 at 18:19 -0800, bugme-daemon@bugzilla.kernel.org
> wrote:
> > ------- Comment #25 from yanmin_zhang@linux.intel.com  2008-11-05 18:19 -------
> > Created an attachment (id=18697)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18697&action=view) [details]
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=18697&action=view)
> > Here is the patch to fix it against 2.6.28-rc3.
> > 
> > I tested the patch on my 2 machines and it does fix the issue.
> 
> The problem is that it doesn't fix the theoretical tight loop, so
What's the theoretical tight loop the patch doesn't fix? Would you like to
elaborate it?

I know there is a scenario that scsi_target_is_busy might returns true in
scsi_run_queue, but my patch also fixes it.


> someone else will run into the issue under more trying circumstances.
> 
> The only reason a patch which conditionally NULLs starved_head works
> over one that does it absolutely should be that there's some other loop
> that requires it being set to effect a break out.
I can't understand what you said. What are the other loop?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
