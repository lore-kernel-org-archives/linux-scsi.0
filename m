From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 8/9] mpt3sas: constify pci_error_handlers structures
Date: Sat, 14 Nov 2015 11:07:00 +0100
Message-ID: <1447495621-9161-9-git-send-email-Julia.Lawall@lip6.fr>
References: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447495621-9161-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: kernel-janitors@vger.kernel.org, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This pci_error_handlers structure is never modified, like all the other
pci_error_handlers structures, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
There are no dependencies between these patches.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9e68432..39678e7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8557,7 +8557,7 @@ static struct raid_function_template mpt3sas_raid_functions = {
 	.get_state	= _scsih_get_state,
 };
 
-static struct pci_error_handlers _scsih_err_handler = {
+static const struct pci_error_handlers _scsih_err_handler = {
 	.error_detected = _scsih_pci_error_detected,
 	.mmio_enabled = _scsih_pci_mmio_enabled,
 	.slot_reset =	_scsih_pci_slot_reset,
