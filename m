From: brking@charter.net
Subject: [patch 1/1] megaraid: Add AMI Megaraid card to new driver
Date: Tue, 18 Jan 2005 21:38:42 -0600
Message-ID: <3khj1h$gh2lfq@mxip07a.cluster1.charter.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf36.cluster1.charter.net ([209.225.28.161]:28327 "EHLO
	mxsf36.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S261550AbVASDio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 22:38:44 -0500
Received: from mxip07.cluster1.charter.net (mxip07a.cluster1.charter.net [209.225.28.137])
	by mxsf36.cluster1.charter.net (8.12.11/8.12.11) with ESMTP id j0J3chnn001913
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 22:38:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Atul.Mukker@lsil.com
Cc: linux-scsi@vger.kernel.org, brking@charter.net



Adds AMI Megaraid Elite 1600 to the list of supported
adapters. I encountered some issues running with the old
megaraid driver with this card, so I wrote this patch and
have been running without problems since mid December.
Please apply.

Here is the PCI config space dump of my controller:

0000:03:00.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 02)
00: 1e 10 60 19 16 00 90 22 02 00 04 01 08 40 00 00
10: 08 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 1e 10 93 04
30: 00 00 df df 80 00 00 00 00 00 00 00 0a 01 00 00

Signed-off-by: <brking@charter.net>
---


diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc drivers/scsi/megaraid/megaraid_mbox.c
--- linux-2.6.11-rc1-bk6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc	2005-01-18 18:23:57.000000000 -0600
+++ linux-2.6.11-rc1-bk6-brking/drivers/scsi/megaraid/megaraid_mbox.c	2005-01-18 18:23:57.000000000 -0600
@@ -301,6 +301,12 @@ static struct pci_device_id pci_id_table
 		PCI_SUBSYS_ID_PERC3_SC,
 	},
 	{
+		PCI_VENDOR_ID_AMI,
+		PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_AMI,
+		PCI_SUBSYS_ID_PERC3_DC,
+	},
+	{
 		PCI_VENDOR_ID_LSI_LOGIC,
 		PCI_DEVICE_ID_MEGARAID_SCSI_320_0,
 		PCI_VENDOR_ID_LSI_LOGIC,
_
