From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Correct kmalloc check: drivers_scsi_dpt_i2o.c
Date: Mon, 06 Jan 2003 14:58:03 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106041152.AFA7F2C2BE@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: deanna_bonds@adaptec.com, linux-scsi@vger.kernel.org

From:  Pablo Menichini <pablo@menichini.com.ar>

  Best regards,
          Pablo
  

--- trivial-2.5-bk/drivers/scsi/dpt_i2o.c.orig	2003-01-06 14:10:56.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/dpt_i2o.c	2003-01-06 14:10:56.000000000 +1100
@@ -1491,7 +1491,7 @@
 							pDev->next_lun; pDev = pDev->next_lun){
 					}
 					pDev->next_lun = kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
-					if(pDev == NULL) {
+					if(pDev->next_lun == NULL) {
 						return -ENOMEM;
 					}
 					memset(pDev->next_lun,0,sizeof(struct adpt_device));
-- 
  Don't blame me: the Monkey is driving
  File: Pablo Menichini <pablo@menichini.com.ar>: [PATCH][2.5.53] Correct kmalloc check: drivers_scsi_dpt_i2o.c
