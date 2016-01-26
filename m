From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 11/11] qla2xxx: Update driver version to 8.07.00.33-k
Date: Tue, 26 Jan 2016 12:10:46 -0500
Message-ID: <1453828246-28686-12-git-send-email-himanshu.madhani@qlogic.com>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15834 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756940AbcAZRxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 12:53:19 -0500
In-Reply-To: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 6d31faa..0bc93fa 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.07.00.26-k"
+#define QLA2XXX_VERSION      "8.07.00.33-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	7
-- 
1.7.7

