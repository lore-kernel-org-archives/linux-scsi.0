From: Brian King <brking@charter.net>
Subject: [PATCH] Add AMI Megaraid card to new driver
Date: Sun, 12 Dec 2004 23:08:32 -0600
Message-ID: <41BD23D0.9060105@charter.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080609060001000401070601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf26.cluster1.charter.net ([209.225.28.226]:29142 "EHLO
	mxsf26.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S262026AbULMFIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2004 00:08:34 -0500
Received: from mxip07.cluster1.charter.net (mxip07a.cluster1.charter.net [209.225.28.137])
	by mxsf26.cluster1.charter.net (8.12.11/8.12.11) with ESMTP id iBD58XdY031573
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 00:08:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Atul.Mukker@lsil.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080609060001000401070601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------080609060001000401070601
Content-Type: text/x-patch;
 name="megaraid_ami_perc3dc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid_ami_perc3dc.patch"


Adds AMI Megaraid Elite 1600 to the list of supported
adapters. I encountered some issues running with the old
megaraid driver with this card, so I wrote this patch and
have been running without problems for several days now.
Please apply.


---


diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc drivers/scsi/megaraid/megaraid_mbox.c
--- linux-2.6.10-rc3-bk6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc	2004-12-12 22:58:17.235599413 -0600
+++ linux-2.6.10-rc3-bk6-brking/drivers/scsi/megaraid/megaraid_mbox.c	2004-12-12 22:59:49.594673649 -0600
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

--------------080609060001000401070601--
