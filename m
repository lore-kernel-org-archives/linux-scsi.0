From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2.6] add adapter support to aacraid driver
Date: Fri, 12 Mar 2004 10:22:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079115773.23909.55.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:32472 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262385AbUCLSW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 13:22:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

This patch adds support for another adapter.

===== drivers/scsi/aacraid/linit.c 1.26 vs edited =====
--- 1.26/drivers/scsi/aacraid/linit.c	Fri Feb 13 05:57:38 2004
+++ edited/drivers/scsi/aacraid/linit.c	Fri Mar 12 09:50:29 2004
@@ -116,6 +116,7 @@
 	{ 0x9005, 0x0285, 0x0E11, 0x0295, 0, 0, 30 }, /* SATA 6Ch (Bearcat) */
 
 	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 31 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 32 }, /* ASR-2020S PCI-X ZCR (Skyhawk) */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -162,6 +163,7 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "SATA 6Channel   ", 1 }, /* SATA 6Ch (Bearcat) */
 
 	{ aac_rkt_init,"aacraid",  "ADAPTEC ", "ASR-2230S PCI-X ", 2 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 1 }, /* ASR-2020S PCI-X ZCR (Skyhawk) */
 };
 
 /**

-- 
Mark Haverkamp <markh@osdl.org>

