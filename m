From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [11/11]  qla2xxx: Update driver version
Date: Wed, 8 Dec 2004 23:42:39 -0800
Message-ID: <20041209074239.GA22158@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:24973 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261482AbULIHmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:42:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2245 04/12/08 22:04:04 andrew.vasquez@qlogic.com +1 -0
  Update version number to 8.00.02b4-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	2004-12-08 22:18:01 -08:00
+++ b/drivers/scsi/qla2xxx/qla_version.h	2004-12-08 22:18:01 -08:00
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b21-k"
+#define QLA2XXX_VERSION      "8.00.02b4-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
-#define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	21
+#define QLA_DRIVER_PATCH_VER	2
+#define QLA_DRIVER_BETA_VER	4
