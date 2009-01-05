From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/8] qla2xxx: Don't pollute kernel logs with ZIO/RIO status messages.
Date: Mon,  5 Jan 2009 11:18:07 -0800
Message-ID: <1231183092-10471-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZAETSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:16 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6447eb1..5ff6f94 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -638,10 +638,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
-		DEBUG2(printk("scsi(%ld): [R|Z]IO update completion.\n",
-		    vha->host_no));
-		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): [R|Z]IO update completion.\n",
+		DEBUG3(printk("scsi(%ld): [R|Z]IO update completion.\n",
 		    vha->host_no));
 
 		if (IS_FWI2_CAPABLE(ha))
-- 
1.6.1.28.gc32f76

