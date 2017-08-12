From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/6] [SCSI] csiostor: constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 07:44:33 +0200
Message-ID: <1502516674-8918-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These pci_error_handlers structures are only stored in the err_handler
field of a pci_driver structure, and this field is declared as const.  Thus
the pci_error_handlers structures can be const too.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/csiostor/csio_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 28a9c7d..ab4fbcf 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1168,7 +1168,7 @@ static void csio_remove_one(struct pci_dev *pdev)
 	dev_err(&pdev->dev, "resume of device failed: %d\n", rv);
 }
 
-static struct pci_error_handlers csio_err_handler = {
+static const struct pci_error_handlers csio_err_handler = {
 	.error_detected = csio_pci_error_detected,
 	.slot_reset	= csio_pci_slot_reset,
 	.resume		= csio_pci_resume,
