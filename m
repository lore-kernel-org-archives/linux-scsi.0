From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 6/6] bfa: constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 07:44:34 +0200
Message-ID: <1502516674-8918-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These pci_error_handlers structures are only stored in the err_handler
field of a pci_driver structure, and this field is declared as const.  Thus
the pci_error_handlers structures can be const too.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/bfa/bfad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 5caf5f3..2861694 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1683,7 +1683,7 @@ struct pci_device_id bfad_id_table[] = {
 /*
  * PCI error recovery handlers.
  */
-static struct pci_error_handlers bfad_err_handler = {
+static const struct pci_error_handlers bfad_err_handler = {
 	.error_detected = bfad_pci_error_detected,
 	.slot_reset = bfad_pci_slot_reset,
 	.mmio_enabled = bfad_pci_mmio_enabled,
