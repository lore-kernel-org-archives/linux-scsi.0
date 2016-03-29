From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 29 Mar 2016 03:34:09 +0000
Message-ID: <bug-98171-11613-qJngAYW6nD@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42295 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbcC2DeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 23:34:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7F5720263
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2016 03:34:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2219A2026F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2016 03:34:11 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

amalea0@yahoo.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |amalea0@yahoo.com

--- Comment #8 from amalea0@yahoo.com ---
I am seeing the same error on my Xubuntu 15.10 system at every boot.

[    1.707400] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.707518] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.707679] ata14.00: configured for UDMA/66
[    1.934951] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.934998] ata14.00: irq_stat 0x40000001
[    1.935040] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 1 dma
16640 in Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask
0x3 (HSM violation)
[    1.935089] ata14: hard resetting link
[    2.262449] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.262751] ata14.00: configured for UDMA/66
[    2.262825] ata14: EH complete

SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
controller (rev 11)
Kernel: 4.2.0-34-generic #39-Ubuntu SMP Thu Mar 10 22:13:01 UTC 2016 x86_64
x86_64 x86_64 GNU/Linux (Xubuntu 15.10)
Motherboard: Gigabyte Technology Co., Ltd. GA-970A-UD3P

Hoping to see this issue addressed shortly.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
