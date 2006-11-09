From: akpm@osdl.org
Subject: [patch 12/26] pci_module_init() convertion in tmscsim.c
Date: Wed, 08 Nov 2006 19:56:14 -0800
Message-ID: <200611090356.kA93uES2003946@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1714 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424009AbWKID4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtinwdheim.de, alan@redhat.com, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtinwdheim.de>

pci_module_init() convertion in tmscsim.c

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/tmscsim.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/tmscsim.c~pci_module_init-convertion-in-tmscsimc drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c~pci_module_init-convertion-in-tmscsimc
+++ a/drivers/scsi/tmscsim.c
@@ -177,6 +177,8 @@
  *	2.1d  04/05/27	GL	Moved setting of scan_devices to	*
  *				slave_alloc/_configure/_destroy, as	*
  *				suggested by CH.			*
+ *	2.1e  06/09/04	HENKR	change pci_module_init() to		*
+ *				pci_register_driver()			*
  ***********************************************************************/
 
 /* DEBUG options */
@@ -245,7 +247,7 @@
 
 
 #define DC390_BANNER "Tekram DC390/AM53C974"
-#define DC390_VERSION "2.1d 2004-05-27"
+#define DC390_VERSION "2.1e 2006-09-04"
 
 #define PCI_DEVICE_ID_AMD53C974 	PCI_DEVICE_ID_AMD_SCSI
 
@@ -2681,7 +2683,7 @@ static int __init dc390_module_init(void
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
_
