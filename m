From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 2/3] scsi: ufs-qcom: fix compilation warning if compiled as a module
Date: Tue, 19 May 2015 16:47:10 +0300
Message-ID: <1432043231-31102-3-git-send-email-ygardi@codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

This change fixes a compilation warning that happens if SCSI_UFS_QCOM
is compiled as a module.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6652a81..2e4ad21 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -885,7 +885,7 @@ out:
 
 #define	ANDROID_BOOT_DEV_MAX	30
 static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
-static int get_android_boot_dev(char *str)
+static int __maybe_unused get_android_boot_dev(char *str)
 {
 	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
 	return 1;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
