From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/4] qla4xxx: Update driver version to 5.04.00-k1
Date: Fri, 23 Aug 2013 03:40:21 -0400
Message-ID: <1377243621-32107-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:21753 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137Ab3HWIKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 04:10:13 -0400
In-Reply-To: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index 7bce207..f4fef72 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.04.00-k0"
+#define QLA4XXX_DRIVER_VERSION	"5.04.00-k1"
-- 
1.8.2.GIT

