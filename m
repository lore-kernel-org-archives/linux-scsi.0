From: Brian King <brking@charter.net>
Subject: [PATCH] Add AMI Megaraid card to new driver (resend)
Date: Tue, 18 Jan 2005 18:32:45 -0600
Message-ID: <41EDAAAD.60308@charter.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090107020703050706000605"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf29.cluster1.charter.net ([209.225.28.229]:15006 "EHLO
	mxsf29.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S261505AbVASAcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 19:32:48 -0500
Received: from mxip06.cluster1.charter.net (mxip06a.cluster1.charter.net [209.225.28.136])
	by mxsf29.cluster1.charter.net (8.12.11/8.12.11) with ESMTP id j0J0Wkwx031722
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2005 19:32:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090107020703050706000605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------090107020703050706000605
Content-Type: text/x-patch;
 name="megaraid_ami_perc3dc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid_ami_perc3dc.patch"


This is the fourth submission of this patch. I have still
had no response from the maintainer.

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
--- linux-2.6.11-rc1-bk6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc	2005-01-18 18:23:57.095273612 -0600
+++ linux-2.6.11-rc1-bk6-brking/drivers/scsi/megaraid/megaraid_mbox.c	2005-01-18 18:23:57.100272474 -0600
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

--------------090107020703050706000605--
