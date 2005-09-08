From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/8] aacraid: add name to driver template
Date: Thu, 08 Sep 2005 13:50:19 -0700
Message-ID: <1126212619.7479.22.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51117 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751393AbVIHUxa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec.

This permits the system log to report the Adapter's branded name rather than
the generic 'AAC' that it currently reports.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:04.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:27.000000000 -0700
@@ -765,6 +765,7 @@
 	
 	pci_set_master(pdev);
 
+	aac_driver_template.name = aac_drivers[index].name;
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
 	if (!shost)
 		goto out_disable_pdev;

-- 
Mark Haverkamp <markh@osdl.org>

