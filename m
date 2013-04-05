From: vikas.chaudhary@qlogic.com
Subject: [PATCH 5/5] qla4xxx: Update driver version to 5.03.00-k8
Date: Fri,  5 Apr 2013 07:06:10 -0400
Message-ID: <1365159970-17672-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:61845 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751070Ab3DEL3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:51 -0400
In-Reply-To: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index 18ad425..83e0fec 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k7"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k8"
-- 
1.8.2.GIT

