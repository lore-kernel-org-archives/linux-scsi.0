From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [18/18] qla2xxx: Update driver version
Date: Mon, 21 Jun 2004 23:01:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622060148.GA8538@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:42677 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266612AbUFVF6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:58:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1854 04/06/21 15:35:33 andrew.vasquez@apc.qlogic.com +1 -0
  Update version number to 8.00.00b14-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	2004-06-21 15:40:53 -07:00
+++ b/drivers/scsi/qla2xxx/qla_version.h	2004-06-21 15:40:53 -07:00
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b12-k"
+#define QLA2XXX_VERSION      "8.00.00b14-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	12
+#define QLA_DRIVER_BETA_VER	14
