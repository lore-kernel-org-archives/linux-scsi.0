From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Tue, 16 May 2017 06:14:32 +0000
Message-ID: <bug-195285-11613-wG2TJmmBkQ@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55912 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751011AbdEPGOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 May 2017 02:14:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4E5F0289F2
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 06:14:51 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #3 from Anthony (anthony.bloodoff@gmail.com) ---
Two cards installed in new test machine: QLE2462 and QLE2560
qle2560 spam with errors (without starting a target)

scsi host8: qla2xxx
qla2xxx [0000:05:00.1]-00fb:8: QLogic QLE2462 - PCI-Express Dual Channel 4Gb
Fibre Channel HBA.
qla2xxx [0000:05:00.1]-00fc:8: ISP2432: PCIe (2.5GT/s x4) @ 0000:05:00.1 hdma+
host#=8 fw=8.06.00 (9496).
qla2xxx [0000:09:00.0]-001a: : MSI-X vector count: 32.
qla2xxx [0000:09:00.0]-001d: : Found an ISP2532 irq 16 iobase
0xffffba4886335000.
qla2xxx [0000:09:00.0]-504b:9: RISC paused -- HCCR=40, Dumping firmware.
qla2xxx [0000:09:00.0]-d001:9: Firmware dump saved to temp buffer
(9/ffffba488c001000), dump status flags (0x3f).
qla2xxx [0000:09:00.0]-1005:9: Cmd 0x59 aborted with timeout since ISP Abort is
pending
scsi host9: qla2xxx
qla2xxx [0000:09:00.0]-00fb:9: QLogic QLE2560 - PCI-Express Single Channel 8Gb
Fibre Channel HBA.
qla2xxx [0000:09:00.0]-00fc:9: ISP2532: PCIe (5.0GT/s x8) @ 0000:09:00.0 hdma+
host#=9 fw=8.06.00 (90d5).
qla2xxx [0000:05:00.0]-500a:7: LOOP UP detected (4 Gbps).
qla2xxx [0000:05:00.1]-500a:8: LOOP UP detected (4 Gbps).
qla2xxx [0000:09:00.0]-00af:9: Performing ISP error recovery -
ha=ffff98315ee30000.
qla2xxx [0000:09:00.0]-504b:9: RISC paused -- HCCR=40, Dumping firmware.
qla2xxx [0000:09:00.0]-d009:9: Firmware has been previously dumped
(ffffba488c001000) -- ignoring request.
qla2xxx [0000:09:00.0]-504b:9: RISC paused -- HCCR=40, Dumping firmware.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
