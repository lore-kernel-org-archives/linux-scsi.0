From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Sat, 27 Sep 2008 01:17:08 -0700 (PDT)
Message-ID: <20080927081708.AFB45108058@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbYI0IRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2008 04:17:38 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8R8H814027755
	for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2008 01:17:09 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #6 from grin@grin.hu  2008-09-27 01:17 -------
Unfortunately no. 

The system in question does not have physical serIO, and said to have a
serial-over-IP feature, which in fact does not work (and it's a pretty stupid
thing anyway, since you should have to telnet(!) in and capture the output
somehow; but the connection breaks after 1-2 minutes anyway).

I've tried netconsole but unfortunately [and naturally] it dies along with
eth0. 

I was thinking about usb serial port, but it probably requires IRQs alive
either.

But, as I mentioned, I backed up the live system to 2.4.20 to prevent further
lockups, and I do not really have a way to kill the test system manually. (So
far I've tried 2-3 runs of bonnie++ and tiobench, neither locked it up but I'll
try to run then in endless loop and see what happens.)

Which version of kernel have in your opinion a good chance to have the change?
I see there was a big version change somewhere, if you could point out the
kernel version I'd try to shoot around it.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
