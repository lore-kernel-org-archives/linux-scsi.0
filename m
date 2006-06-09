From: akpm@osdl.org
Subject: [patch 28/31] megaraid_sas-add-support-for-zcr-controller-fix
Date: Thu, 08 Jun 2006 22:23:59 -0700
Message-ID: <200606090523.k595NxY3032355@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:47069 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965193AbWFIFY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, hch@lst.de, Sumant.Patro@lsil.com


From: Andrew Morton <akpm@osdl.org>

Cc: Sumant Patro <Sumant.Patro@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    1 +
 scsi/megaraid/megaraid_sas.h         |    0 
 2 files changed, 1 insertion(+)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~megaraid_sas-add-support-for-zcr-controller-fix Documentation/scsi/ChangeLog.megaraid_sas
diff -puN drivers/scsi/megaraid/megaraid_sas.c~megaraid_sas-add-support-for-zcr-controller-fix drivers/scsi/megaraid/megaraid_sas.c
--- devel/drivers/scsi/megaraid/megaraid_sas.c~megaraid_sas-add-support-for-zcr-controller-fix	2006-05-29 20:28:27.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid/megaraid_sas.c	2006-05-29 20:28:27.000000000 -0700
@@ -65,6 +65,7 @@ static struct pci_device_id megasas_pci_
 	 PCI_ANY_ID,
 	 PCI_ANY_ID,
 	},
+	{
 	 PCI_VENDOR_ID_LSI_LOGIC,
 	 PCI_DEVICE_ID_LSI_VERDE_ZCR,	/* xscale IOP, vega */
 	 PCI_ANY_ID,
diff -puN drivers/scsi/megaraid/megaraid_sas.h~megaraid_sas-add-support-for-zcr-controller-fix drivers/scsi/megaraid/megaraid_sas.h
_
