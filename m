From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] scsi: ufs: Delete an unnecessary return statement in
 ufshcd_exception_event_handler()
Date: Tue, 25 Apr 2017 22:30:05 +0200
Message-ID: <9fc152fd-0881-85f6-a4d0-3db27dc364f5@users.sourceforge.net>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Apr 2017 22:00:05 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement here.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5216e33e61a3..9018f26a5667 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4966,7 +4966,6 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 
 out:
 	pm_runtime_put_sync(hba->dev);
-	return;
 }
 
 /* Complete requests that have door-bell cleared */
-- 
2.12.2

