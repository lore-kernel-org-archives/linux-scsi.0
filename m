From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/8] ipr: Increase adapter operational timeout
Date: Thu, 26 Apr 2007 16:00:13 -0500
Message-ID: <200704262101.l3QL1Pgh029740@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59141 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbXDZVB1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:27 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QK0Ehj015934
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 16:00:14 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1PxZ526556
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:26 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1PIP029755
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Increases the adapter operational timeout for some adapters that support
dual controller configurations, since they may take longer to come ready.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dual_initiator_transop drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dual_initiator_transop	2007-04-26 09:17:58.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:58.000000000 -0500
@@ -7617,19 +7617,22 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT},
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E, 0, 0,
+	      IPR_USE_LONG_TRANSOP_TIMEOUT },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575D, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT },
_
