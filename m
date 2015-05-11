From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 1/2] scsi: ufs: update obsolete configuration of ARCH_MSM into ARCH_QCOM
Date: Mon, 11 May 2015 18:15:20 +0300
Message-ID: <1431357321-7932-2-git-send-email-ygardi@codeaurora.org>
References: <1431357321-7932-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431357321-7932-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, gbroner@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Since ARCH_MSM is no longer supported as configuration definition,
it should be modified into ARCH_QCOM in order to add support for
Qualcomm platforms.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8a1f4b3..e945383 100644
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
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
