From: Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 1/1] scsi: cxgbi: delete useless DIV_ROUND_UP definition
Date: Fri, 31 Jul 2015 10:16:07 +0800
Message-ID: <1438308967-17359-1-git-send-email-peter.chen@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kxie@chelsio.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>
List-Id: linux-scsi@vger.kernel.org

The common kernel.h has already supplied it.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index de6feb8..908399a 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -158,7 +158,6 @@ static struct scsi_transport_template *cxgb4i_stt;
  * open/close/abort and data send/receive.
  */
 
-#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
 #define RCV_BUFSIZ_MASK		0x3FFU
 #define MAX_IMM_TX_PKT_LEN	128
 
-- 
1.9.1
