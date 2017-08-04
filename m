From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 2/5] phy: Add UFS PHY modes
Date: Fri,  4 Aug 2017 12:18:49 +0530
Message-ID: <1501829332-5183-3-git-send-email-vivek.gautam@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdHDGtS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 02:49:18 -0400
In-Reply-To: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, Vivek Gautam <vivek.gautam@codeaurora.org>

UFS phy has two modes for each High speed generation.
These modes are identified by two rates of operations -
Rate A, and Rate B.
Add these UFS phy modes to phy framework.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 include/linux/phy/phy.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 78bb0d7f6b11..27e25bb78bfb 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -27,6 +27,8 @@ enum phy_mode {
 	PHY_MODE_USB_HOST,
 	PHY_MODE_USB_DEVICE,
 	PHY_MODE_USB_OTG,
+	PHY_MODE_UFS_HS_A,
+	PHY_MODE_UFS_HS_B,
 };
 
 /**
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
