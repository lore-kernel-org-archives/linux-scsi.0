From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Sat, 24 May 2008 14:21:50 -0700 (PDT)
Message-ID: <20080524212150.D76A310805E@picon.linux-foundation.org>
References: <bug-10622-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYEXVW0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 May 2008 17:22:26 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4OLLoaJ011111
	for <linux-scsi@vger.kernel.org>; Sat, 24 May 2008 14:21:51 -0700
In-Reply-To: <bug-10622-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10622





------- Comment #4 from rjw@sisk.pl  2008-05-24 14:21 -------
James Bottomley said:

"I've been unable to get the reporter to respond to basic debugging
inquiries about this.  Without that information, my best guess is that
it's a kmalloc failure that ordinarily would be a mm issue.  However,
given that there have been no other reports of this, I suspect it might
be some type of one off error.

I'd downgrade the severity to not reproducible and kill it unless any
further information comes along."

References : http://lkml.org/lkml/2008/5/22/485


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
