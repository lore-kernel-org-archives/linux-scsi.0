From: liujian <liujian56@huawei.com>
Subject: [PATCH 1/2] driver: scsi: ufs-qcom: fix returnvar.cocci warning
Date: Sat, 1 Dec 2018 02:07:43 +0800
Message-ID: <1543601264-12610-1-git-send-email-liujian56@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vinholikatti@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove unneeded variable used to store return value,
detected by the semantic patch returnvar.cocci.

Signed-off-by: liujian <liujian56@huawei.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aeadb1..4d5532d 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -543,7 +543,6 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
-	int ret = 0;
 
 	if (ufs_qcom_is_link_off(hba)) {
 		/*
@@ -569,7 +568,7 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 out:
-	return ret;
+	return 0;
 }
 
 static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
-- 
2.7.4
