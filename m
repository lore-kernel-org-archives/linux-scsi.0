From: FUJITA Tomonori <tomof@acm.org>
Subject: Subject: [PATCH] tgt: use KMEM_CACHE
Date: Thu, 25 Oct 2007 01:21:29 +0900
Message-ID: <20071024235611B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38673 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXJXQVw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 12:21:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index deea3cd..7abef1a 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -641,9 +641,7 @@ static int __init scsi_tgt_init(void)
 {
 	int err;
 
-	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
-					       sizeof(struct scsi_tgt_cmd),
-					       0, 0, NULL);
+	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
 	if (!scsi_tgt_cmd_cache)
 		return -ENOMEM;
 
-- 
1.5.2.4

