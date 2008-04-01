From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 13:57:27 -0700 (PDT)
Message-ID: <20080401205727.3DD3311D10A@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbYDAU5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 16:57:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m31Kuveh014830
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 13:57:27 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #7 from seraph@xs4all.nl  2008-04-01 13:57 -------
On Tue, 01 Apr 2008 15:19:29 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> That's odd ... it's behaving like a resource conflict.  However, the
> ports and interrupt trace didn't betray anything.  What does lspci -vv
> say for each of the devices?

Output from lspci -vv attached.

> Also, if you remove the sym2 module in the
> problem case, does the sungem come back to life?

No, once it is hosed it stays hosed until the next boot. Fiddling with the
wrong ioports maybe?

> I'm afraid I can't see anything relevant looking over the sym2 changes,
> so you might need to bisect this to identify the culprit.

Working on that, but it is a hassle as this bitty-box needs some time to
compile a kernel. 2.6.23-rc1 didn't boot, for starters.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
