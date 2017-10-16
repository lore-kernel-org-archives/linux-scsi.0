From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 7/8] scsi/pmcraid: Remove an unused structure member
Date: Mon, 16 Oct 2017 15:49:39 -0700
Message-ID: <20171016224940.1332-8-bart.vanassche@wdc.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20171016224940.1332-1-bart.vanassche@wdc.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
---
 drivers/scsi/pmcraid.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 8bfac72a242b..44da91712115 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -542,7 +542,6 @@ struct pmcraid_sglist {
 	u32 order;
 	u32 num_sg;
 	u32 num_dma_sg;
-	u32 buffer_len;
 	struct scatterlist scatterlist[1];
 };
 
-- 
2.14.2
