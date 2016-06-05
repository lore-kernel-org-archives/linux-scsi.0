From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118621] After upgrading from ubuntu 15.10 to 16.04 CD-R's won't
 mount, others mount just fine
Date: Sun, 05 Jun 2016 14:17:22 +0000
Message-ID: <bug-118621-11613-RLQmfQigch@https.bugzilla.kernel.org/>
References: <bug-118621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55806 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbcFEOR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jun 2016 10:17:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D1BF32017D
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jun 2016 14:17:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 21CDF201BC
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jun 2016 14:17:23 +0000 (UTC)
In-Reply-To: <bug-118621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=118621

albapompeo@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |albapompeo@gmail.com

--- Comment #1 from albapompeo@gmail.com ---
I can confirm this issue (with Alpine Linux - Kernel 4.4.11-0)

[    9.698776] sr 1:0:0:0: [sr0] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
[    9.698784] sr 1:0:0:0: [sr0] tag#12 Sense Key : 0x4 [current] 
[    9.698788] sr 1:0:0:0: [sr0] tag#12 ASC=0x3e ASCQ=0x2 
[    9.698795] sr 1:0:0:0: [sr0] tag#12 CDB: opcode=0x28 28 00 00 00 ae 96 00
00 02 00
[    9.698798] blk_update_request: I/O error, dev sr0, sector 178776
[   16.221746] sr 1:0:0:0: [sr0] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
[   16.221753] sr 1:0:0:0: [sr0] tag#13 Sense Key : 0x4 [current] 
[   16.221758] sr 1:0:0:0: [sr0] tag#13 ASC=0x3e ASCQ=0x2 
[   16.221763] sr 1:0:0:0: [sr0] tag#13 CDB: opcode=0x28 28 00 00 00 ae 96 00
00 02 00
[   16.221766] blk_update_request: I/O error, dev sr0, sector 178776
[   16.221770] Buffer I/O error on dev sr0, logical block 22347, async page
read
[   19.491207] random: nonblocking pool is initialized
[   26.327844] sr 1:0:0:0: [sr0] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
[   26.327852] sr 1:0:0:0: [sr0] tag#12 Sense Key : 0x4 [current] 
[   26.327856] sr 1:0:0:0: [sr0] tag#12 ASC=0x3e ASCQ=0x2 
[   26.327863] sr 1:0:0:0: [sr0] tag#12 CDB: opcode=0x28 28 00 00 00 ae 96 00
00 02 00
[   26.327867] blk_update_request: I/O error, dev sr0, sector 178776
[   32.870851] sr 1:0:0:0: [sr0] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
[   32.870858] sr 1:0:0:0: [sr0] tag#13 Sense Key : 0x4 [current] 
[   32.870863] sr 1:0:0:0: [sr0] tag#13 ASC=0x3e ASCQ=0x2 
[   32.870868] sr 1:0:0:0: [sr0] tag#13 CDB: opcode=0x28 28 00 00 00 ae 96 00
00 02 00
[   32.870871] blk_update_request: I/O error, dev sr0, sector 178776
[   32.870876] Buffer I/O error on dev sr0, logical block 22347, async page
read

-- 
You are receiving this mail because:
You are the assignee for the bug.
