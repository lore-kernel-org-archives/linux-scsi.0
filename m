From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/4] qla4xxx: Update driver version to 5.04.00-k0
Date: Fri, 16 Aug 2013 07:03:05 -0400
Message-ID: <1376650985-11416-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41702 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547Ab3HPMCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 08:02:08 -0400
In-Reply-To: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
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
index 28e8306..7bce207 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.03.00-k11"
+#define QLA4XXX_DRIVER_VERSION	"5.04.00-k0"
-- 
1.8.2.GIT

