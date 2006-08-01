From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/4] qla2xxx: Update version number to 8.01.05-k4.
Date: Tue,  1 Aug 2006 13:48:16 -0700
Message-ID: <1154465296938-git-send-email-andrew.vasquez@qlogic.com>
References: <20060801204542.GR4154@jdlab1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35231 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751015AbWHAUtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 16:49:19 -0400
In-Reply-To: <20060801204542.GR4154@jdlab1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index d2d6834..f5826bf 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.05-k3"
+#define QLA2XXX_VERSION      "8.01.05-k4"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-- 
1.4.2.rc2.gbc9e

