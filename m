From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/13] qla2xxx: Update version number to 8.01.05-k3.
Date: Fri, 23 Jun 2006 16:11:32 -0700
Message-ID: <11511042872863-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:21682 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752168AbWFWXLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:32 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 6b31552..d2d6834 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.05-k2"
+#define QLA2XXX_VERSION      "8.01.05-k3"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-- 
1.4.1.rc1.gf603


