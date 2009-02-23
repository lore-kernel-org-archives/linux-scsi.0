From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Sun, 22 Feb 2009 16:54:43 -0800 (PST)
Message-ID: <20090223005443.6D41B108043@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbZBWAyp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 19:54:45 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1N0shoY018559
	for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2009 16:54:44 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #18 from zoltan.kiss@serverside.hu  2009-02-22 16:54 -------
Hi, i also suffer from this bug.

Here is the qla section of /var/log/messages:
Feb 22 21:28:36 bafs1 kernel: [71282.592558] qla2xxx 0000:08:01.0: Mailbox
command timeout occured. Issuing ISP abort.
Feb 22 21:28:36 bafs1 kernel: [71282.592611] qla2xxx 0000:08:01.0: Performing
ISP error recovery - ha= ffff81012e5105f8.
Feb 22 21:28:37 bafs1 kernel: [71283.546086] qla2xxx 0000:08:01.0: LOOP UP
detected (4 Gbps).
Feb 22 21:28:37 bafs1 kernel: [71283.685581] qla2xxx 0000:08:01.0: scsi(0:0:2):
Abort command issued -- 0 2457f0 2002.
Feb 22 21:29:06 bafs1 kernel: [71325.253361] qla2xxx 0000:08:01.0: scsi(0:0:2):
DEVICE RESET ISSUED.
Feb 22 21:29:36 bafs1 kernel: [71412.254597] qla2xxx 0000:08:01.0: Mailbox
command timeout occured. Issuing ISP abort.
Feb 22 21:29:36 bafs1 kernel: [71412.254597] qla2xxx 0000:08:01.0: Performing
ISP error recovery - ha= ffff81012e5105f8.
Feb 22 21:29:37 bafs1 kernel: [71414.455676] qla2xxx 0000:08:01.0: LOOP UP
detected (4 Gbps).
Feb 22 21:29:37 bafs1 kernel: [71414.716347] qla2xxx 0000:08:01.0: scsi(0:0:2):
DEVICE RESET FAILED: Task management failed.
Feb 22 21:29:37 bafs1 kernel: [71414.716347] qla2xxx 0000:08:01.0: scsi(0:0:2):
TARGET RESET ISSUED.
Feb 22 21:30:07 bafs1 kernel: [71488.627662] qla2xxx 0000:08:01.0: Mailbox
command timeout occured. Issuing ISP abort.
Feb 22 21:30:07 bafs1 kernel: [71488.627662] qla2xxx 0000:08:01.0: Performing
ISP error recovery - ha= ffff81012e5105f8.


This happens on IBM BladeCenter HS21 Blade, Debian Lenny, stock kernel:
2.6.26-1-amd64 #1 SMP Sat Jan 10 17:57:00 UTC 2009 x86_64 GNU/Linux

My storage is IBM TS DS4300.

Now, i compiling the 2.6.20 kernel, with RHEL drivers, hope thats help.

Regards,
Zoltan Kiss
Bardi Auto - Hungary


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
