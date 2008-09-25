From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Thu, 25 Sep 2008 07:33:55 -0700 (PDT)
Message-ID: <20080925143355.961EA11D10B@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbYIYOeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 10:34:24 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PEXtoV016393
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 07:33:56 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645





------- Comment #4 from nerijus.kislauskas@ktu.lt  2008-09-25 07:33 -------
No, for now we can't test on other platforms. There is only one environment
available.

With Debian kernel 2.6.24-etchnhalf.1-686 it loads perfectly:

Sep 25 13:28:50 ameba kernel: QLogic Fibre Channel HBA Driver
Sep 25 13:28:50 ameba kernel: ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 96
(level, low) -> IRQ 19
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: Found an ISP2312, irq 19,
iobase 0xf89c8000
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: Configuring PCI space...
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: Configure NVRAM
parameters...
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: Verifying loaded RISC
code...
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: Allocated (412 KB) for
firmware dump...
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: LIP reset occured (f7f7).
Sep 25 13:28:50 ameba kernel: scsi2 : qla2xxx
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0:
Sep 25 13:28:50 ameba kernel: QLogic Fibre Channel HBA Driver: 8.02.00-k5
Sep 25 13:28:50 ameba kernel: QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single
Channel
Sep 25 13:28:50 ameba kernel: ISP2312: PCI-X (133 MHz) @ 0000:04:04.0 hdma-,
host#=2, fw=3.03.20 IPX
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: LIP occured (f7f7).
Sep 25 13:28:50 ameba kernel: qla2xxx 0000:04:04.0: LOOP UP detected (2 Gbps).
Sep 25 13:28:51 ameba kernel: scsi 2:0:0:0: Direct-Access     IBM      DS400   
S320    7.01 PQ: 0 ANSI: 4
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] 3440107520 512-byte hardware
sectors (1761335 MB)
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Write Protect is off
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Mode Sense: 8f 00 00 08
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read
cache: enabled, doesn't support DPO or FUA
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] 3440107520 512-byte hardware
sectors (1761335 MB)
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Write Protect is off
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Mode Sense: 8f 00 00 08
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Write cache: disabled, read
cache: enabled, doesn't support DPO or FUA
Sep 25 13:28:51 ameba kernel: sdb: sdb1
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Sep 25 13:28:51 ameba kernel: sd 2:0:0:0: Attached scsi generic sg3 type 0

Main thing is, that we don't want Debian default kernel. We want our compiled
kernel 2.6.24.5 or greater. What I'm doing wrong? If you need some other
information, just give me a note.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
