From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 1/9] scsi: ufs: add support to allow non standard behaviours (quirks)
Date: Fri,  6 Jul 2018 18:00:28 +0530
Message-ID: <36c4fc866db111df0de7c30839a40727aaa3a98b.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

Some implementation of UFS host controller HW might have some
non-standard behaviours (quirks) when compared to behaviour
specified by UFSHCI specification. This patch adds a quirk
for broken hibernate support.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f51758f..e996a08 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -613,6 +613,9 @@ struct ufs_hba {
 	 * enabled via HCE register.
 	 */
 	#define UFSHCI_QUIRK_BROKEN_HCE				0x400
+
+	/* HIBERN8 support is broken */
+	#define UFSHCD_QUIRK_BROKEN_HIBERN8			0x800
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
