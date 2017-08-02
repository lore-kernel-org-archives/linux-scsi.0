From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 3/3] scsi: mptsas: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:59:05 +0530
Message-ID: <1501694945-18061-4-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501694945-18061-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501694945-18061-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/message/fusion/mptsas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f6308ad..8604573 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5358,7 +5358,7 @@ static void mptsas_remove(struct pci_dev *pdev)
 	mptscsih_remove(pdev);
 }
 
-static struct pci_device_id mptsas_pci_table[] = {
+static const struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068,
-- 
2.7.4
