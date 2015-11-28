From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: ufs: fix spelling mistake in error message
Date: Sat, 28 Nov 2015 16:33:56 +0000
Message-ID: <1448728436-9058-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Minor issue, fix spelling mistake, Intialization -> Initialization

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 9714f2a..d2a7b12 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -333,7 +333,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
-		dev_err(dev, "Intialization failed\n");
+		dev_err(dev, "Initialization failed\n");
 		goto out_disable_rpm;
 	}
 
-- 
2.6.2
