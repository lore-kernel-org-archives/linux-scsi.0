From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs-qcom: remove broken hci version quirk
Date: Tue, 30 Jan 2018 10:11:21 +0530
Message-ID: <1517287281-8622-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16035 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbeA3Elu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 23:41:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION is only applicable for QCOM UFS host
controller version 2.x.y and this has been fixed from version 3.x.y
onwards, hence this change removes this quirk for version 3.x.y onwards.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2b38db2..221820a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1098,7 +1098,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
 	}
 
-	if (host->hw_ver.major >= 0x2) {
+	if (host->hw_ver.major == 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
