From: Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 05/24] drivers/scsi/mvumi: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:28:40 +0800
Message-ID: <1369621720-6092-1-git-send-email-libo.chen@huawei.com>
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
 drivers/scsi/mvumi.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
old mode 100644
new mode 100755
index c3601b5..d0b6a03
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2735,22 +2735,4 @@ static struct pci_driver mvumi_pci_driver = {
 #endif
 };
 
-/**
- * mvumi_init - Driver load entry point
- */
-static int __init mvumi_init(void)
-{
-	return pci_register_driver(&mvumi_pci_driver);
-}
-
-/**
- * mvumi_exit - Driver unload entry point
- */
-static void __exit mvumi_exit(void)
-{
-
-	pci_unregister_driver(&mvumi_pci_driver);
-}
-
-module_init(mvumi_init);
-module_exit(mvumi_exit);
+module_pci_driver(mvumi_pci_driver);
-- 
1.7.1
