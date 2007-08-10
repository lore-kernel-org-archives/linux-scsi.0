From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 10/30] megaraid: add CERC_ATA100 support
Date: Fri, 10 Aug 2007 16:20:54 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229BF18C7@NAMAIL2.ad.lsil.com>
References: <200708102150.l7ALodH3011345@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38544 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXHJWXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 18:23:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200708102150.l7ALodH3011345@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, tkrah@fachschaft.imn.htwk-leipzig.de, protasnb@gmail.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>


NACK. 

ID being added is already supported in megaraid_mbox driver.

--Sumant

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Friday, August 10, 2007 2:51 PM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
tkrah@fachschaft.imn.htwk-leipzig.de; protasnb@gmail.com
Subject: [patch 10/30] megaraid: add CERC_ATA100 support

From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=6695

Add support for this device to the old megaraid driver.

Cc: Natalie Protasevich <protasnb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    2 ++
 drivers/scsi/megaraid.h |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/megaraid.c~megaraid-add-cerc_ata100-support
drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-add-cerc_ata100-support
+++ a/drivers/scsi/megaraid.c
@@ -4967,6 +4967,8 @@ static struct pci_device_id megaraid_pci
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_DELL, PCI_SUBSYS_ID_CERC_ATA100, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
diff -puN drivers/scsi/megaraid.h~megaraid-add-cerc_ata100-support
drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-add-cerc_ata100-support
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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
