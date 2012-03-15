From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42939] New: hv_storvsc - write cache enabled by default and
 cannot be disabled
Date: Thu, 15 Mar 2012 21:56:00 GMT
Message-ID: <bug-42939-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:59944 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2COV4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 17:56:01 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2FLu0G1013479
	for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 21:56:00 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42939

           Summary: hv_storvsc - write cache enabled by default and cannot
                    be disabled
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: bugzilla-kernel-org-sux2k0@mstier.de
        Regression: No


dmesg output:

[    8.080401] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
supports DPO and FUA

Question: how safe is my (database) data in the case of a host machine crash or
a VM crash?

There is no battery-backed writecache installed in the host, just some cheap
and slow SATA disks.

Another curiosity occurs when running the fio iometer benchmark on the same
machine: it gives me 5.000 to 6.000 I/O random access operations per second
when using the para-virt hv_storvsc driver, but only the expected 200 I/O ops
when using ata_piix via emulation.The kernel in question is version 3.2.11.

There doesn't seem to be any way to disable the para-virt device's write-cache.

Kernel version is mainline 3.2.11.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
