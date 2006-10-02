From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/8] qla2xxx: Update version number to 8.01.07-k2.
Date: Mon,  2 Oct 2006 12:00:50 -0700
Message-ID: <11598156513969-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964953AbWJBTAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:55 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 9712590..e57bf45 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.07-k1"
+#define QLA2XXX_VERSION      "8.01.07-k2"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-- 
1.4.2.3.gf59615

