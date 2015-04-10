From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] ufs-qcom: Switch dependency to ARCH_QCOM
Date: Fri, 10 Apr 2015 16:11:06 -0700
Message-ID: <1428707466-24526-5-git-send-email-sboyd@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53142 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbbDJXLL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 19:11:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, David Brown <davidb@codeaurora.org>, Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>

This device only exists on platforms under ARCH_QCOM, not
ARCH_MSM.

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Dov Levenglick <dovl@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8a1f4b355416..e94538362536 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -73,7 +73,7 @@ config SCSI_UFSHCD_PLATFORM
 
 config SCSI_UFS_QCOM
 	bool "QCOM specific hooks to UFS controller platform driver"
-	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
 	select PHY_QCOM_UFS
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

