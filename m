From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] qla2xxx - perform proper SNS scans with ISP2200 HBAs.
Date: Fri, 23 Jan 2004 11:18:17 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040123001817.GG11236@krispykreme>
References: <B179AE41C1147041AA1121F44614F0B0598E53@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:59030 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266482AbUAWATa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 19:19:30 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E53@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


Hi Andrew,

> The 2200 firmware doesn't support the MS IOCB interface the driver 
> uses to issue CT commands to the SNS.  Basically, I had to 
> forward-port some code from the 6.x driver to get the SNS calls 
> to go through.  I've had several machines (mixture of 2200s/
> 2300s/others with loop and fabric connections) running with this
> patch for the past few days.

I applied your patch to 2.6.2-rc1 and tested it on my ppc64 box. Looks
like its not happy :) Maybe a 64bit or big endian issue?

Anton

QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver (c00000000063a028)
PCI: Enabling device: (0003:41:01.0), cmd 143
qla2200 0003:41:01.0: Found an ISP2200, irq 183, iobase 0xa000000080020000
qla2200 0003:41:01.0: Configuring PCI space...
qla2200 0003:41:01.0: Configure NVRAM parameters...
qla2200 0003:41:01.0: Verifying loaded RISC code...
qla2200 0003:41:01.0: LIP reset occured (0).
qla2200 0003:41:01.0: Waiting for LIP to complete...
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi0 : qla2xxx
qla2200 0003:41:01.0:
 QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0003:41:01.0 hdma-, host#=0, fw=2.02.06 TP
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (0).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid ISP SCSI completion handle
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
