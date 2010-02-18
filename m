From: James Smart <james.smart@emulex.com>
Subject: [PATCH] lpfc: correct linux-next: PPC build failure
Date: Thu, 18 Feb 2010 11:07:15 -0500
Message-ID: <1266509235.29149.9.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:29197 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544Ab0BRQHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2010 11:07:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-next@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, sfr@canb.auug.org.au

This corrects a linux-next build issue on PPC64

-- james s

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-02-17 09:26:47.000000000 -0500
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/mempool.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>


