From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] scsi: dmx3191d: use module_pci_driver
Date: Wed, 16 Nov 2016 21:00:58 +0800
Message-ID: <015ae0a9f5aea965329a6669367ee7a61089ef6b.1479278839.git.geliangtang@gmail.com>
References: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use module_pci_driver() helper to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/dmx3191d.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 3aa4657..6af3394 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -153,18 +153,7 @@ static struct pci_driver dmx3191d_pci_driver = {
 	.remove		= dmx3191d_remove_one,
 };
 
-static int __init dmx3191d_init(void)
-{
-	return pci_register_driver(&dmx3191d_pci_driver);
-}
-
-static void __exit dmx3191d_exit(void)
-{
-	pci_unregister_driver(&dmx3191d_pci_driver);
-}
-
-module_init(dmx3191d_init);
-module_exit(dmx3191d_exit);
+module_pci_driver(dmx3191d_pci_driver);
 
 MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
 MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
-- 
2.9.3
