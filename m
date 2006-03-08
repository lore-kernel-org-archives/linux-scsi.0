From: ravi.anand@qlogic.com
Subject: [PATCH 04/11] Consolidate #include definitions.
Date: Tue, 7 Mar 2006 16:35:32 -0800
Message-ID: <11417781271944-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8432 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964851AbWCHAfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:36 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_def.h  |    2 ++
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 --
 drivers/scsi/qla4xxx/ql4_init.c |    2 --
 drivers/scsi/qla4xxx/ql4_mbx.c  |    2 --
 drivers/scsi/qla4xxx/ql4_os.c   |    4 ----
 5 files changed, 2 insertions(+), 10 deletions(-)

41d009988af1d11ab61a9e3c9e828baf735becc8
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 9eee21f..98c5922 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -22,12 +22,14 @@
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
 /* XXX(dg): move to pci_ids.h */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index c457151..530a7f6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -8,8 +8,6 @@
 #ifndef __QLA4x_GBL_H
 #define	__QLA4x_GBL_H
 
-#include <linux/interrupt.h>
-
 /*
  * Defined in ql4_os.c
  */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 16dfb26..6d10809 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -7,8 +7,6 @@
 
 #include "ql4_def.h"
 
-#include <linux/delay.h>
-
 /*
 *  QLogic ISP4xxx Hardware Support Function Prototypes.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 6959adc..0dd350b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -7,8 +7,6 @@
 
 #include "ql4_def.h"
 
-#include <linux/delay.h>
-
 /*
  * externals
  */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1578aa0..1271edf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7,14 +7,10 @@
 
 #include "ql4_def.h"
 
-#include <linux/delay.h>
-#include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_iscsi.h>
 
 /*
  * Driver version
-- 
1.2.4.g9201-dirty


