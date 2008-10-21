From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Tue, 21 Oct 2008 00:13:52 -0700 (PDT)
Message-ID: <20081021071352.B1012108042@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYJUHOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 03:14:05 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9L7DqGa017062
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 00:13:54 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #15 from grin@grin.hu  2008-10-21 00:13 -------
Just to note that I segmented one live server from the others in question and
it did not help [the separated one keeps crashing / locking up], now I am
trying to freeze the test server (which runs a stock kernel instead of the
openvz one), but probably due to the lack of real server load it's hard, and so
far the freezes were total. I am about to create a crashdump kernel, maybe I
can catch a glimpse of what happens. Stand by...

By the way I have some weird "RISC paused / firmware dumped" case on the live
machine, where it happens right after reboot, the system goes on just fine but
it shouldn't happen anyway I guess. I'll send the dumps by email.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
