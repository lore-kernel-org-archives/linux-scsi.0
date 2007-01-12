From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] megaraid.c: Convert pci_module_init() to pci_register_driver()
Date: Fri, 12 Jan 2007 14:31:43 +0100
Message-ID: <45A78DBF.6010606@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35365 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXALNvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2007 08:51:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
PS
The mailing-list is marked as S: instead of L:
DS

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 77d9d38..4fd4960 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -5072,7 +5072,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);


