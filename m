From: brking@us.ibm.com
Subject: [PATCH 02/15] ipr: PCI ID table update
Date: Mon, 21 Feb 2005 15:08:36 -0600
Message-ID: <200502212108.j1LL8biD030873@d03av02.boulder.ibm.com>
Received: from e32.co.us.ibm.com ([32.97.110.130]:33419 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262108AbVBUVIj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:08:39 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL8c5j289064
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:38 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL8c8D126518
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:08:38 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8c1l030922
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:08:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove an adapter from the table that never shipped.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |    3 ---
 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    1 -
 2 files changed, 4 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_remove_adapter drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_remove_adapter	2005-02-21 13:00:46.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:09:43.000000000 -0600
@@ -72,7 +72,6 @@
 #define IPR_SUBS_DEV_ID_5703	0x0278
 #define IPR_SUBS_DEV_ID_572E  0x02D3
 #define IPR_SUBS_DEV_ID_573D  0x02D4
-#define IPR_SUBS_DEV_ID_570F	0x02BD
 #define IPR_SUBS_DEV_ID_571B	0x02BE
 
 #define IPR_NAME				"ipr"
diff -puN drivers/scsi/ipr.c~ipr_remove_adapter drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_remove_adapter	2005-02-21 13:00:46.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:09:43.000000000 -0600
@@ -6004,9 +6004,6 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780,
 		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_570F,
-		0, 0, (kernel_ulong_t)&ipr_chip_cfg[1] },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
_
