From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/5]  qla2xxx: update version :)
Date: Wed, 13 Apr 2005 13:50:07 -0700
Message-ID: <20050413205007.GA14857@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:8048 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261193AbVDMUuM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 16:50:12 -0400
Content-Disposition: inline
In-Reply-To: <20050413191548.GI9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

  Update version.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_version.h	2005-04-13 08:56:07.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_version.h	2005-04-13 08:58:47.000000000 -0700
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.02b4-k"
+#define QLA2XXX_VERSION      "8.00.02b5-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	2
-#define QLA_DRIVER_BETA_VER	4
+#define QLA_DRIVER_BETA_VER	5
