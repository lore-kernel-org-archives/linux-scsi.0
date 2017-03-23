From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/23] block: renumber REQ_OP_WRITE_ZEROES
Date: Thu, 23 Mar 2017 10:33:19 -0400
Message-ID: <20170323143341.31549-2-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make life easy for implementations that needs to send a data buffer
to the device (e.g. SCSI) by numbering it as a data out command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blk_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d703acb55d0f..6393c13a6498 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -160,7 +160,7 @@ enum req_opf {
 	/* write the same sector many times */
 	REQ_OP_WRITE_SAME	= 7,
 	/* write the zero filled sector many times */
-	REQ_OP_WRITE_ZEROES	= 8,
+	REQ_OP_WRITE_ZEROES	= 9,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
-- 
2.11.0
