From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/3] qla2xxx: Update version number to 8.03.01-k8.
Date: Wed,  2 Dec 2009 10:36:56 -0800
Message-ID: <1259779016-1762-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45736 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754229AbZLBSm7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 13:42:59 -0500
In-Reply-To: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
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
index 807e0db..c482220 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.01-k7"
+#define QLA2XXX_VERSION      "8.03.01-k8"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-- 
1.6.2.rc1.30.gd43c

