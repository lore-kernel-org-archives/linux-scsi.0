From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 4/9] bfa: constify pci_error_handlers structures
Date: Sat, 14 Nov 2015 11:06:56 +0100
Message-ID: <1447495621-9161-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: kernel-janitors@vger.kernel.org, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This pci_error_handlers structure is never modified, like all the other
pci_error_handlers structures, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There are no dependencies between these patches.

 drivers/scsi/bfa/bfad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index cc3b9d3..8df346a 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1687,7 +1687,7 @@ MODULE_DEVICE_TABLE(pci, bfad_id_table);
 /*
  * PCI error recovery handlers.
  */
-static struct pci_error_handlers bfad_err_handler = {
+static const struct pci_error_handlers bfad_err_handler = {
 	.error_detected = bfad_pci_error_detected,
 	.slot_reset = bfad_pci_slot_reset,
 	.mmio_enabled = bfad_pci_mmio_enabled,
