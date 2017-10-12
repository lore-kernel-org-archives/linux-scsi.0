From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 1/5] dt-bindings: phy: Add PHY_TYPE_UFS definition
Date: Thu, 12 Oct 2017 11:49:32 +0530
Message-ID: <1507789176-2760-2-git-send-email-vivek.gautam@codeaurora.org>
References: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, robh+dt@kernel.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Add definition for UFS phy type.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---

Changes since v1:
 - none.

 include/dt-bindings/phy/phy.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
index 6c901930eb3e..d16e8755f6a9 100644
--- a/include/dt-bindings/phy/phy.h
+++ b/include/dt-bindings/phy/phy.h
@@ -15,5 +15,6 @@
 #define PHY_TYPE_PCIE		2
 #define PHY_TYPE_USB2		3
 #define PHY_TYPE_USB3		4
+#define PHY_TYPE_UFS		5
 
 #endif /* _DT_BINDINGS_PHY */
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
