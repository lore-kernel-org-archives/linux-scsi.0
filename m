From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH V1 4/4] qla4xxx: Update driver version to 5.03.00-k10
Date: Wed, 26 Jun 2013 08:11:34 -0400
Message-ID: <1372248694-3928-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:27599
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab3FZMiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 08:38:03 -0400
In-Reply-To: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

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


