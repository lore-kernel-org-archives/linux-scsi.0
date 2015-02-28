From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: ufs: fix typo in dev_err error message
Date: Sat, 28 Feb 2015 20:34:27 +0000
Message-ID: <1425155667-8359-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbB1UgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 15:36:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix typo, "Intialization" -> "Initialization"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564..1eff404 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -341,7 +341,7 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
-		dev_err(dev, "Intialization failed\n");
+		dev_err(dev, "Initialization failed\n");
 		goto out_disable_rpm;
 	}
 
-- 
2.1.4

