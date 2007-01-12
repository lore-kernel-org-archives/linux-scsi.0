From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] tmscsim.c: Convert pci_module_init() to pci_register_driver()
Date: Fri, 12 Jan 2007 14:31:51 +0100
Message-ID: <45A78DC7.6090808@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35353 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXALNvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2007 08:51:39 -0500
Received: from [130.240.205.31] (thinktank.campus.luth.se [130.240.205.31])
	by gepetto.dc.ltu.se (8.12.5/8.12.5) with ESMTP id l0CDTcp9013464
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 14:29:38 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index fa5382e..ce8845e 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2681,7 +2681,7 @@ static int __init dc390_module_init(void)
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)


