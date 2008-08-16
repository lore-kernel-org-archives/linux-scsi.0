From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [SCSI] removed unused #include <version.h>
Date: Sun, 17 Aug 2008 07:50:50 +0800
Message-ID: <20080817064103.1603.WEIYI.HUANG@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:14173 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYHPXvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Aug 2008 19:51:01 -0400
Received: by ti-out-0910.google.com with SMTP id b6so623856tic.23
        for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2008 16:51:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

The drivers below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/scsi/ips.c
  drivers/scsi/lpfc/lpfc_debugfs.c
  drivers/scsi/nsp32.c
  drivers/scsi/pcmcia/nsp_cs.c
  drivers/scsi/qla2xxx/qla_mid.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7c615c7..bc9e6dd 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -165,7 +165,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/stddef.h>
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 90272e6..094b47e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index edf9fdb..22052bb 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -23,7 +23,6 @@
  *   1.2: PowerPC (big endian) support.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a221b6e..24e6cb8 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -25,7 +25,6 @@
 
 ***********************************************************************/
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 50baf6a..93560cd 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -6,7 +6,6 @@
  */
 #include "qla_def.h"
 
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>

