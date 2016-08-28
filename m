From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] scsi: constify sr_pm_ops structure
Date: Sun, 28 Aug 2016 22:17:38 +0200
Message-ID: <1472415458-430-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sr_pm_ops, of type struct dev_pm_ops, is never modified, so declare it as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/sr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index ed17934..bed2bbd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -83,7 +83,7 @@ static int sr_init_command(struct scsi_cmnd *SCpnt);
 static int sr_done(struct scsi_cmnd *);
 static int sr_runtime_suspend(struct device *dev);
 
-static struct dev_pm_ops sr_pm_ops = {
+static const struct dev_pm_ops sr_pm_ops = {
 	.runtime_suspend	= sr_runtime_suspend,
 };
 
