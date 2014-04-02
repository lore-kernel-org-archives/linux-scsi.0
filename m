From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] blk-mq: initialize resid_len
Date: Wed,  2 Apr 2014 16:57:10 +0200
Message-ID: <1396450634-32021-2-git-send-email-hch@lst.de>
References: <1396450634-32021-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbaDBOzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2014 10:55:05 -0400
In-Reply-To: <1396450634-32021-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b1bcc61..44f738e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -350,6 +350,8 @@ static void blk_mq_start_request(struct request *rq, bool last)
 
 	trace_block_rq_issue(q, rq);
 
+	rq->resid_len = blk_rq_bytes(rq);
+
 	/*
 	 * Just mark start time and set the started bit. Due to memory
 	 * ordering, we know we'll see the correct deadline as long as
-- 
1.7.10.4

