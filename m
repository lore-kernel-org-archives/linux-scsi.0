From: akpm@osdl.org
Subject: [patch 17/20] enable advansys driver
Date: Thu, 27 Apr 2006 02:33:09 -0700
Message-ID: <200604270934.k3R9YcKZ025485@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14288 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965042AbWD0Jex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:34:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@steeleye.com


From: Andrew Morton <akpm@osdl.org>

Apparently it works OK.  It was marked broken because:

 >> ChangeSet@1.497.4282.43, 2004-06-26 10:50:12-05:00, jejb@mulgrave.(none)
 >>   advansys: add warning and convert #includes
 >>
 >>   The DMA conversion of the advansys driver is still
 >>   broken.  Add a #warning to the driver and a comment
 >>   above it explaining what needs to be done.
 >>
 >>   Mark the driver as BROKEN because of the warning
 >>
 >>   Also remove the #include "scsi.h"
 >>
 >>   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~enable-advansys-driver drivers/scsi/Kconfig
--- devel/drivers/scsi/Kconfig~enable-advansys-driver	2006-04-22 01:39:22.000000000 -0700
+++ devel-akpm/drivers/scsi/Kconfig	2006-04-22 01:39:22.000000000 -0700
@@ -446,7 +446,7 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on (ISA || EISA || PCI) && SCSI && BROKEN
+	depends on (ISA || EISA || PCI) && SCSI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
_
