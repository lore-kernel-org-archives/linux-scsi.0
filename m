From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Correct Kernel Panic with Qlogic 2472 Card.
Date: Sun,  8 Feb 2009 20:50:15 -0800
Message-ID: <1234155016-6215-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZBIEuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:24 -0500
In-Reply-To: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Shyam Iyer <shyam_iyer@dell.com>

From: Shyam Iyer <shyam_iyer@dell.com>

Kernel Panic is observed with a Qlogic 2472 Card is plugged into the
system and the qla2xxx driver is loaded.

The attached patch fixes the issue.

Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
Acked-by: Seokmann Ju <Seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_devtbl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
index d78d35e..d6ea69d 100644
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -72,7 +72,7 @@ static char *qla2x00_model_name[QLA_MODEL_NAMES*2] = {
 	"QLA2462",	"Sun PCI-X 2.0 to 4Gb FC, Dual Channel",	/* 0x141 */
 	"QLE2460",	"Sun PCI-Express to 2Gb FC, Single Channel",	/* 0x142 */
 	"QLE2462",	"Sun PCI-Express to 4Gb FC, Single Channel",	/* 0x143 */
-	"QEM2462"	"Server I/O Module 4Gb FC, Dual Channel",	/* 0x144 */
+	"QEM2462",	"Server I/O Module 4Gb FC, Dual Channel",	/* 0x144 */
 	"QLE2440",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x145 */
 	"QLE2464",	"PCI-Express to 4Gb FC, Quad Channel",		/* 0x146 */
 	"QLA2440",	"PCI-X 2.0 to 4Gb FC, Single Channel",		/* 0x147 */
-- 
1.6.1.48.ge9b8

