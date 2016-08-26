From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 17/17] smartqi: bump driver version
Date: Fri, 26 Aug 2016 11:45:49 -0500
Message-ID: <147222994931.31214.11947039267239534307.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0076.outbound.protection.outlook.com ([104.47.32.76]:9824
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752794AbcHZRB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:56 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e7d7e99..3b3c7eb 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -38,11 +38,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"0.9.9-100"
+#define DRIVER_VERSION		"0.9.13-370"
 #define DRIVER_MAJOR		0
 #define DRIVER_MINOR		9
-#define DRIVER_RELEASE		9
-#define DRIVER_REVISION		100
+#define DRIVER_RELEASE		13
+#define DRIVER_REVISION		370
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" DRIVER_VERSION ")"
 #define DRIVER_NAME_SHORT	"smartpqi"

