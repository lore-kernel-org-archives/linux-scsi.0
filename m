From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/14] blk-mq: provide dummy blk_mq_map_queue_type() helper
Date: Mon, 29 Oct 2018 10:37:27 -0600
Message-ID: <20181029163738.10172-4-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Doesn't do anything right now, but it's needed as a prep patch
to get the interfaces right.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-mq.h b/block/blk-mq.h
index 889f0069dd80..79c300faa7ce 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -80,6 +80,12 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
 	return q->queue_hw_ctx[set->map[0].mq_map[cpu]];
 }
 
+static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *q,
+							  int type, int cpu)
+{
+	return blk_mq_map_queue(q, cpu);
+}
+
 /*
  * sysfs helpers
  */
-- 
2.17.1
