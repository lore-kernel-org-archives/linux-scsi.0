From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][13/37] Clean up duplicate includes in drivers/scsi/
Date: Sat, 21 Jul 2007 17:02:53 +0200
Message-ID: <200707211702.53876.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939180AbXGUPDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jul 2007 11:03:51 -0400
Received: by ug-out-1314.google.com with SMTP id j3so799632ugf
        for <linux-scsi@vger.kernel.org>; Sat, 21 Jul 2007 08:03:50 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jesper.juhl@gmail.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, James Smart <james.smart@emulex.com>, Christoph Hellwig <hch@infradead.org>

Hi,

This patch cleans up duplicate includes in
	drivers/scsi/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 3a80897..e0f1991 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -97,7 +97,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mca.h>
-#include <linux/interrupt.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 673cfe1..039892c 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 07bd0dc..3a51266 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
