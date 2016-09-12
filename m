From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: megaraid_sas: add in missing white space in error message text
Date: Mon, 12 Sep 2016 13:42:12 +0100
Message-ID: <20160912124212.32132-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32986 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754615AbcILMnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2016 08:43:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A dev_printk message spans two lines and the literal string is missing
a white space between words. Add the white space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2d62d71..c236c4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5782,7 +5782,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					     &instance->consumer_h);
 
 		if (!instance->producer || !instance->consumer) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
 			       "memory for producer, consumer\n");
 			goto fail_alloc_dma_buf;
 		}
-- 
2.9.3

