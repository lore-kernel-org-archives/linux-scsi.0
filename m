From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 7/7] hpsa: update driver version
Date: Wed, 27 Apr 2016 17:14:26 -0500
Message-ID: <146179526602.31195.8809555251666495617.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:5728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752365AbcD0W3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:29:04 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0d286e4..011fb8e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -60,7 +60,7 @@
  * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
  * with an optional trailing '-' followed by a byte value (0-255).
  */
-#define HPSA_DRIVER_VERSION "3.4.14-0"
+#define HPSA_DRIVER_VERSION "3.4.16-0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 

