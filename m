From: "christophe.varoqui" <christophe.varoqui@free.fr>
Subject: Re: Removing the qlogicfc driver
Date: Sat, 17 Jan 2004 13:57:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401171357.54813.christophe.varoqui@free.fr>
References: <B179AE41C1147041AA1121F44614F0B0598E38@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.wanadoo.fr ([193.252.22.29]:36604 "EHLO
	mwinf0203.wanadoo.fr") by vger.kernel.org with ESMTP
	id S266033AbUAQM7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 07:59:36 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E38@AVEXCH02.qlogic.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Friday 16 January 2004 23:57, Andrew Vasquez wrote:

> Hmm, from the output of proc/scsi/qla* your two 2200 don't appear to
> be recognizing any devices after the SNS scan:
> Could you enable enable a couple of debug swtiches:
> Andrew Vasquez

Yes, here it is :

qla2200 0000:03:01.0: Found an ISP2200, irq 20, iobase 0xf8848000
qla2200 0000:03:01.0: Configuring PCI space...
qla2200 0000:03:01.0: Configure NVRAM parameters...
qla2200 0000:03:01.0: Verifying loaded RISC code...
scsi(4): **** Load RISC code ****
scsi(4): Verifying Checksum of loaded RISC code.
scsi(4): Checksum OK, start firmware.
scsi(4): Issue init firmware.
qla2200 0000:03:01.0: Waiting for LIP to complete...
scsi(4): Asynchronous P2P MODE received.
scsi(4): Asynchronous P2P MODE received.
scsi(4): Asynchronous LOOP UP (1 Gbps).
qla2200 0000:03:01.0: LOOP UP detected (1 Gbps).
scsi(4): Asynchronous PORT UPDATE.
scsi(4): Port database changed 0000 4000.
scsi(4): F/W Ready - OK
scsi(4): fw_state=3 curr time=4926cc4.
qla2200 0000:03:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80040
scsi(4): RSCN queue entry[0] = [00/000000].
scsi(4): device_resync: rscn overflow.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
0x102scsi(4): RFT_ID issue IOCB failed (258).
scsi(4): Register FC-4 TYPE failed.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
0x102scsi(4): RFF_ID issue IOCB failed (258).
scsi(4): Register FC-4 Features failed.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
0x102scsi(4): RNN_ID issue IOCB failed (258).
scsi(4): Register Node Name failed.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
0x102scsi(4): GID_PT issue IOCB failed (258).
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
0x102scsi(4): GA_NXT issue IOCB failed (258).
scsi(4): Configure fabric error exit: rval=258
scsi(4): LOOP READY
DEBUG: detect hba 4 at address = e45201d4
scsi4 : qla2xxx
qla2200 0000:03:01.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b9-debug
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0000:03:01.0 hdma-, host#=4, fw=2.02.06 TP
qla2200 0000:06:01.0: Found an ISP2200, irq 24, iobase 0xf884a000
qla2200 0000:06:01.0: Configuring PCI space...
qla2200 0000:06:01.0: Configure NVRAM parameters...
qla2200 0000:06:01.0: Verifying loaded RISC code...
scsi(5): **** Load RISC code ****
scsi(4): Asynchronous PORT UPDATE ignored.
scsi(5): Verifying Checksum of loaded RISC code.
scsi(5): Checksum OK, start firmware.
scsi(5): Issue init firmware.
qla2200 0000:06:01.0: Waiting for LIP to complete...
scsi(5): Asynchronous LIP RESET (f7f7).
qla2200 0000:06:01.0: LIP reset occured (f7f7).
scsi(5): Asynchronous P2P MODE received.
scsi(5): Asynchronous LOOP UP (1 Gbps).
qla2200 0000:06:01.0: LOOP UP detected (1 Gbps).
scsi(5): Asynchronous PORT UPDATE.
scsi(5): Port database changed 0000 4000.
scsi(5): F/W Ready - OK
scsi(5): fw_state=3 curr time=492762e.
qla2200 0000:06:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(5): Configure loop -- dpc flags =0x80040
scsi(5): RSCN queue entry[0] = [00/000000].
scsi(5): device_resync: rscn overflow.
qla2x00_mailbox_command(5): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(5): failed rval 0x102qla2x00_issue_iocb(5): failed rval 
0x102scsi(5): RFT_ID issue IOCB failed (258).
scsi(5): Register FC-4 TYPE failed.
qla2x00_mailbox_command(5): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(5): failed rval 0x102qla2x00_issue_iocb(5): failed rval 
0x102scsi(5): RFF_ID issue IOCB failed (258).
scsi(5): Register FC-4 Features failed.
qla2x00_mailbox_command(5): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(5): failed rval 0x102qla2x00_issue_iocb(5): failed rval 
0x102scsi(5): RNN_ID issue IOCB failed (258).
scsi(5): Register Node Name failed.
qla2x00_mailbox_command(5): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(5): failed rval 0x102qla2x00_issue_iocb(5): failed rval 
0x102scsi(5): GID_PT issue IOCB failed (258).
qla2x00_mailbox_command(5): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
****
qla2x00_issue_iocb(5): failed rval 0x102qla2x00_issue_iocb(5): failed rval 
0x102scsi(5): GA_NXT issue IOCB failed (258).
scsi(5): Configure fabric error exit: rval=258
scsi(5): LOOP READY
DEBUG: detect hba 5 at address = dd9741d4
scsi5 : qla2xxx
qla2200 0000:06:01.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b9-debug
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0000:06:01.0 hdma-, host#=5, fw=2.02.06 TP
scsi(5): Asynchronous PORT UPDATE ignored.
scsi(5): Asynchronous PORT UPDATE ignored.
scsi(5): Asynchronous PORT UPDATE ignored.


regards,
cvaroqui
