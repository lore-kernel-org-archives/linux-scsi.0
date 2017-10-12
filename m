From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 2/5] phy: Add UFS PHY modes
Date: Thu, 12 Oct 2017 11:49:33 +0530
Message-ID: <1507789176-2760-3-git-send-email-vivek.gautam@codeaurora.org>
References: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, robh+dt@kernel.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

UFS phy has two modes for each High speed generation.
These modes are identified by two rates of operations -
Rate A, and Rate B.
Add these UFS phy modes to phy framework.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

Changes since v1:
 - Rebased on linux-phy/next.

 include/linux/phy/phy.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e694d4008c4a..79c341da1b8c 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -29,6 +29,8 @@ enum phy_mode {
 	PHY_MODE_USB_OTG,
 	PHY_MODE_SGMII,
 	PHY_MODE_10GKR,
+	PHY_MODE_UFS_HS_A,
+	PHY_MODE_UFS_HS_B,
 };
 
 /**
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
