From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 12/12] hpsa: bump driver version
Date: Fri, 20 Oct 2017 16:52:17 -0500
Message-ID: <150853633694.28275.17606661330395178246.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:37376
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753561AbdJTVwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:52:53 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5428a4c..e514489 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -60,7 +60,7 @@
  * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
  * with an optional trailing '-' followed by a byte value (0-255).
  */
-#define HPSA_DRIVER_VERSION "3.4.20-0"
+#define HPSA_DRIVER_VERSION "3.4.20-125"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
