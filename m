From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/23] qla2xxx: Correction of comment in MBC opcode defines.
Date: Fri,  8 Feb 2013 01:57:59 -0500
Message-ID: <1360306684-8286-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:25321 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759999Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a8d97f7..6550653 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -768,8 +768,8 @@ typedef struct {
 #define MBC_PORT_LOGOUT			0x56	/* Port Logout request */
 #define MBC_SEND_RNID_ELS		0x57	/* Send RNID ELS request */
 #define MBC_SET_RNID_PARAMS		0x59	/* Set RNID parameters */
-#define MBC_GET_RNID_PARAMS		0x5a	/* Data Rate */
-#define MBC_DATA_RATE			0x5d	/* Get RNID parameters */
+#define MBC_GET_RNID_PARAMS		0x5a	/* Get RNID parameters */
+#define MBC_DATA_RATE			0x5d	/* Data Rate */
 #define MBC_INITIALIZE_FIRMWARE		0x60	/* Initialize firmware */
 #define MBC_INITIATE_LIP		0x62	/* Initiate Loop */
 						/* Initialization Procedure */
-- 
1.7.7

