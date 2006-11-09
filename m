From: akpm@osdl.org
Subject: [patch 2/2] libsas fails to compile on s390
Date: Wed, 08 Nov 2006 19:57:09 -0800
Message-ID: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32178 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424021AbWKID5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:57:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, schwidefsky@de.ibm.com

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Explicitly include scatterlist.h in sas_internal.h to avoid the implicit
include dependency via the pci.h header.  For s390 the scatterlist.h header
is not included because CONFIG_PCI=n.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/libsas/sas_internal.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/libsas/sas_internal.h~libsas-fails-to-compile-on-s390 drivers/scsi/libsas/sas_internal.h
--- a/drivers/scsi/libsas/sas_internal.h~libsas-fails-to-compile-on-s390
+++ a/drivers/scsi/libsas/sas_internal.h
@@ -26,6 +26,7 @@
 #ifndef _SAS_INTERNAL_H_
 #define _SAS_INTERNAL_H_
 
+#include <linux/scatterlist.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_sas.h>
_
