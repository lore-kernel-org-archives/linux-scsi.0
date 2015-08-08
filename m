From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Sat, 08 Aug 2015 23:58:53 +0000
Message-ID: <bug-98171-11613-4XOxt2LUqe@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992672AbbHHX65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Aug 2015 19:58:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6FB7120786
	for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2015 23:58:56 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CC4EC20782
	for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2015 23:58:54 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

Carlos Guidugli <guidugli@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |guidugli@gmail.com

--- Comment #4 from Carlos Guidugli <guidugli@gmail.com> ---
Hi,

I am also having the same issue with Fedora 22, kernel 4.1.3-200.fc22.x86_64.
Any recommendations?

[    0.828869] ata9: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610100
irq 35
[    0.828873] ata10: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610180
irq 35
[    0.828877] ata11: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610200
irq 35
[    0.828880] ata12: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610280
irq 35
[    0.828884] ata13: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610300
irq 35
[    0.828887] ata14: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610380
irq 35
[    0.828890] ata15: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610400
irq 35
[    0.828894] ata16: SATA max UDMA/133 abar m2048@0xdf610000 port 0xdf610480
irq 35
[    1.116331] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.117021] ata1.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.117026] ata1.00: 11721045168 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.118349] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.119026] ata6.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.119031] ata6.00: 11721045168 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.119341] ata8: SATA link down (SStatus 0 SControl 300)
[    1.119346] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.119377] ata7: SATA link down (SStatus 0 SControl 300)
[    1.119394] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.119413] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.119740] ata6.00: configured for UDMA/133
[    1.120073] ata5.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.120078] ata5.00: 11721045168 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.120798] ata5.00: configured for UDMA/133
[    1.134350] ata14: SATA link down (SStatus 0 SControl 300)
[    1.134376] ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.134401] ata12: SATA link down (SStatus 0 SControl 300)
[    1.134498] ata16.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.134652] ata16.00: configured for UDMA/66
[    1.136354] ata15: SATA link down (SStatus 0 SControl 300)
[    1.136379] ata10: SATA link down (SStatus 0 SControl 300)
[    1.136403] ata11: SATA link down (SStatus 0 SControl 300)
[    1.136425] ata9: SATA link down (SStatus 0 SControl 300)
[    1.136446] ata13: SATA link down (SStatus 0 SControl 300)
[    1.323489] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.327731] ata3.00: HPA detected: current 3907027055, native 3907029168
[    1.327822] ata2.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.327827] ata2.00: 11721045168 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.327839] ata3.00: ATA-8: WDC WD20EARS-00S8B1, 80.00A80, max UDMA/133
[    1.327844] ata3.00: 3907027055 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.327966] ata4.00: HPA detected: current 3907027055, native 3907029168
[    1.328069] ata4.00: ATA-8: WDC WD20EARS-00S8B1, 80.00A80, max UDMA/133
[    1.328073] ata4.00: 3907027055 sectors, multi 16: LBA48 NCQ (depth 31/32),
AA
[    1.328281] ata1.00: configured for UDMA/133
[    1.328518] scsi 0:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82
PQ: 0 ANSI: 5
[    1.328620] ata2.00: configured for UDMA/133
[    1.328965] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.329004] sd 0:0:0:0: [sda] 11721045168 512-byte logical blocks: (6.00
TB/5.45 TiB)
[    1.329009] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.329214] sd 0:0:0:0: [sda] Write Protect is off
[    1.329219] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.329250] scsi 1:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82
PQ: 0 ANSI: 5
[    1.329348] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.329652] sd 1:0:0:0: [sdb] 11721045168 512-byte logical blocks: (6.00
TB/5.45 TiB)
[    1.329657] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.329669] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.329782] sd 1:0:0:0: [sdb] Write Protect is off
[    1.329788] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.329880] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.332247] ata3.00: configured for UDMA/133
[    1.332429] scsi 2:0:0:0: Direct-Access     ATA      WDC WD20EARS-00S 0A80
PQ: 0 ANSI: 5
[    1.332811] sd 2:0:0:0: [sdc] 3907027055 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    1.332851] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.332899] sd 2:0:0:0: [sdc] Write Protect is off
[    1.332905] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.332970] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.332977] ata4.00: configured for UDMA/133
[    1.333102] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EARS-00S 0A80
PQ: 0 ANSI: 5
[    1.333464] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.333469] sd 3:0:0:0: [sdd] 3907027055 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    1.333623] sd 3:0:0:0: [sdd] Write Protect is off
[    1.333628] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.333674] scsi 4:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82
PQ: 0 ANSI: 5
[    1.333677] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.333991] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    1.334035] sd 4:0:0:0: [sde] 11721045168 512-byte logical blocks: (6.00
TB/5.45 TiB)
[    1.334040] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    1.334180] sd 4:0:0:0: [sde] Write Protect is off
[    1.334185] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.334231] scsi 5:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82
PQ: 0 ANSI: 5
[    1.334233] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.334527] sd 5:0:0:0: [sdf] 11721045168 512-byte logical blocks: (6.00
TB/5.45 TiB)
[    1.334532] sd 5:0:0:0: [sdf] 4096-byte physical blocks
[    1.334548] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    1.334647] sd 5:0:0:0: [sdf] Write Protect is off
[    1.334653] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.334768] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.335031] scsi 15:0:0:0: Processor         Marvell  Console          1.01
PQ: 0 ANSI: 5
[    1.346509] ata16.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.346662] ata16.00: irq_stat 0x40000001
[    1.346796] ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma
16640 in
                        Inquiry 12 01 00 00 ff 00res
00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.347344] ata16: hard resetting link
[    1.350686] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.350688] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.354182] sd 5:0:0:0: [sdf] Attached SCSI disk
[    1.355834] sd 4:0:0:0: [sde] Attached SCSI disk
[    1.787613] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.788180] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.832932] ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.883536] ata16.00: configured for UDMA/66
[    1.883621] ata16: EH complete
[    1.883920] scsi 15:0:0:0: Attached scsi generic sg6 type 3

Have two Marvell controllers:
04:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s
Controller (rev 11)
09:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9230 PCIe SATA 6Gb/s
Controller (rev 11)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
