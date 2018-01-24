From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: Enable quirk to ignore sending WRITE_SAME command
Date: Wed, 24 Jan 2018 09:52:35 +0530
Message-ID: <1516767755-22855-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

WRITE_SAME command is not supported by UFS. Enable a quirk for
the upper level drivers to not send WRITE SAME command.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8af2af3..5a8dc3b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4356,6 +4356,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* WRITE_SAME command is not supported*/
 	sdev->no_write_same = 1;
 
+	/* WRITE_SAME command is not supported*/
+	sdev->no_write_same = 1;
+
 	ufshcd_set_queue_depth(sdev);
 
 	ufshcd_get_lu_power_on_wp_status(hba, sdev);
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
