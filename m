From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 2/2] phy: update obsolete configuration of ARCH_MSM into ARCH_QCOM
Date: Mon, 11 May 2015 18:15:21 +0300
Message-ID: <1431357321-7932-3-git-send-email-ygardi@codeaurora.org>
References: <1431357321-7932-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431357321-7932-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, gbroner@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

Since ARCH_MSM is no longer supported as configuration definition,
it should be modified into ARCH_QCOM in order to add support for
Qualcomm platforms.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a53bd5b..33e703e 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -304,7 +304,7 @@ config PHY_STIH41X_USB
 
 config PHY_QCOM_UFS
 	tristate "Qualcomm UFS PHY driver"
-	depends on OF && ARCH_MSM
+	depends on OF && ARCH_QCOM
 	select GENERIC_PHY
 	help
 	  Support for UFS PHY on QCOM chipsets.
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
