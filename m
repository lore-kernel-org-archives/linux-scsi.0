From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 11/12] scsi/ufs: qcom: Add phy_exit call in hcd exit path
Date: Sun, 30 Oct 2016 01:52:13 +0530
Message-ID: <1477772534-14170-12-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47138 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755604AbcJ2UXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2016 16:23:15 -0400
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

Do a phy_exit() over the ufs phy in the ufs qcom exit path
to de-initialize the phy.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No changes since v2.

 drivers/scsi/ufs/ufs-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9b6a081..9590df5 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1275,6 +1275,7 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
 
 	ufs_qcom_disable_lane_clks(host);
 	phy_power_off(host->generic_phy);
+	phy_exit(host->generic_phy);
 }
 
 static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba *hba,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

