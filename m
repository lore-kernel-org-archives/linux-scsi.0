From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Correct kmalloc check: drivers_scsi_dpt_i2o.c
Date: Thu, 06 Feb 2003 14:11:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.ABB8E2C361@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: deanna_bonds@adaptec.com, linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Pablo Menichini <pablo@menichini.com.ar>

  Best regards,
          Pablo
  

--- trivial-2.4.21-pre4/drivers/scsi/dpt_i2o.c.orig	2003-02-06 13:53:50.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/dpt_i2o.c	2003-02-06 13:53:50.000000000 +1100
@@ -1498,7 +1498,7 @@
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
