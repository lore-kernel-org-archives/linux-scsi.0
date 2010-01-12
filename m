From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/4] qla2xxx: Update version number to 8.03.01-k10.
Date: Tue, 12 Jan 2010 12:59:51 -0800
Message-ID: <1263329991-307-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54865 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752259Ab0ALU74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 15:59:56 -0500
In-Reply-To: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index a65dd95..ed36279 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.01-k9"
+#define QLA2XXX_VERSION      "8.03.01-k10"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-- 
1.6.2.rc1.30.gd43c

