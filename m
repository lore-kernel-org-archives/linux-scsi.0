From: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 11/11] scsi: ufs: Add exynos ufs platform data
Date: Thu, 17 Sep 2015 15:15:37 +0530
Message-ID: <1442483137-32376-12-git-send-email-alim.akhtar@samsung.com>
References: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1442483137-32376-1-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This adds ufs_hba_exynos_ops{} to platform data, so that
exynos ufs driver can be probed.

Signed-off-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
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
index 83fe605..15f2a7c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -687,4 +687,5 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+extern const struct ufs_hba_variant_ops ufs_hba_exynos_ops;
 #endif /* End of Header */
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
