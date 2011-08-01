From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][Resend] Remove unneeded version.h includes from
 drivers/scsi/
Date: Mon, 1 Aug 2011 23:27:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108012325281.31999@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14686 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1HAV1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 17:27:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org, devel@open-fcoe.org, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jing Huang <huangj@brocade.com>, Robert Love <robert.w.love@intel.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, Kashyap Desai <kashyap.desai@lsi.com>, Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiangliang Yu <yuxiangl@marvell.com>

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/scsi/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/aacraid/src.c            |    1 -
 drivers/scsi/bfa/bfad_drv.h           |    1 -
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c    |    1 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c    |    1 -
 drivers/scsi/fcoe/fcoe.c              |    1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c    |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    1 -
 drivers/scsi/mvsas/mv_sas.h           |    1 -
 drivers/scsi/pmcraid.c                |    1 -
 drivers/scsi/pmcraid.h                |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index c204946..957595a 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/completion.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index bda999a..5e19a5f 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -27,7 +27,6 @@
 #define __BFAD_DRV_H__
 
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index bd22041..f4aa637 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -14,7 +14,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index ae13c49..31c79bd 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -13,7 +13,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba710e3..300586d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 83035bd..6825772 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 6861244..2b11010 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 38ed026..246d5fb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6abd2fc..5202de3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 44d7885..44b4745 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -43,7 +43,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
-#include <linux/version.h>
 #include "mv_defs.h"
 
 #define DRV_NAME		"mvsas"
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d079f9a..b86db84 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/hdreg.h>
-#include <linux/version.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <asm/irq.h>
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index f920baf..ca496c7 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -24,7 +24,6 @@
 #ifndef _PMCRAID_H
 #define _PMCRAID_H
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/completion.h>
 #include <linux/list.h>
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

