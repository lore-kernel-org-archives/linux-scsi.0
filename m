From: vikas.chaudhary@qlogic.com
Subject: [PATCH 8/8] qla4xxx: Update driver version to 5.03.00-k5
Date: Thu,  7 Mar 2013 05:43:14 -0500
Message-ID: <1362652994-7593-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:16730 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756384Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index 6775a45..4540028 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k4"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k5"
-- 
1.8.0

