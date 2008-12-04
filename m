From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Wed,  3 Dec 2008 17:15:51 -0800 (PST)
Message-ID: <20081204011551.4406810800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbYLDBQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 20:16:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB41Fppp017036
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 17:15:52 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #11 from rjw@sisk.pl  2008-12-03 17:15 -------
On Thursday, 4 of December 2008, James Bottomley wrote:
> On Wed, 2008-12-03 at 22:49 +0100, Rafael J. Wysocki wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12120
> > Subject         : [Block layer or SCSI] requests aborted too early
> > during check_partition()
> > Submitter       : Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
> > Date            : 2008-11-29 05:19 (5 days old)
> 
> Fixed by this patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9728c0814ecb505546696a659858fdb761375544


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
