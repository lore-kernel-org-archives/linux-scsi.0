From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 11/29] scsi: 3w-sas: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:10:27 +0530
Message-ID: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/3w-sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index b150e13..e771e86 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1847,7 +1847,7 @@ static int twl_resume(struct pci_dev *pdev)
 #endif
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id twl_pci_tbl[] = {
+static const struct pci_device_id twl_pci_tbl[] = {
 	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9750) },
 	{ }
 };
-- 
2.7.4
