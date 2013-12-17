From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 20/20] qla2xxx: Update the driver version to 8.07.00.02-k.
Date: Mon, 16 Dec 2013 22:28:43 -0500
Message-ID: <1387250923-1041-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:24619 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab3LQEBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:01:39 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 31d1953..e36b947 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.06.00.12-k"
+#define QLA2XXX_VERSION      "8.07.00.02-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	6
+#define QLA_DRIVER_MINOR_VER	7
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
1.7.7

