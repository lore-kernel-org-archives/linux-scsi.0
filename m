From: Giuseppe Sacco <giuseppe.sacco@lixper.it>
Subject: question about qlogic QLA2312
Date: Fri, 15 Sep 2006 10:00:45 +0200
Message-ID: <1158307245.8103.12.camel@scarafaggio>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp4.tin.it ([212.216.176.224]:29663 "EHLO vsmtp4.tin.it")
	by vger.kernel.org with ESMTP id S1750707AbWIOIAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 04:00:39 -0400
Received: from casa (82.56.149.55) by vsmtp4.tin.it (7.2.072.1) (authenticated as giuseppe.sacco17@tin.it)
        id 450948360010012E for linux-scsi@vger.kernel.org; Fri, 15 Sep 2006 10:00:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
I installed a new machine with this SCSI controller 

03:02.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev
02)

The problem is that firmware cannot be loaded on this board. When
loading the qla2xxx driver, I get these messages:

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 177
qla2xxx 0000:03:02.0: Found an ISP2312, irq 177, iobase
0xffffc20000f70000
qla2xxx 0000:03:02.0: Configuring PCI space...
qla2xxx 0000:03:02.0: Configure NVRAM parameters...
qla2xxx 0000:03:02.0: Verifying loaded RISC code...
qla2xxx 0000:03:02.0: Mailbox command timeout occured. Scheduling ISP
abort.
qla2xxx 0000:03:02.0: [ERROR] Failed to load segment 0 of firmware
qla2xxx 0000:03:02.0: Failed to initialize adapter
Trying to free free IRQ177

Browsing the archives of linux-scsi I found a solution[1]: a patch
missing from the suse linux kernel. Sadly this was about an old versione
of the kernel, while the current one already include it.

I am using kernel 2.6.16.21.

Any idea about what the problem could be?

Thanks,
Giuseppe

[1]http://www.spinics.net/lists/linux-scsi/msg06713.html

