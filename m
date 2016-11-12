From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: megaraid_sas: add in missing white spaces in error messages text
Date: Sat, 12 Nov 2016 16:25:24 +0000
Message-ID: <20161112162524.4585-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49264 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965364AbcKLQZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 11:25:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A couple of  dev_printk messages spans two lines and the literal string
is missing a white space between words. Add the white space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6db7ab..d8eaf53 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6788,8 +6788,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		dev_err(&instance->pdev->dev, "timed out while"
-			"waiting for HBA to recover\n");
+		dev_err(&instance->pdev->dev, "timed out while waiting for HBA to recover\n");
 		error = -ENODEV;
 		goto out_up;
 	}
@@ -6857,8 +6856,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		dev_err(&instance->pdev->dev, "timed out while waiting"
-				"for HBA to recover\n");
+		dev_err(&instance->pdev->dev, "timed out while waiting for HBA to recover\n");
 		return -ENODEV;
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
-- 
2.10.2

