From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] New: [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 05:19:55 -0800 (PST)
Message-ID: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYK2NU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 08:20:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATDJtw1003569
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 05:19:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120

           Summary: [Block layer or SCSI] requests aborted too early during
                    check_partition()
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.28-rc
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: stefan-r-bz@s5r6.in-berlin.de
OtherBugsDependingO 11808
             nThis:
        Regression: 1


Latest working kernel version: 2.6.27.4
Earliest failing kernel version: 2.6.28-rc6  (I didn't test earlier -rcs yet)

Hardware Environment: OxSemi 912 and 92x based FireWire harddisks


See http://marc.info/?l=linux-scsi&m=122774022130397 --
Disks may still spin their motor up when the kernel attempts to read
partitions. In kernel 2.6.27, this was handled transparently.  But since
2.6.28-rc?, the kernel immediately aborts the associated requests and sets the
new scsi_device offline.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
