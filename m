From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH] qla2xxx: Fix compiler warning
Date: Wed, 6 Jul 2016 11:45:32 -0400
Message-ID: <1467819932-15678-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:49342 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754490AbcGFQaR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 12:30:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Fixes: 7f939ab ("qla2xxx: Add bsg interface to support statistics counter reset.")
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8a953aa..643014f 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2289,10 +2289,9 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 	bsg_job->reply->result = DID_OK << 16;
 	bsg_job->job_done(bsg_job);
 
-done_free:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
-done:
+
 	return 0;
 }
 
-- 
1.7.1

