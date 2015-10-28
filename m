From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v9 3/8] scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
Date: Wed, 28 Oct 2015 13:15:46 +0200
Message-ID: <1446030951-2431-4-git-send-email-ygardi@codeaurora.org>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

This change is required in order to be able to build the component
as a module.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
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
