From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 06/29] scsi: mvsas: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:07:15 +0530
Message-ID: <1501403839-8876-7-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e047b5..552c5a0 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -659,7 +659,7 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	return;
 }
 
-static struct pci_device_id mvs_pci_table[] = {
+static const struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
 	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
 	{
-- 
2.7.4
