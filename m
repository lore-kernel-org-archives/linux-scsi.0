From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [8/8]  qla2xxx: Update version
Date: Mon, 6 Sep 2004 21:30:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907043004.GA29748@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:63372 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267594AbUIGEbw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:31:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1878 04/09/06 12:04:22 andrew.vasquez@qlogic.com +1 -0
  Update version number to 8.00.00b21-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	2004-09-06 12:08:43 -07:00
+++ b/drivers/scsi/qla2xxx/qla_version.h	2004-09-06 12:08:43 -07:00
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b15-k"
+#define QLA2XXX_VERSION      "8.00.00b21-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	15
+#define QLA_DRIVER_BETA_VER	21
