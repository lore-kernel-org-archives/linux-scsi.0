From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 6/8] scsi: pm80xx: reduce indentation
Date: Sun, 30 Dec 2018 16:53:13 +0100
Message-ID: <1546185195-25676-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1546185195-25676-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546185195-25676-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: kernel-janitors@vger.kernel.org, lindar_liu@usish.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Delete tab aligning a statement with the right hand side of a
preceding assignment rather than the left hand side.

Found with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b3be49d41375..44b630aceb12 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -657,7 +657,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 		if (dev->dev_type == SAS_SATA_DEV) {
 			pm8001_device->attached_phy =
 				dev->rphy->identify.phy_identifier;
-				flag = 1; /* directly sata*/
+			flag = 1; /* directly sata*/
 		}
 	} /*register this device to HBA*/
 	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
