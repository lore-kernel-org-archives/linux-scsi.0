From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 8/8] qla4xxx: Update driver version to 5.03.00-k10
Date: Thu, 9 May 2013 06:02:12 -0400
Message-ID: <1368093732-8524-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:24937
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab3EIK0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:49 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index fe873cf..c5edd0d 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k9"
+#define QLA4XXX_DRIVER_VERSION	"5.03.00-k10"
-- 
1.8.2.GIT


