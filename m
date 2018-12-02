From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: ipr: NULL check before some freeing functions is not
 needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930052-1887660803-15-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: brking@us.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9537,8 +9537,7 @@ static void ipr_free_cmd_blks(struct ipr
 		}
 	}
 
-	if (ioa_cfg->ipr_cmd_pool)
-		dma_pool_destroy(ioa_cfg->ipr_cmd_pool);
+	dma_pool_destroy(ioa_cfg->ipr_cmd_pool);
 
 	kfree(ioa_cfg->ipr_cmnd_list);
 	kfree(ioa_cfg->ipr_cmnd_list_dma);
