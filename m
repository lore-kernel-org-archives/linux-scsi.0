From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 32/33] i2o: sg chaining support
Date: Mon, 16 Jul 2007 11:47:46 +0200
Message-ID: <11845792694030-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9344 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761438AbXGPJsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:39 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, alan@lxorguk.ukuu.org.uk

Cc: alan@lxorguk.ukuu.org.uk
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/i2o.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 52f53e2..0ae1dcf 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -836,7 +836,7 @@ static inline int i2o_dma_map_sg(struct i2o_controller *c,
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
 			*mptr++ = cpu_to_le32(i2o_dma_high(sg_dma_address(sg)));
 #endif
-		sg++;
+		sg = sg_next(sg);
 	}
 	*sg_ptr = mptr;
 
-- 
1.5.3.rc0.90.gbaa79

