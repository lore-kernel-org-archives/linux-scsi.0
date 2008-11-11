From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 03:28:41 -0800 (PST)
Message-ID: <20081111112842.05A60108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbYKKL2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 06:28:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mABBSgMp007742
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2008 03:28:43 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #34 from vandrove@vc.cvut.cz  2008-11-11 03:28 -------
Two news, both bad.

First bad news is that I tried kernel (yesterday's git) with patch from #28,
and on 4 runs I twice got kernel crash I attached, once system hung during test
for no aparent reason, and one run completed.

Second bad news is that one run which completed took twice as long when
compared to test with Jens's patches to SATA reverted (4x 50MBps vs. 4x
24MBps).  But that probably deserves separate bug once crashes are fixed - with
2.6.27-rc1 during my test (write 4GB concurrently to all devices) all 4 leds
for devices behind PMP are on.  With current git and patch above almost always
only one led is lit, usually for 2-3 seconds, then bandwidth shifts to another
drive - as drives have 60MBps speed while sata has 300MBps, no surprise it is
slower when commands are not interleaved...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
