From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc2-mm1 -- QLogics ISP1020 gone missing
Date: Thu, 15 Nov 2007 10:50:15 +0000
Message-ID: <20071115105015.GC2513@shadowen.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hellhawk.shadowen.org ([80.68.90.175]:4649 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbXKOKuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 05:50:22 -0500
Content-Disposition: inline
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

All of our machines with QLogics ISP1020 cards seem to have lost them on
boot with 2.6.24-rc1-mm1+hotfixes.

# lspci
0000:00:0a.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide
SCSI (rev 05)

# lspci -n
0000:00:0a.0 0100: 1077:1020 (rev 05)

# lspci -v -v
0000:00:0a.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
        Subsystem: QLogic Corp.: Unknown device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 248, Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 23
        Region 0: I/O ports at fc00 [size=256]
        Region 1: Memory at fa000000 (32-bit, non-prefetchable) [size=4K]

These devices are normally reported as below, which I note is not as a
1020?

qla1280: QLA1040 found on PCI bus 0, dev 10
scsi(0:0): Resetting SCSI BUS
scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
	Firmware version:  7.65.06, Driver version 3.26

There is nothing major around in the area so I am somewhat bemused.

-apw
