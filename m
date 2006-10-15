From: Yanko Kaneti <yaneti@declera.com>
Subject: [PATCH] SYM2: claim only "Storage" class, some more
Date: Sun, 15 Oct 2006 22:59:19 +0300
Message-ID: <1160942359.27948.29.camel@indigo.declera.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from indigo.declera.com ([212.116.131.21]:45545 "HELO
	indigo.declera.com") by vger.kernel.org with SMTP id S1422889AbWJOT7W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 15:59:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

The Compaq dl380 that I have here has a 53C1510 of the
PCI_DEVICE_ID_NCR_53C1510 (0x0010) variety and sym2 still claims it so
for me knowing little about scsi/pci/sym2/cpqarray copying Grant
Grundler's PCI_DEVICE_ID_LSI_53C1510 fix seems like the correct thing to
do. (and fixes it for me)

Cheers
Yanko

ps.
I also bugzilla-ed this a week or so ago..
http://bugzilla.kernel.org/show_bug.cgi?id=7279 but perhaps should have
posted here first

Signed-off-by: Yanko Kaneti <yaneti@declera.com>

 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2094,7 +2094,7 @@
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,



