From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12164] New: cciss driver hangs on boot
Date: Thu,  4 Dec 2008 08:11:07 -0800 (PST)
Message-ID: <bug-12164-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbYLDQLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 11:11:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB4GB77r014878
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2008 08:11:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12164

           Summary: cciss driver hangs on boot
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.4.37
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: rich@hq.vsaa.lv


Latest working kernel version: 2.4.25
Earliest failing kernel version: 2.4.28
Distribution: slackware 11.0
Hardware Environment: HP ProLiant DL360 G3
Software Environment:
Problem Description:

boot of kernels 2.4.28-37 hangs on "partition check" step.
latest kernel that boots is 2.4.25.
26 and 27 fail to compile on that machine, so nailing this down to a precise
version has been problematic.
cciss driver is compiled in the kernel.

more information probably will be needed, i'll be happy to provide it.

adapter :
00:04.0 RAID bus controller: Compaq Computer Corporation Smart Array 5i/532
(rev 01)

Steps to reproduce:
boot a kernel 2.4.28 to 2.4.37 on such a hw configuration


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
