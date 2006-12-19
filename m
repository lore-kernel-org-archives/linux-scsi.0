From: akpm@osdl.org
Subject: [patch 10/26] pci_module_init() convertion in the legacy megaraid driver
Date: Tue, 19 Dec 2006 13:14:45 -0800
Message-ID: <200612192114.kBJLEjiF010703@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbWLSVOx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:14:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

pci_module_init() convertion in the legacy megaraid driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~pci_module_init-convertion-in-the-legacy-megaraid-driver drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~pci_module_init-convertion-in-the-legacy-megaraid-driver
+++ a/drivers/scsi/megaraid.c
@@ -5077,7 +5077,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
_
