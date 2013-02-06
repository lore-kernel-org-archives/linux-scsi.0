From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 12/14] sg_io: remove remnants of sysfs SG_IO filters
Date: Wed,  6 Feb 2013 16:15:59 +0100
Message-ID: <1360163761-8541-13-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Some defines and structs remained when support was removed for SG_IO
filters in sysfs.  Remove them.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/genhd.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 79b8bba..d3bc249 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -144,15 +144,6 @@ enum {
 	DISK_EVENT_EJECT_REQUEST		= 1 << 1, /* eject requested */
 };
 
-#define BLK_SCSI_MAX_CMDS	(256)
-#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
-
-struct blk_scsi_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
-};
-
 struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
-- 
1.7.1
