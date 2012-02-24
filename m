From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH 1/2] [resend] [SCSI] sd: Adapt comment and printk string after renaming sd_init_command to sd_prep_fn
Date: Fri, 24 Feb 2012 16:56:54 +0100
Message-ID: <1330099015-26893-1-git-send-email-petr.uzel@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make the comment and string in printk match the code after commit
7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..7c0d345 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -634,7 +634,7 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 }
 
 /**
- *	sd_init_command - build a scsi (read or write) command from
+ *	sd_prep_fn - build a scsi (read or write) command from
  *	information in the request structure.
  *	@SCpnt: pointer to mid-level's per scsi command structure that
  *	contains request and into which the scsi command is written
@@ -681,7 +681,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	ret = BLKPREP_KILL;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
-					"sd_init_command: block=%llu, "
+					"sd_prep_fn: block=%llu, "
 					"count=%d\n",
 					(unsigned long long)block,
 					this_count));
-- 
1.7.7
