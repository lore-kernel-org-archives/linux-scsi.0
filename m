From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bnx2fc: fix spelling mistake: "Couldnt" -> "Couldn't"
Date: Fri,  1 Dec 2017 09:37:25 +0000
Message-ID: <20171201093725.9274-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e6b9de7d41ac..65de1d0578a1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1552,7 +1552,7 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 
 	rc = bnx2fc_shost_config(lport, parent);
 	if (rc) {
-		printk(KERN_ERR PFX "Couldnt configure shost for %s\n",
+		printk(KERN_ERR PFX "Couldn't configure shost for %s\n",
 			interface->netdev->name);
 		goto lp_config_err;
 	}
@@ -1560,7 +1560,7 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_interface *interface,
 	/* Initialize the libfc library */
 	rc = bnx2fc_libfc_config(lport);
 	if (rc) {
-		printk(KERN_ERR PFX "Couldnt configure libfc\n");
+		printk(KERN_ERR PFX "Couldn't configure libfc\n");
 		goto shost_err;
 	}
 	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
-- 
2.14.1
