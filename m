From: akpm@osdl.org
Subject: [patch 13/19] megaraid: Dell CERC ATA100/4ch support
Date: Fri, 07 Jul 2006 00:02:14 -0700
Message-ID: <200607070702.k6772EYe030639@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:27587 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751240AbWGGHDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2006 03:03:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jkrzyszt@tis.icnet.pl


From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Add CERC subsystem ids to the old megaraid driver.  Tested, works.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    2 ++
 drivers/scsi/megaraid.h |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/megaraid.c~megaraid-dell-cerc-ata100-4ch-support drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-dell-cerc-ata100-4ch-support
+++ a/drivers/scsi/megaraid.c
@@ -5047,6 +5047,8 @@ static struct pci_device_id megaraid_pci
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_DELL, PCI_SUBSYS_ID_CERC_ATA100, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
diff -puN drivers/scsi/megaraid.h~megaraid-dell-cerc-ata100-4ch-support drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-dell-cerc-ata100-4ch-support
+++ a/drivers/scsi/megaraid.h
@@ -84,6 +84,8 @@
 #define LSI_SUBSYS_VID			0x1000
 #define INTEL_SUBSYS_VID		0x8086
 
+#define PCI_SUBSYS_ID_CERC_ATA100	0x0511
+
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
 #define HBA_SIGNATURE_64BIT		0x0299
_
