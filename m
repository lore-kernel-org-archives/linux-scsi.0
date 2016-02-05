From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Fri, 05 Feb 2016 16:20:44 +0000
Message-ID: <bug-98171-11613-3LND0IAztR@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbcBEQUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Feb 2016 11:20:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6529A203A1
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:20:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 989A22039C
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:20:45 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

--- Comment #7 from Clay Harris <bugs@claycon.org> ---
I'm seeing the following:

ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata16.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
ata16.00: configured for UDMA/66
ata16.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x6
ata16.00: irq_stat 0x40000001
ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 1 dma 16640 in
Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM
violation)
ata16: hard resetting link

Controller is:
a:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9128 PCIe SATA 6 Gb/s
RAID controller with HyperDuo (rev 11) (prog-if 01 [AHCI 1.0])
Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard

Linux 4.3.4-300.fc23.x86_64

I see this error most every boot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
