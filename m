From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] drivers_scsi_sym53c8xx_2_sym_glue.c, typo: the the
Date: Tue, 20 Aug 2002 19:00:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020820041037.60BC02C24F@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Gerard Roudier <groudier@free.fr>

From:  James Mayer <james@cobaltmountain.com>


--- trivial-2.4.20-pre4/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2002-08-20 18:00:47.000000000 +1000
+++ trivial-2.4.20-pre4/drivers/scsi/sym53c8xx_2/sym_glue.c	2002-08-20 18:00:47.000000000 +1000
@@ -2715,7 +2715,7 @@
  *  differ and attach them using the order in the NVRAM.
  *
  *  If no NVRAM is found or data appears invalid attach boards in 
- *  the the order they are detected.
+ *  the order they are detected.
  */
 int __init sym53c8xx_detect(Scsi_Host_Template *tpnt)
 {
-- 
  Don't blame me: the Monkey is driving
  File: James Mayer <james@cobaltmountain.com>: drivers_scsi_sym53c8xx_2_sym_glue.c, typo: the the
