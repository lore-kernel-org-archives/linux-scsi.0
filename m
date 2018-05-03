From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 02/10] scsi: ufs-qcom: Enable UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE quirk
Date: Thu,  3 May 2018 16:37:14 +0530
Message-ID: <e81a03ffb59d1f9155e26dd1d71ec495811c2937.1525343531.git.asutoshd@codeaurora.org>
References: <cover.1525341340.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525341340.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1525343531.git.asutoshd@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, linux-mmc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Enable UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE quirk to avoid failures
in seen on some UFS devices.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4563d2e..d9edef8 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1105,7 +1105,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 	if (host->hw_ver.major >= 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
-
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE;
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
 			hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
