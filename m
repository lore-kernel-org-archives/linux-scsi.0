From: "tester7 A." <benew666@hotmail.com>
Subject: QLA2300, Infortrand and LBD?
Date: Sun, 20 Jun 2004 17:43:28 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY22-F23Fi1dJRdjd8000a113d@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay22-f23.bay22.hotmail.com ([64.4.16.73]:34566 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S265840AbUFTIng
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 04:43:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tech@storageone.co.kr

Hi,

I am using Kernel 2.6.7 and I want to use the Large Block Device for the 
3.5TB Infortrend FC-Sata RAID.

My H/W is QLA2300, Infortrend A16F-G1A2 FC-SATA RAID, and a Intel Xeon SMP 
box.

I also turned on the "LBD support" in the kernel config.

But the kernel recognize only 1.5TB out of 3.5TB, even though it is one 
volume with 3.5TB.

qla2300 0000:03:09.0: Found an ISP2300, irq 27, iobase 0xf8c5c000
qla2300 0000:03:09.0: Configuring PCI space...
qla2300 0000:03:09.0: Configure NVRAM parameters...
qla2300 0000:03:09.0: Verifying loaded RISC code...
qla2300 0000:03:09.0: Waiting for LIP to complete...
qla2300 0000:03:09.0: LIP reset occured (f8f7).
qla2300 0000:03:09.0: LIP occured (f8f7).
qla2300 0000:03:09.0: LOOP UP detected (2 Gbps).
qla2300 0000:03:09.0: Topology - (Loop), Host Loop address 0x0
scsi3 : qla2xxx
qla2300 0000:03:09.0:
QLogic Fibre Channel HBA Driver: 8.00.00b12-k
  QLogic QLA2310 -
  ISP2300: PCI-X (66 MHz) @ 0000:03:09.0 hdma-, host#=3, fw=3.02.28 IPX
  Vendor: IFT       Model: A16F-G1A2         Rev: 334B
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:03:09.0: scsi(3:0:0:0): Enabled tagged queuing, queue depth 32.
SCSI device sdc: 3022966784 512-byte hdwr sectors (1547759 MB)
SCSI device sdc: drive cache: write through
sdc: sdc1
Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0

Do I need to do something about qla2300 driver or else, in order to make the 
kernel recognize 3.5TB?

Please help me. Any help will be appreciated.

Thanks in advance.

_________________________________________________________________
MSN Toolbar provides one-click access to Hotmail from any Web page – FREE 
download! http://toolbar.msn.click-url.com/go/onm00200413ave/direct/01/

