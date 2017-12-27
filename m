From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 10/12] hpsa: drop unneeded newline
Date: Wed, 27 Dec 2017 15:51:43 +0100
Message-ID: <1514386305-7402-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

hpsa_show_dev_msg prints other information and a newline after the
message string, so the message string does not need to include a
newline explicitly.  Done using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b0aa5dc..3bb8191 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3518,7 +3518,7 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 
 	if (rc != IO_OK)
 		hpsa_show_dev_msg(KERN_INFO, h, encl_dev,
-			"Error, could not get enclosure information\n");
+			"Error, could not get enclosure information");
 }
 
 static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
