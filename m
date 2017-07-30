From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 19/29] scsi: megaraid: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:10:35 +0530
Message-ID: <1501404036-9005-9-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3c63c29..17012c8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4652,7 +4652,7 @@ megaraid_shutdown(struct pci_dev *pdev)
 	__megaraid_shutdown(adapter);
 }
 
-static struct pci_device_id megaraid_pci_tbl[] = {
+static const struct pci_device_id megaraid_pci_tbl[] = {
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
-- 
2.7.4
