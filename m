From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [15/15] qla2xxx: Update driver version
Date: Thu, 6 May 2004 23:00:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507060000.GA5064@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:50317 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263219AbUEGF6Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:58:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1936 04/04/30 15:39:30 andrew.vasquez@apc.qlogic.com +1 -0
  Update version number to 8.00.00b12-k.

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	Mon May  3 15:17:14 2004
+++ b/drivers/scsi/qla2xxx/qla_version.h	Mon May  3 15:17:14 2004
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b11-k"
+#define QLA2XXX_VERSION      "8.00.00b12-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	11
+#define QLA_DRIVER_BETA_VER	12
