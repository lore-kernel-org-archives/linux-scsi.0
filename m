From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/5]  qla2xxx: Update version
Date: Mon, 12 Jul 2004 07:06:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712140658.GA6975@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:35738 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263555AbUGLVS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:18:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1869 04/07/12 09:53:48 andrew.vasquez@apc.qlogic.com +1 -0
  Update version number to 8.00.00b15-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	2004-07-12 09:55:21 -07:00
+++ b/drivers/scsi/qla2xxx/qla_version.h	2004-07-12 09:55:21 -07:00
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b14-k"
+#define QLA2XXX_VERSION      "8.00.00b15-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	14
+#define QLA_DRIVER_BETA_VER	15
