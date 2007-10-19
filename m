From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/8] qla2xxx: Resync with latest HBA SSID specification -- 2.2u.
Date: Fri, 19 Oct 2007 15:59:13 -0700
Message-ID: <1192834760-573-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29118 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966599AbXJSW7b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:31 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_devtbl.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_devtbl.h b/drivers/scsi/qla2xxx/qla_devtbl.h
index dd43541..d78d35e 100644
--- a/drivers/scsi/qla2xxx/qla_devtbl.h
+++ b/drivers/scsi/qla2xxx/qla_devtbl.h
@@ -1,4 +1,4 @@
-#define QLA_MODEL_NAMES		0x57
+#define QLA_MODEL_NAMES		0x5C
 
 /*
  * Adapter model names and descriptions.
@@ -91,4 +91,9 @@ static char *qla2x00_model_name[QLA_MODEL_NAMES*2] = {
 	" ",		" ",						/* 0x154 */
 	"QLE220",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x155 */
 	"QLE220",	"PCI-Express to 4Gb FC, Single Channel",	/* 0x156 */
+	" ",		" ",						/* 0x157 */
+	" ",		" ",						/* 0x158 */
+	" ",		" ",						/* 0x159 */
+	" ",		" ",						/* 0x15a */
+	"QME2472",	"Dell BS PCI-Express to 4Gb FC, Dual Channel",	/* 0x15b */
 };
-- 
1.5.3.4.206.g58ba4

