From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12119] New: iscsi repeatedly times out
Date: Sat, 29 Nov 2008 03:10:39 -0800 (PST)
Message-ID: <bug-12119-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYK2LKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 06:10:42 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATBAd6P030836
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 03:10:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12119

           Summary: iscsi repeatedly times out
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.27.7
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: ian@beware.dropbear.id.au


Latest working kernel version:2.6.24.4-64
Earliest failing kernel version:2.6.27.5
Distribution:fc8
Hardware Environment:diskless i386, swap on iscsi device
Software Environment:open-iscsi v 6.2
Problem Description:As soon as the iscsi device is activated, the following
messages are logged:
Nov 29 21:24:51 dhcp-0-20-34-211-135-63 iscsid: Nop-out timedout after 15
seconds on connection 1:0 state (3). Dropping session.
Nov 29 21:24:55 dhcp-0-20-34-211-135-63 iscsid: connection1:0 is operational
after recovery (2 attempts)

These repeat precisely every 30 seconds essentially forever, seemingly
independent of activity on the iscsi device.

IO to the device seems to actually work OK (eg dd if=/dev/sdb of=dev/null
bs=64k count=100)

The messages are obviously from the iscsid userland daemon, but booting with an
older kernel 2.6.24.4-64 does not cause these messages.

Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
