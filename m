From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 27/39] blk-mq: export blk_mq_insert_request
Date: Mon, 17 Mar 2014 06:28:00 -0700
Message-ID: <20140317133135.398130517@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0027-blk-mq-export-blk_mq_insert_request.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We'll need this for now when scsi is built as a module.  Eventually
I hope to be able to move it to a higher level API intead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6f04dda..4408c70 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -740,6 +740,7 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 	if (run_queue)
 		blk_mq_run_hw_queue(hctx, async);
 }
+EXPORT_SYMBOL(blk_mq_insert_request);
 
 static void blk_mq_insert_requests(struct request_queue *q,
 				     struct blk_mq_ctx *ctx,
-- 
1.7.10.4
