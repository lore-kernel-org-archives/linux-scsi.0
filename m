From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 37/37] smartpqi: bump driver version
Date: Tue, 25 Apr 2017 14:49:38 -0500
Message-ID: <149314977832.13903.9156047611774470262.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:6368
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1038958AbdDYTuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:50:02 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cf13f3e..ef5ccb2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -40,13 +40,14 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"0.9.13-370"
-#define DRIVER_MAJOR		0
-#define DRIVER_MINOR		9
-#define DRIVER_RELEASE		13
-#define DRIVER_REVISION		370
-
-#define DRIVER_NAME		"Microsemi PQI Driver (v" DRIVER_VERSION ")"
+#define DRIVER_VERSION		"1.0.4-100"
+#define DRIVER_MAJOR		1
+#define DRIVER_MINOR		0
+#define DRIVER_RELEASE		4
+#define DRIVER_REVISION		100
+
+#define DRIVER_NAME		"Microsemi PQI Driver (v" \
+				DRIVER_VERSION BUILD_TIMESTAMP ")"
 #define DRIVER_NAME_SHORT	"smartpqi"
 
 #define PQI_EXTRA_SGL_MEMORY	(12 * sizeof(struct pqi_sg_descriptor))
