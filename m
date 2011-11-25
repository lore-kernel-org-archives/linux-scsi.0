From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH 1/2] [SCSI] sd: Adapt comment and printk string after renaming sd_init_command to sd_prep_fn
Date: Fri, 25 Nov 2011 11:02:44 +0100
Message-ID: <1322215365-15655-1-git-send-email-petr.uzel@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make the comment and string in printk match the code after commit
7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..c368e88 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -633,7 +633,7 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 }
 
 /**
- *	sd_init_command - build a scsi (read or write) command from
+ *	sd_prep_fn - build a scsi (read or write) command from
  *	information in the request structure.
  *	@SCpnt: pointer to mid-level's per scsi command structure that
  *	contains request and into which the scsi command is written
@@ -680,7 +680,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	ret = BLKPREP_KILL;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
-					"sd_init_command: block=%llu, "
+					"sd_prep_fn: block=%llu, "
 					"count=%d\n",
 					(unsigned long long)block,
 					this_count));
-- 
1.7.7
