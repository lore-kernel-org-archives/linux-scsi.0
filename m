From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11645] qla2xxx.ko can't load firmware binary code
Date: Thu, 25 Sep 2008 06:59:29 -0700 (PDT)
Message-ID: <20080925135929.66B9111D109@picon.linux-foundation.org>
References: <bug-11645-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbYIYOAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 10:00:01 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8PDxTi0014164
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2008 06:59:30 -0700
In-Reply-To: <bug-11645-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11645


seokmann.ju@qlogic.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seokmann.ju@qlogic.com




------- Comment #3 from seokmann.ju@qlogic.com  2008-09-25 06:59 -------
As in the comment #1, the issue couldn't be duplicated...
Does this issue happens on certain H/W platform as you specified above: IBM
eServer xSeries 346?
Could you try on other platforms?
Here is snipped of the dmesg which shows the firmware loading done
successfully,
---
...
QLogic Fibre Channel HBA Driver: 8.02.01-k4
ACPI: PCI Interrupt 0000:07:01.0[A] -> GSI 24 (level, low) -> IRQ 24
qla2xxx 0000:07:01.0: Found an ISP2312, irq 24, iobase 0xffffc2000064c000
qla2xxx 0000:07:01.0: Configuring PCI space...
qla2xxx 0000:07:01.0: Configure NVRAM parameters...
qla2xxx 0000:07:01.0: Verifying loaded RISC code...
firmware: requesting ql2300_fw.bin
qla2xxx 0000:07:01.0: Allocated (412 KB) for firmware dump...
scsi4 : qla2xxx
qla2xxx 0000:07:01.0: 
 QLogic Fibre Channel HBA Driver: 8.02.01-k4
  QLogic QLA2342 - 133MHz PCI-X to 2Gb FC, Dual Channel
  ISP2312: PCI-X (133 MHz) @ 0000:07:01.0 hdma+, host#=4, fw=3.03.20 IPX
...
---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
