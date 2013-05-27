From: Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 03/24] drivers/scsi/dmx3191d: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:28:33 +0800
Message-ID: <1369621713-26724-1-git-send-email-libo.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/dmx3191d.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
old mode 100644
new mode 100755
index 4b0dd8c..bb28062
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
1.7.1
