From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: Qla2300 driver broken on 2.6.12-git5?
Date: Thu, 23 Jun 2005 12:16:36 -0700
Message-ID: <200506231916.j5NJGag23487@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr23.intel.com ([143.183.121.15]:49358 "EHLO
	scsfmr003.sc.intel.com") by vger.kernel.org with ESMTP
	id S262705AbVFWTQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 15:16:39 -0400
Received: from scsfmr100.sc.intel.com (scsfmr100.sc.intel.com [10.3.253.9])
	by scsfmr003.sc.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j5NJGamx024418
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2005 19:16:36 GMT
Received: from unix-os.sc.intel.com (unix-os.sc.intel.com [172.25.110.7])
	by scsfmr100.sc.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with ESMTP id j5NJIXdp004096
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2005 19:18:33 GMT
Received: from kwchenmobl1 (kwchen-mobl1.amr.corp.intel.com [143.183.251.71])
	by unix-os.sc.intel.com (8.11.6/8.11.2) with ESMTP id j5NJGag23487
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2005 12:16:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I tried to boot 2.6.12-git5, kernel panic'ed on qla2300 initialization.
Is there a patch already out there to fix the problem?

QLogic Fibre Channel HBA Driver
GSI 76 (level, low) -> CPU 1 (0xc018) vector 51
ACPI: PCI Interrupt 0000:0b:02.0[A] -> GSI 76 (level, low) -> IRQ 51
qla2300 0000:0b:02.0: Found an ISP2300, irq 51, iobase 0xc0000000e2ff0000
qla2300 0000:0b:02.0: Configuring PCI space...
qla2300 0000:0b:02.0: Configure NVRAM parameters...
qla2300 0000:0b:02.0: Verifying loaded RISC code...
qla2300 0000:0b:02.0: LIP reset occured (f7f7).
qla2300 0000:0b:02.0: Waiting for LIP to complete...
qla2300 0000:0b:02.0: LIP occured (f7f7).
qla2300 0000:0b:02.0: Failed to initialize adapter
Unable to handle kernel NULL pointer dereference (address 00000000000001d0)
swapper[1]: Oops 11012296146944 [1]


