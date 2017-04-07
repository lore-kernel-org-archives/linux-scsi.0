From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 12/12] hpsa: bump driver version
Date: Fri, 7 Apr 2017 15:06:58 -0500
Message-ID: <149159561851.15658.12213464065502623821.stgit@brunhilda>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0062.outbound.protection.outlook.com ([104.47.42.62]:20016
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932199AbdDGUHS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:07:18 -0400
In-Reply-To: <149159483812.15658.615814291766210537.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 33db581..42047f0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -60,7 +60,7 @@
  * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
  * with an optional trailing '-' followed by a byte value (0-255).
  */
-#define HPSA_DRIVER_VERSION "3.4.18-0"
+#define HPSA_DRIVER_VERSION "3.4.20-0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
