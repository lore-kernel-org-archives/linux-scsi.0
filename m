From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 02 Feb 2016 08:01:15 +0000
Message-ID: <bug-98171-11613-k50TbY29jc@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58844 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbcBBIBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 03:01:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1B52C20266
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 08:01:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F3E172027D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 08:01:16 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

jrickman@myamigos.us changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jrickman@myamigos.us

--- Comment #6 from jrickman@myamigos.us ---
I see almost the exact same error across multiple (qty 4, all the same HW
configs) Supermicro X10SBA motherboards that I have.

Jan 30 06:52:52 tank2 kernel: [    1.689428] ata12.00: exception Emask 0x0 SAct
0x0 SErr 0x0 action 0x6
Jan 30 06:52:52 tank2 kernel: [    1.689430] ata12.00: irq_stat 0x40000001
Jan 30 06:52:52 tank2 kernel: [    1.689440] ata12.00: cmd
a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
Jan 30 06:52:52 tank2 kernel: [    1.689440]          opcode=0x12 12 01 00 00
ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
Jan 30 06:52:52 tank2 kernel: [    1.689446] ata12: hard resetting link

These motherboards use the Marvell 9230 chip to add 4 SATA ports to the 2 SATA
ports provided by the BayTrail SoC.

I can sometimes recreate this error when placing the filesystem under heavy
load. In this case it is a multi-terabyte ZFS "tank" and "zpool" is doing a
"scrub".

Gentoo Linux running gentoo-sources-4.1.15-r1

I do not remember when I first started to see this error appear.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
