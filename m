From: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Subject: Re: question about qlogic QLA2312
Date: Fri, 15 Sep 2006 17:54:02 +0200
Message-ID: <1158335642.8103.70.camel@scarafaggio>
References: <1158307245.8103.12.camel@scarafaggio>
	 <19dce7c30609150656s4397bbfeyba53586cb2105ab7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+R9nmNjR2/qlqU85AKBz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp2.tin.it ([212.216.176.222]:22443 "EHLO vsmtp2.tin.it")
	by vger.kernel.org with ESMTP id S932108AbWIOPx6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 11:53:58 -0400
Received: from casa (82.56.149.55) by vsmtp2.tin.it (7.2.072.1) (authenticated as giuseppe.sacco17@tin.it)
        id 4506B54A001DF9F1 for linux-scsi@vger.kernel.org; Fri, 15 Sep 2006 17:53:56 +0200
Received: from [81.30.2.2] (helo=[192.168.12.252])
	by casa with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <giuseppe@eppesuigoccas.homedns.org>)
	id 1GOG0r-0003Cy-Vz
	for linux-scsi@vger.kernel.org; Fri, 15 Sep 2006 17:53:58 +0200
In-Reply-To: <19dce7c30609150656s4397bbfeyba53586cb2105ab7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-+R9nmNjR2/qlqU85AKBz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Il giorno ven, 15/09/2006 alle 19.26 +0530, G Shyam Sundar ha scritto:
> Which version of the driver are you using ?
> Also, what is the version of the firmware ? You can get the version of
> fimware by
> # grep FW_VERSION_STRING in the source directory.
> 
> It will be helpful if you could recompile the driver with
> QL_DEBUG_LEVEL_2 enabled (qla_dbg.h) and recreate the issue.

Here it is, with some more debug levels (1,2,3, and 7)



--=-+R9nmNjR2/qlqU85AKBz
Content-Disposition: inline; filename=qla2xxx-8.01.06b2-debug.log
Content-Type: text/x-log; name=qla2xxx-8.01.06b2-debug.log; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sep 15 17:49:01 lnx01 kernel: qla2xxx_conf: module not supported by Novell, setting U taint flag.
Sep 15 17:49:01 lnx01 kernel: qla2xxx: module not supported by Novell, setting U taint flag.
Sep 15 17:49:01 lnx01 kernel: QLogic Fibre Channel HBA Driver
Sep 15 17:49:01 lnx01 kernel: qla2300: module not supported by Novell, setting U taint flag.
Sep 15 17:49:01 lnx01 kernel: ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 177
Sep 15 17:49:01 lnx01 kernel: qla2300 0000:03:02.0: Found an ISP2312, irq 177, iobase 0xffffc20000f72000
Sep 15 17:49:01 lnx01 kernel: qla2300 0000:03:02.0: Configuring PCI space...
Sep 15 17:49:01 lnx01 kernel: qla2x00_get_flash_version(): read BIOS 1.47.
Sep 15 17:49:01 lnx01 kernel: qla2300 0000:03:02.0: Configure NVRAM parameters...
Sep 15 17:49:01 lnx01 kernel: qla2300 0000:03:02.0: Verifying loaded RISC code...
Sep 15 17:49:01 lnx01 kernel: scsi(11): Testing device at ffffc20000f72000.
Sep 15 17:49:01 lnx01 kernel: scsi(11): Reset register cleared by chip reset
Sep 15 17:49:01 lnx01 kernel: scsi(11): Checking product ID of chip
Sep 15 17:49:01 lnx01 kernel: scsi(11): Checking mailboxes.
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): Loaded MBX registers (displayed in bytes) = 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: 06  00  aa  aa  55  55  55  aa  aa  55  a5  a5  5a  5a  25  25
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: 20  50  f7  00  00  00  00  00  08  00  00  80  00  00  00  00
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: 53  49  f7  00  00  00  00  00  
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): I/O address = ffffc20000f72080.
Sep 15 17:49:01 lnx01 kernel: Mailbox registers:
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 0 0x0000 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 1 0x4953 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 2 0x5020 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 3 0x2020 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 4 0x0002 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 5 0x0004 
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): cmd=6 POLLING MODE.
Sep 15 17:49:01 lnx01 kernel: qla2x00_mbx_completion(11): Got mailbox completion. cmd=6.
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): cmd 6 completed.
Sep 15 17:49:01 lnx01 kernel: scsi(11): Loading risc segment@ addr ffffffff8836fc40, number of bytes 0x8000, offset 0x800.
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): Loaded MBX registers (displayed in bytes) = 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: 09  00  00  08  78  fc  00  00  00  80  00  00  00  00  01  00
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: b8  3a  da  f3  01  81  ff  ff  f8  39  da  f3  01  81  ff  ff
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Sep 15 17:49:01 lnx01 kernel: --------------------------------------------------------------
Sep 15 17:49:01 lnx01 kernel: 80  84  03  05  02  81  ff  ff  
Sep 15 17:49:01 lnx01 kernel: 
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): I/O address = ffffc20000f72080.
Sep 15 17:49:01 lnx01 kernel: Mailbox registers:
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 0 0x4000 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 1 0xaaaa 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 2 0x5555 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 3 0xaa55 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 4 0x55aa 
Sep 15 17:49:01 lnx01 kernel: scsi(11): mbox 5 0xa5a5 
Sep 15 17:49:01 lnx01 kernel: qla2x00_mailbox_command(11): cmd=9 POLLING MODE.
Sep 15 17:49:31 lnx01 kernel: qla2x00_mailbox_command(11): **** MB Command Timeout for cmd 9 ****
Sep 15 17:49:31 lnx01 kernel: qla2x00_mailbox_command(11): icontrol=0 jiffies=100055e49
Sep 15 17:49:31 lnx01 kernel: qla2x00_mailbox_command(11): *** mailbox[0] = 0x4000 ***
Sep 15 17:49:31 lnx01 kernel: Mailbox registers:
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 0 0x4000 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 1 0xaaaa 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 2 0x5555 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 3 0xaa55 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 4 0x55aa 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 5 0xa5a5 
Sep 15 17:49:31 lnx01 kernel: qla2300 0000:03:02.0: Mailbox command timeout occured. Scheduling ISP abort.
Sep 15 17:49:31 lnx01 kernel: qla2300 0000:03:02.0: [ERROR] Failed to load segment 0 of firmware
Sep 15 17:49:31 lnx01 kernel: Mailbox registers:
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 0 0x4000 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 1 0xaaaa 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 2 0x5555 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 3 0xaa55 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 4 0x55aa 
Sep 15 17:49:31 lnx01 kernel: scsi(11): mbox 5 0xa5a5 
Sep 15 17:49:31 lnx01 kernel: qla2300 0000:03:02.0: Failed to initialize adapter
Sep 15 17:49:31 lnx01 kernel: qla2300: probe of 0000:03:02.0 failed with error -1

--=-+R9nmNjR2/qlqU85AKBz--

