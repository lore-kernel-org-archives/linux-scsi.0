From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/4] qla2xxx: Update version number to 8.01.07-k3.
Date: Fri, 13 Oct 2006 09:33:40 -0700
Message-ID: <11607572201738-git-send-email-andrew.vasquez@qlogic.com>
References: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:49888 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751725AbWJMQdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:33:54 -0400
In-Reply-To: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index e57bf45..1fa0bce 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.07-k2"
+#define QLA2XXX_VERSION      "8.01.07-k3"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-- 
1.4.3.rc2.g23bed

