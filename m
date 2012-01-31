From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42702] New: MPT2SAS - devices disabled at boot
Date: Tue, 31 Jan 2012 12:10:16 GMT
Message-ID: <bug-42702-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54903 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2AaMKR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2012 07:10:17 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0VCAG8n032236
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2012 12:10:16 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42702

           Summary: MPT2SAS - devices disabled at boot
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.2.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: yohan@proxad.net
                CC: yohan@proxad.net
        Regression: Yes


Created an attachment (id=72244)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72244)
boot log

On a recent server Tyan B7018 motherboard with 2 LSI SAS 9211-4i HOST BUS
ADAPTER, with 4 disks on each ( one with 2 SSD Kingston KC100 + 2 Hitachi SAS
300Go, the other with 4 SSD Kingston KC100) 

On the boot, the mpt2sas removes one of the hard drives :


[   11.435148]  port-0:0: remove: sas_addr(0x4433221100000000)
[   11.435270]  port-0:0: remove: sas_addr(0x4433221100000000), phy(0)
[   11.435709] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
[   11.435839] mpt2sas0: failure at
drivers/scsi/mpt2sas/mpt2sas_transport.c:705/mpt2sas_transport_port_add()!

joined the full log..

It's OK on 2.6.32.55...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
