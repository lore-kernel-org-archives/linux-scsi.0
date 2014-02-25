From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 10/10] qla4xxx: Update driver version to 5.04.00-k5
Date: Mon, 24 Feb 2014 22:07:05 -0500
Message-ID: <1393297625-928-11-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:16035 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbaBYDpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:45:05 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index c6ba0a6..bd78cb3 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.04.00-k4"
+#define QLA4XXX_DRIVER_VERSION	"5.04.00-k5"
-- 
1.8.2.GIT

