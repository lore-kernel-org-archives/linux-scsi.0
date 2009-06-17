From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/5] qla2xxx: Update version number to 8.03.01-k4.
Date: Wed, 17 Jun 2009 10:30:32 -0700
Message-ID: <1245259832-8595-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936AbZFQRad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:33 -0400
In-Reply-To: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index b63feaf..8436970 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.01-k3"
+#define QLA2XXX_VERSION      "8.03.01-k4"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-- 
1.6.3.2.306.g4f4fa

