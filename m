From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191171] New: megaraid_sas fails to recognize RAID on startup,
 worked with version 4.1.20
Date: Mon, 26 Dec 2016 08:05:54 +0000
Message-ID: <bug-191171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbcLZIF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Dec 2016 03:05:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 46B91203E3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 08:05:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 0F97420425
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 08:05:55 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191171

            Bug ID: 191171
           Summary: megaraid_sas fails to recognize RAID on startup,
                    worked with version 4.1.20
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.1.36
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: blancpa@worldcom.ch
        Regression: No

Created attachment 248561
  --> https://bugzilla.kernel.org/attachment.cgi?id=248561&action=edit
Boot with kernel 4.1.36 which fails to see RAID

After a kernel update made by openSuSE Leap 42.1 on-line update and a reboot,
the kernel didn't find anymore the RAID.
Rebooting with previous kernel (4.1.20) fixed the problem.
See attached journalctl logs (fail & working)

Hardware environment:
- Intel Xeon E5-2650 v2
- Intel C602 Patsburg-A chipset
- 128 GB RAM
- LSI MegaRAID 9261-8i SAS-2 RAID Controller, PCIe 2.0 (512Mb RAM)

OS:
- openSuSE Leap 42.1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
