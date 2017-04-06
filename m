From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/25] swim3: remove (commented out) printing of req->errors
Date: Thu,  6 Apr 2017 17:39:41 +0200
Message-ID: <20170406153944.10058-23-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbdDFPlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:41:01 -0400
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/swim3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 61b3ffa4f458..ba4809c9bdba 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -343,8 +343,8 @@ static void start_request(struct floppy_state *fs)
 			  req->rq_disk->disk_name, req->cmd,
 			  (long)blk_rq_pos(req), blk_rq_sectors(req),
 			  bio_data(req->bio));
-		swim3_dbg("           errors=%d current_nr_sectors=%u\n",
-			  req->errors, blk_rq_cur_sectors(req));
+		swim3_dbg("           current_nr_sectors=%u\n",
+			  blk_rq_cur_sectors(req));
 #endif
 
 		if (blk_rq_pos(req) >= fs->total_secs) {
-- 
2.11.0
