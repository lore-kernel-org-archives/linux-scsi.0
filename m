From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Tue, 30 Sep 2008 00:49:37 -0700 (PDT)
Message-ID: <20080930074937.E28D1108048@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbYI3Htk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 03:49:40 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8U7ncYS023378
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 00:49:39 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #7 from grin@grin.hu  2008-09-30 00:49 -------
Created an attachment (id=18108)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18108&action=view)
Some further logfile around a lockup

I tried and failed to manually lockup a kernel (tried 10 bonnie++ and
tiobench), but another one (2.6.24 with openvz patch but I believe openvz
shouldn't really matter to qla2xxx driver; you're free to disagree) locked up,
maybe there's something useful in the logs (the log drive wasn't stuck, no
OOPS).

The links seem to go down, but they most probably did not, since all other
servers went on completely fine at the time. Links seemed stayed down [and
locked up IO], but came up again after a reboot. I do not believe the links
were _really_ down at all, so this - by my guess - is the same problem.
Everything went to syslog. 

Plus I attached some proc/interrupts and ps tree and whatnot.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
