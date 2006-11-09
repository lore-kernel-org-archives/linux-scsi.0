From: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] gdth: Fix && typos
Date: Thu, 9 Nov 2006 21:45:09 +0100
Message-ID: <20061109214509.c4edee59.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:30729 "EHLO
	mallaury.nerim.net") by vger.kernel.org with ESMTP id S965964AbWKIUpH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 15:45:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Fix uses of "&&" where "&" was obviously intended instead.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/scsi/gdth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19-rc5.orig/drivers/scsi/gdth.c	2006-10-14 09:47:29.000000000 +0200
+++ linux-2.6.19-rc5/drivers/scsi/gdth.c	2006-11-09 21:39:06.000000000 +0100
@@ -3531,7 +3531,7 @@
                 IStatus &= ~0x80;
 #ifdef INT_COAL
                 if (coalesced)
-                    ha->status = pcs->ext_status && 0xffff;
+                    ha->status = pcs->ext_status & 0xffff;
                 else 
 #endif
                     ha->status = gdth_readw(&dp6m_ptr->i960r.status);
@@ -3543,7 +3543,7 @@
             if (coalesced) {    
                 ha->info = pcs->info0;
                 ha->info2 = pcs->info1;
-                ha->service = (pcs->ext_status >> 16) && 0xffff;
+                ha->service = (pcs->ext_status >> 16) & 0xffff;
             } else
 #endif
             {


-- 
Jean Delvare
