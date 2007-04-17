From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: [PATCH] qla1280: use DMA_64BIT_MASK instead of ~ 0ULL
Date: Tue, 17 Apr 2007 09:58:36 +0200
Message-ID: <20070417075836.GA22931@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752463AbXDQIBy@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-driver@qlogic.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

QLA1280: call pci_set_dma_mask with DMA_64BIT_MASK instead of  ~ 0ULL

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

---

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6777e8a..54d8bdf 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4293,7 +4293,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no); 
-- 
              Comunicar bichos a <bug-coreutils@gnu.org>
                     (LANG=es_ES uname --help)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
                                                                  `-
