From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 02/14] hpsa: change driver version
Date: Thu, 4 May 2017 14:08:13 -0500
Message-ID: <149392489320.10271.7764048803092176685.stgit@brunhilda>
References: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0089.outbound.protection.outlook.com ([104.47.41.89]:44736
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753018AbdEDTIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 15:08:19 -0400
In-Reply-To: <149392483740.10271.14468343789177475526.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eabb826..73daace 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -60,7 +60,7 @@
  * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
  * with an optional trailing '-' followed by a byte value (0-255).
  */
-#define HPSA_DRIVER_VERSION "3.4.16-0"
+#define HPSA_DRIVER_VERSION "3.4.18-0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
