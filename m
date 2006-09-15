From: Giuseppe Sacco <giuseppe.sacco@lixper.it>
Subject: Re: question about qlogic QLA2312
Date: Fri, 15 Sep 2006 16:12:17 +0200
Message-ID: <1158329537.8103.57.camel@scarafaggio>
References: <1158307245.8103.12.camel@scarafaggio>
	 <19dce7c30609150656s4397bbfeyba53586cb2105ab7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp21alice.tin.it ([212.216.176.110]:30946 "EHLO
	vsmtp21.tin.it") by vger.kernel.org with ESMTP id S1751493AbWIOOM3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 10:12:29 -0400
In-Reply-To: <19dce7c30609150656s4397bbfeyba53586cb2105ab7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: G Shyam Sundar <callshyam@gmail.com>
Cc: linux-scsi@vger.kernel.org

Il giorno ven, 15/09/2006 alle 19.26 +0530, G Shyam Sundar ha scritto:
> Which version of the driver are you using ?
> Also, what is the version of the firmware ? You can get the version of
> fimware by
> # grep FW_VERSION_STRING in the source directory.
> 
> It will be helpful if you could recompile the driver with
> QL_DEBUG_LEVEL_2 enabled (qla_dbg.h) and recreate the issue.

I used two versions of the driver. The first one is shipped with the
standard kernel from suse: 8.01.04-k (from modinfo). the second one is
from the latest driver I could download from sourceforge.net (project
linux-qla2xxx) and is version 8.01.06b2 (from modinfo).
The new version emit some more information:

qla2xxx_conf: module not supported by Novell, setting U taint flag.
qla2xxx: module not supported by Novell, setting U taint flag.
QLogic Fibre Channel HBA Driver
qla2300: module not supported by Novell, setting U taint flag.
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 177
qla2300 0000:03:02.0: Found an ISP2312, irq 177, iobase
0xffffc20000f70000
qla2300 0000:03:02.0: Configuring PCI space...
qla2300 0000:03:02.0: Configure NVRAM parameters...
qla2300 0000:03:02.0: Verifying loaded RISC code...
qla2300 0000:03:02.0: Mailbox command timeout occured. Scheduling ISP
abort.
qla2300 0000:03:02.0: [ERROR] Failed to load segment 0 of firmware
Mailbox registers:
scsi(7): mbox 0 0x4000 
scsi(7): mbox 1 0xaaaa 
scsi(7): mbox 2 0x5555 
scsi(7): mbox 3 0xaa55 
scsi(7): mbox 4 0x55aa 
scsi(7): mbox 5 0xa5a5 
qla2300 0000:03:02.0: Failed to initialize adapter
qla2300: probe of 0000:03:02.0 failed with error -1

About FW_VERSION_STRING:

lnx01:/usr/src/linux/drivers/scsi/qla2xxx # grep FW_V *
ql2100_fw.c:#define FW_VERSION_STRING "1.19.25"
ql2200_fw.c:#define FW_VERSION_STRING "2.02.08"
ql2300_fw.c:#define FW_VERSION_STRING "3.03.18"
ql2322_fw.c:#define FW_VERSION_STRING "3.03.18"
ql2400_fw.c:#define FW_VERSION_STRING "4.00.16"
ql6312_fw.c:#define FW_VERSION_STRING "3.03.18"
lnx01:/usr/src/linux/drivers/scsi/qla2xxx # 

Thanks,
Giuseppe

