From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 01/12] phy: qcom-ufs: Remove unnecessary BUG_ON
Date: Sun, 30 Oct 2016 01:52:03 +0530
Message-ID: <1477772534-14170-2-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

BUG_ON() are not preferred in the driver, plus the variable
on which BUG_ON is asserted is already checked in the code
before passing.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No changes since v1.

 drivers/phy/phy-qcom-ufs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 18a5b49..455064c 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -322,8 +322,6 @@ int ufs_qcom_phy_cfg_vreg(struct phy *phy,
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
