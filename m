From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78281] New: aacraid: swiotlb buffer is full (sz: 255 bytes)
Date: Wed, 18 Jun 2014 22:53:23 +0000
Message-ID: <bug-78281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaFRWx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2014 18:53:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9B32E2038C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2014 22:53:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B67DB20383
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2014 22:53:23 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=78281

            Bug ID: 78281
           Summary: aacraid: swiotlb buffer is full (sz: 255 bytes)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.14-0.bpo.1-amd64 #1 SMP Debian 3.14.5-1~bpo70+1
                    (2014-06-05) x86_64 GNU/Linux
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: lee@yun.yagibdah.de
        Regression: No

IBM x3650 7979 w/ ServeRaid 8k, updated to latest BIOS and firmware
Debian Wheezy with latest Debian kernel from Debian backports
running under xen-hypervisor


dom0 goes down with a stream of messages "aacraid 0000:04:00.0: swiotlb buffer
is full (sz: 255 bytes)"

The number of bytes varies.


04:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
        Subsystem: IBM ServeRAID 8k/8k-l8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at c9e00000 (64-bit, non-prefetchable) [size=2M]
        Region 2: Memory at c7fe0000 (64-bit, prefetchable) [size=128K]
        Region 4: I/O ports at 5000 [size=256]
        [virtual] Expansion ROM at c7f00000 [disabled] [size=32K]
        Capabilities: <access denied>
        Kernel driver in use: aacraid


The 3.2 Debian kernel was not stable, either.  I couldn't see the debugging
output, though.

I'll try 3.15.1 from kernel.org and see if there's any difference.  Please let
me know what information you might need or if I can do something to get better
debugging info.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
