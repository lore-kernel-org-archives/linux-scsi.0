From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/4] qla2xxx: Update version number to 8.02.00-k9.
Date: Thu, 28 Feb 2008 14:06:12 -0800
Message-ID: <1204236372-19080-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080228220509.GE18083@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21379 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYB1WG2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 17:06:28 -0500
In-Reply-To: <20080228220509.GE18083@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index c5742cc..ea08a12 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.00-k8"
+#define QLA2XXX_VERSION      "8.02.00-k9"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
-- 
1.5.4.3.230.g2db511

