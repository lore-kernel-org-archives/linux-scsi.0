From: akpm@osdl.org
Subject: [patch 27/30] sym53c8xx_2 claims cpqarray device
Date: Mon, 04 Dec 2006 15:18:43 -0800
Message-ID: <200612042319.kB4NJqkh008813@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56980 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967783AbWLDXUh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:20:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, coldwell@redhat.com, willy@debian.org

From: Chip Coldwell <coldwell@redhat.com>

Apropos this thread

http://marc.theaimsgroup.com/?l=linux-scsi&m=115591706804045&w=2

which led to this patch

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920

do we not also need the following patch, nine lines lower in the same file?

Signed-off-by: Chip Coldwell <coldwell@redhat.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx_2-claims-cpqarray-device drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx_2-claims-cpqarray-device
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2094,7 +2094,7 @@ static struct pci_device_id sym2_id_tabl
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	  PCI_ANY_ID, PCI_ANY_ID,  PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,
_
