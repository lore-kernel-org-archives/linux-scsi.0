From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 37/52] atp870u: Use module_pci_driver
Date: Sun, 26 Jul 2015 22:24:44 +0200
Message-ID: <1437942299-26674-38-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56622 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375AbbGZUz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:55:28 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTz-0003IN-LX
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:15 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 2570919..7f53a50 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1785,21 +1785,7 @@ static struct pci_driver atp870u_driver = {
 	.remove		= atp870u_remove,
 };
 
-static int __init atp870u_init(void)
-{
-#ifdef ED_DBGP	
-	printk("atp870u_init: Entry\n");
-#endif	
-	return pci_register_driver(&atp870u_driver);
-}
-
-static void __exit atp870u_exit(void)
-{
-#ifdef ED_DBGP	
-	printk("atp870u_exit: Entry\n");
-#endif
-	pci_unregister_driver(&atp870u_driver);
-}
+module_pci_driver(atp870u_driver);
 
 static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
 {
@@ -2406,7 +2392,3 @@ set_syn_ok:
 #endif
 	}
 }
-
-module_init(atp870u_init);
-module_exit(atp870u_exit);
-
-- 
Ondrej Zary

