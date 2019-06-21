From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] scsi: ufshdc-pci: Add Intel PCI Ids for EHL
Date: Fri, 21 Jun 2019 15:19:42 +0300
Message-ID: <20190621121942.25769-1-adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Add more Intel PCI Ids.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index ffe6f82182ba..3b19de3ae9a3 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -200,6 +200,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ }	/* terminate list */
 };
 
-- 
2.17.1
