From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/6] qla2xxx: Update version number to 8.01.07-k7.
Date: Mon,  7 May 2007 07:43:03 -0700
Message-ID: <11785489834027-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47147 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbXEGOnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:32 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index dc85495..c375a4e 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.07-k6"
+#define QLA2XXX_VERSION      "8.01.07-k7"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-- 
1.5.2.rc1.9.g6644

