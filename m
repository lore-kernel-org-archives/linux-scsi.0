From: akpm@osdl.org
Subject: [patch 26/26] gdth: fix "&& 0xff" typos
Date: Wed, 08 Nov 2006 19:56:38 -0800
Message-ID: <200611090356.kA93ucpM004030@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14258 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424020AbWKID4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/gdth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-fix-0xff-typos drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-fix-0xff-typos
+++ a/drivers/scsi/gdth.c
@@ -3531,7 +3531,7 @@ static irqreturn_t gdth_interrupt(int ir
                 IStatus &= ~0x80;
 #ifdef INT_COAL
                 if (coalesced)
-                    ha->status = pcs->ext_status && 0xffff;
+                    ha->status = pcs->ext_status & 0xffff;
                 else 
 #endif
                     ha->status = gdth_readw(&dp6m_ptr->i960r.status);
@@ -3543,7 +3543,7 @@ static irqreturn_t gdth_interrupt(int ir
             if (coalesced) {    
                 ha->info = pcs->info0;
                 ha->info2 = pcs->info1;
-                ha->service = (pcs->ext_status >> 16) && 0xffff;
+                ha->service = (pcs->ext_status >> 16) & 0xffff;
             } else
 #endif
             {
_
