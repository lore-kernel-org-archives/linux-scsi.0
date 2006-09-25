From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH]: Switch ips to pci_register from pci_module
Date: Mon, 25 Sep 2006 23:45:51 +0100
Message-ID: <1159224351.11049.168.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35561 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751529AbWIYWVC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 18:21:02 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by lxorguk.ukuu.org.uk (8.13.6/8.13.4) with ESMTP id k8PMjqDB022225
	for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2006 23:45:52 +0100
Received: (from alan@localhost)
	by localhost.localdomain (8.13.6/8.13.6/Submit) id k8PMjpMD022224
	for linux-scsi@vger.kernel.org; Mon, 25 Sep 2006 23:45:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-mm1/drivers/scsi/ips.c linux-2.6.18-mm1/drivers/scsi/ips.c
--- linux.vanilla-2.6.18-mm1/drivers/scsi/ips.c	2006-09-25 12:08:54.000000000 +0100
+++ linux-2.6.18-mm1/drivers/scsi/ips.c	2006-09-25 12:26:15.000000000 +0100
@@ -7078,7 +7078,7 @@
 static int __init
 ips_module_init(void)
 {
-	if (pci_module_init(&ips_pci_driver) < 0)
+	if (pci_register_driver(&ips_pci_driver) < 0)
 		return -ENODEV;
 	ips_driver_template.module = THIS_MODULE;
 	ips_order_controllers();

