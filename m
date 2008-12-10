From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12190] New: kernel 2.6 PPC64 - IPS driver failure with IBM ServeRAID 4H
Date: Wed, 10 Dec 2008 02:33:53 -0800 (PST)
Message-ID: <bug-12190-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYLJKdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 05:33:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBAAXrAE003363
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 02:33:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12190

           Summary: kernel 2.6 PPC64 - IPS driver failure with IBM ServeRAID
                    4H
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.18-6-powerpc64
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: bozy@pisem.net
                CC: bozy@pisem.net


Latest working kernel version: NONE
Earliest failing kernel version: 2.6.18-6-powerpc64 #1 SMP Sat Jan 26 17:58:12
UTC 2008 ppc64 unknown
Distribution: Debian Etch (4.0)
Hardware Environment: IBM 7025-6F0
Software Environment: Installing Debian 4.0 (Etch), latest stable release as of
10-DEC-2008
Problem Description:
IPS driver fails to load, following is recorded in dmesg:
---
PCI: Enabling device: (0001:2a:01.0), cmd 143
ips 0001:2a:01.0: Unable to initialize controller
ips: probe of 0001:2a:01.0 failed with error -1
ips 0001:2a:01.0: Couldn't allocate IO space 18ec00 len 256.
ips: probe of 0001:2a:01.0 failed with error -1
---
lspci -v output:
---
0001:2a:01.0 RAID bus controller: IBM SCSI RAID Adapter [ServeRAID] (rev 10)
Subsystem: IBM Unknown device 022e
Flags: medium devsel, IRQ 42
I/O ports at fefff8ec00 [size=256]
Memory at ff38000000 (32-bit, non-prefetchable) [size=1M]
Expansion ROM at ff38100000 [disabled] [size=32K]
Capabilities: [40] Vital Product Data
Capabilities: [48] Power Management version 2
---
Steps to reproduce:
Load IPS driver (modprobe ips) on either IBM 7025-6F0 (64-bit arch & kernel) or
IBM 7025-F50 (32-bit arch & kernel) machine.

Note: this bug has been recorded at Debian Bugzilla with bug#375092


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
