From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/3] smartpqi: update driver version to 1.1.2-126
Date: Wed, 27 Sep 2017 16:30:11 -0500
Message-ID: <150654781171.11494.5262947088292549405.stgit@brunhilda>
References: <150654770573.11494.168365142464423047.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0048.outbound.protection.outlook.com ([104.47.38.48]:49129
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdI0Vaf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 17:30:35 -0400
In-Reply-To: <150654770573.11494.168365142464423047.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index be83d92..8fe9183 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -40,11 +40,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.1.2-125"
+#define DRIVER_VERSION		"1.1.2-126"
 #define DRIVER_MAJOR		1
 #define DRIVER_MINOR		1
 #define DRIVER_RELEASE		2
-#define DRIVER_REVISION		125
+#define DRIVER_REVISION		126
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
