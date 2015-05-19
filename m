From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 3/3] scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
Date: Tue, 19 May 2015 16:47:11 +0300
Message-ID: <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42239 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbbESNrj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 09:47:39 -0400
In-Reply-To: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

This change is required in order to be able to build the component
as a module.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e945383..5f45307 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -72,7 +72,7 @@ config SCSI_UFSHCD_PLATFORM
 	  If unsure, say N.
 
 config SCSI_UFS_QCOM
-	bool "QCOM specific hooks to UFS controller platform driver"
+	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
 	select PHY_QCOM_UFS
 	help
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
