From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 20/29] scsi: cxlflash: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:10:36 +0530
Message-ID: <1501404036-9005-10-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 077f62e..88bd551 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3155,7 +3155,7 @@ static struct dev_dependent_vals dev_briard_vals = { CXLFLASH_MAX_SECTORS,
 /*
  * PCI device binding table
  */
-static struct pci_device_id cxlflash_pci_table[] = {
+static const struct pci_device_id cxlflash_pci_table[] = {
 	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
 	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_FLASH_GT,
-- 
2.7.4
