From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 02/10] phy: qcom-ufs: Remove unnecessary BUG_ON
Date: Tue, 18 Oct 2016 19:58:09 +0530
Message-ID: <1476800897-19898-3-git-send-email-vivek.gautam@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761620AbcJRO25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 10:28:57 -0400
In-Reply-To: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

BUG_ON() are not preferred in the driver, plus the variable
on which BUG_ON is asserted is already checked in the code
before passing.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No change since v1.

 drivers/phy/phy-qcom-ufs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 183ec04..805c91d 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -335,8 +335,6 @@ int ufs_qcom_phy_cfg_vreg(struct phy *phy,
 	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(phy);
 	struct device *dev = ufs_qcom_phy->dev;
 
-	BUG_ON(!vreg);
-
 	if (regulator_count_voltages(reg) > 0) {
 		min_uV = on ? vreg->min_uV : 0;
 		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

