From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 13/13] scsi: ufs: Add exynos ufs platform data
Date: Thu, 01 Oct 2015 13:39:30 +0530
Message-ID: <1443686970-28104-14-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This adds ufs_hba_exynos_ops{} to platform data, so that
exynos ufs driver can be probed.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |    2 ++
 drivers/scsi/ufs/ufshcd.h        |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564..39dae76 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -373,6 +373,8 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 static const struct of_device_id ufs_of_match[] = {
 	{ .compatible = "jedec,ufs-1.1"},
+	{ .compatible = "samsung,exynos7-ufs",
+	 .data	= &ufs_hba_exynos_ops},
 	{},
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f771cb8..776d6e0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -687,4 +687,5 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+extern const struct ufs_hba_variant_ops ufs_hba_exynos_ops;
 #endif /* End of Header */
-- 
1.7.10.4
