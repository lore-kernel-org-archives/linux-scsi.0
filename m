From: vikas.chaudhary@qlogic.com
Subject: [PATCH 5/5] qla4xxx: Update driver version to 5.03.00-k9
Date: Wed, 17 Apr 2013 05:15:30 -0400
Message-ID: <1366190130-16556-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:17556 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754661Ab3DQJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 05:39:14 -0400
In-Reply-To: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 83e0fec..fe873cf 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k8"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k9"
-- 
1.8.2.GIT

