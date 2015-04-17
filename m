From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] block: remove REQ_TYPE_PM_SHUTDOWN
Date: Fri, 17 Apr 2015 22:37:19 +0200
Message-ID: <1429303042-12078-5-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbbDQUi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:29 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6076b9e..c2829ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -77,7 +77,6 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_BLOCK_PC,		/* scsi command */
 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
 	REQ_TYPE_PM_RESUME,		/* resume request */
-	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
 	REQ_TYPE_DRV_PRIV,		/* driver defined types from here */
 };
 
-- 
1.9.1

