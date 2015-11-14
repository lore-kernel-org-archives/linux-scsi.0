From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 3/9] cxgb4/cxgb4vf/csiostor: constify pci_error_handlers structures
Date: Sat, 14 Nov 2015 11:06:55 +0100
Message-ID: <1447495621-9161-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This pci_error_handlers structure is never modified, like all the other
pci_error_handlers structures, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There are no dependencies between these patches.

 drivers/scsi/csiostor/csio_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index dbe416f..33996f2 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1162,7 +1162,7 @@ err_resume_exit:
 	dev_err(&pdev->dev, "resume of device failed: %d\n", rv);
 }
 
-static struct pci_error_handlers csio_err_handler = {
+static const struct pci_error_handlers csio_err_handler = {
 	.error_detected = csio_pci_error_detected,
 	.slot_reset	= csio_pci_slot_reset,
 	.resume		= csio_pci_resume,
