From: Andrew Morton <akpm@osdl.org>
Subject: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Fri, 26 Jan 2007 02:19:07 -0800
Message-ID: <20070126021907.559f23c9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161028AbXAZKTw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 05:19:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, areq@areq.eu.org



Begin forwarded message:

Date: Tue, 23 Jan 2007 17:51:43 +0100
From: areq@areq.eu.org
To: linux-kernel@vger.kernel.org
Subject: SAS1068 PCI-X Fusion-MPT SAS 1000:0055


Hi

I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
pciid: 1000:0055
mptsas form 2.6.20-rc5 don't recognize it ;(

I see that driver support only 1000:0054 and 1000:0058 devices.

./drivers/message/fusion/mptsas.c:      { PCI_VENDOR_ID_LSI_LOGIC,
MPI_MANUFACTPAGE_DEVID_SAS1068,
./drivers/message/fusion/mptsas.c:      { PCI_VENDOR_ID_LSI_LOGIC,
MPI_MANUFACTPAGE_DEVID_SAS1068E,
./drivers/message/fusion/mptbase.c:     else if (pdev->device ==
MPI_MANUFACTPAGE_DEVID_SAS1068) {
./drivers/message/fusion/mptbase.c:     else if (pdev->device ==
MPI_MANUFACTPAGE_DEVID_SAS1068E) {
./drivers/message/fusion/lsi/mpi_cnfg.h:#define
MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
./drivers/message/fusion/lsi/mpi_cnfg.h:#define
MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)

lspci -v:

0d:05.0 SCSI storage controller: LSI Logic / Symbios Logic Unknown
device 0055 (rev 01)
	Subsystem: NEC Corporation Unknown device 8336
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 7
	I/O ports at 3000 [size=256]
	Memory at deb10000 (64-bit, non-prefetchable) [size=16K]
	Memory at deb00000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at 88000000 [disabled] [size=2M]
	Capabilities: [50] Power Management version 2
	Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
	Capabilities: [68] PCI-X non-bridge device
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1


Any solution ?

Cheers,
Areq
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
