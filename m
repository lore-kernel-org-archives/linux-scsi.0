From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 2/2] scsi: ufs: fix few typos in the comments
Date: Tue,  9 Feb 2016 10:25:41 +0200
Message-ID: <1455006341-1260-2-git-send-email-tomas.winkler@intel.com>
References: <1455006341-1260-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:63092 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbcBII0y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Feb 2016 03:26:54 -0500
In-Reply-To: <1455006341-1260-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 drivers/scsi/ufs/ufshcd.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a44153401aee..07f1fa438fec 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1476,7 +1476,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	if (!time_left) {
 		err = -ETIMEDOUT;
 		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
-			/* sucessfully cleared the command, retry if needed */
+			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
 	}
 
@@ -2563,7 +2563,7 @@ out:
  * To bring UFS host controller to operational state,
  * 1. Enable required interrupts
  * 2. Configure interrupt aggregation
- * 3. Program UTRL and UTMRL base addres
+ * 3. Program UTRL and UTMRL base address
  * 4. Configure run-stop-registers
  *
  * Returns 0 on success, non-zero value on failure
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2570d9477b37..18ed160b0ef1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -177,7 +177,7 @@ struct ufshcd_lrb {
 };
 
 /**
- * struct ufs_query - holds relevent data structures for query request
+ * struct ufs_query - holds relevant data structures for query request
  * @request: request upiu and function
  * @descriptor: buffer for sending/receiving descriptor
  * @response: response upiu and response
-- 
2.4.3

