From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] scsi: cxgbi: use native DIV_ROUND_UP macro
Date: Fri, 15 Jul 2011 11:44:02 +0300
Message-ID: <0459b9438da78289a8143367f4778d5fc89af3e2.1310719270.git.andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f3a4cd7..5f41b9d 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -16,6 +16,7 @@
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/kernel.h>
 #include <scsi/scsi_host.h>
 #include <net/tcp.h>
 #include <net/dst.h>
@@ -169,7 +170,6 @@ static struct scsi_transport_template *cxgb4i_stt;
  * The section below implments CPLs that related to iscsi tcp connection
  * open/close/abort and data send/receive.
  */
-#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
 #define RCV_BUFSIZ_MASK		0x3FFU
 #define MAX_IMM_TX_PKT_LEN	128
 
-- 
1.7.5.4
