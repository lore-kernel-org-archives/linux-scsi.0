From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix compile warning
Date: Sat, 26 Apr 2008 01:37:57 +0900
Message-ID: <20080426013746Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33811 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbYDYQi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:38:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This is against Jens' for-linus branch.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix compile warning

block/blk-core.c: In function __blk_run_queue
block/blk-core.c:382: warning: unused variable flags

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 35ae1c0..4fd42af 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -380,8 +380,6 @@ EXPORT_SYMBOL(blk_sync_queue);
  */
 void __blk_run_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
 	blk_remove_plug(q);
 
 	/*
-- 
1.5.4.2

