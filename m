From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] New: [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 12 May 2015 22:22:08 +0000
Message-ID: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43137 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbbELWWN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 18:22:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E4600203F7
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 22:22:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4442E203EC
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 22:22:09 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

            Bug ID: 98171
           Summary: [Regression] Marvell SE91xx SATA 3 controllers not
                    recognized correctly
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.15
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: nucrap@hotmail.com
        Regression: No

Created attachment 176571
  --> https://bugzilla.kernel.org/attachment.cgi?id=176571&action=edit
full dmesg of my affected system

Starting with kernel 3.15 Marvell SE91xx SATA 3 controllers are not getting
recognized correctly. At early boot process, users get messages similar to
this:

kernel: ata16: EH complete
kernel: ata16.00: configured for UDMA/66
kernel: ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
kernel: ata16: hard resetting link
kernel: ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
kernel: cdb[0]=0x12: 12 01 00 00 ff 00
kernel: scsi 15:0:0:0: CDB:
kernel: ata16.00: irq_stat 0x40000001
kernel: ata16.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x6
kernel: scsi 15:0:0:0: Processor Marvell 91xx Config 1.01 PQ: 0 ANSI: 5
kernel: ata8: SATA link down (SStatus 0 SControl 300)


There seems to be a high rate of users affected, and so far this issue can be
reproduced with SE9129 and SE9130 chips, see
https://bugs.archlinux.org/task/40776

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
