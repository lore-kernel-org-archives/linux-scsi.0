From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 12/12] hpsa: bump driver version
Date: Fri, 28 Apr 2017 13:20:58 -0500
Message-ID: <149340365887.4102.17290431616340844342.stgit@brunhilda>
References: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0072.outbound.protection.outlook.com ([104.47.41.72]:21974
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968473AbdD1SV0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:21:26 -0400
In-Reply-To: <149340349509.4102.15752249884898695693.stgit@brunhilda>
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
index f1d7d1e..3d337bf 100644
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
 
