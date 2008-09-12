From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/8] qla2xxx: Update version number to 8.02.01-k8.
Date: Thu, 11 Sep 2008 21:22:54 -0700
Message-ID: <1221193374-77635-9-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYILEXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:23:01 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 4160e4c..be5e299 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k7"
+#define QLA2XXX_VERSION      "8.02.01-k8"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
-- 
1.6.0.1.294.gda06a

