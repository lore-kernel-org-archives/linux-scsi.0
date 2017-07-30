From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 29/29] scsi: 3w-xxxx: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:13:55 +0530
Message-ID: <1501404235-9105-9-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35275 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754170AbdG3Iot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jul 2017 04:44:49 -0400
In-Reply-To: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 33261b6..e0b079d 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2384,7 +2384,7 @@ static void tw_remove(struct pci_dev *pdev)
 } /* End tw_remove() */
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id tw_pci_tbl[] = {
+static const struct pci_device_id tw_pci_tbl[] = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
-- 
2.7.4
