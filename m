From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: remove useless variable assignment
Date: Wed, 17 May 2017 19:30:43 -0500
Message-ID: <20170518003043.GA5664@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Remove this assignment once the value stored in variable _k_ is
overwritten after a few lines.

Addresses-Coverity-ID: 1226927
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/qlogicfas408.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index c3a9151..269440a 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -329,7 +329,6 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 		 */
 		if ((k = ql_wai(priv)))
 			return (k << 16);
-		k = inb(qbase + 5);	/* should be 0x10, bus service */
 	}
 
 	/*
-- 
2.5.0
