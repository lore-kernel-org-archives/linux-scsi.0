From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: [PATCH 1/3] scsi: aacraid: fix indentation errors
Date: Tue, 29 Aug 2017 13:59:02 +0200
Message-ID: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Nikola Pajkovsky <npajkovsky@suse.cz>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

fix stupid indent error, no rocket science here.

Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
---
 drivers/scsi/aacraid/comminit.c | 6 +++---
 drivers/scsi/aacraid/linit.c    | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 9ee025b1d0e0..97d269f16888 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -520,9 +520,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 			dev->raw_io_64 = 1;
 		dev->sync_mode = aac_sync_mode;
 		if (dev->a_ops.adapter_comm &&
-			(status[1] & AAC_OPT_NEW_COMM)) {
-				dev->comm_interface = AAC_COMM_MESSAGE;
-				dev->raw_io_interface = 1;
+		    (status[1] & AAC_OPT_NEW_COMM)) {
+			dev->comm_interface = AAC_COMM_MESSAGE;
+			dev->raw_io_interface = 1;
 			if ((status[1] & AAC_OPT_NEW_COMM_TYPE1)) {
 				/* driver supports TYPE1 (Tupelo) */
 				dev->comm_interface = AAC_COMM_MESSAGE_TYPE1;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0f277df73af0..d7698a4cf840 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1457,7 +1457,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/*
 	 * Only series 7 needs freset.
 	 */
-	 if (pdev->device == PMC_DEVICE_S7)
+	if (pdev->device == PMC_DEVICE_S7)
 		pdev->needs_freset = 1;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
-- 
2.13.5
