From: akpm@linux-foundation.org
Subject: [patch 09/30] Clean up duplicate includes in drivers/scsi/
Date: Fri, 10 Aug 2007 14:50:38 -0700
Message-ID: <200708102150.l7ALocW5011342@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbXHJVv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jesper.juhl@gmail.com, james.smart@emulex.com

From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/scsi/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR_D700.c          |    1 -
 drivers/scsi/lpfc/lpfc_debugfs.c |    1 -
 drivers/scsi/lpfc/lpfc_init.c    |    1 -
 3 files changed, 3 deletions(-)

diff -puN drivers/scsi/NCR_D700.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/NCR_D700.c
@@ -97,7 +97,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mca.h>
-#include <linux/interrupt.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
diff -puN drivers/scsi/lpfc/lpfc_init.c~clean-up-duplicate-includes-in-drivers-scsi drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~clean-up-duplicate-includes-in-drivers-scsi
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
_
