From: Vipul Pandya <vipul@chelsio.com>
Subject: [PATCH v2 net-next 09/22] cxgb4: Update driver version and description
Date: Thu, 14 Mar 2013 20:38:55 +0530
Message-ID: <1363273748-25330-10-git-send-email-vipul@chelsio.com>
References: <1363273748-25330-1-git-send-email-vipul@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1363273748-25330-1-git-send-email-vipul@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, JBottomley@parallels.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, naresh@chelsio.com, divy@chelsio.com, santosh@chelsio.com, arvindb@chelsio.com, abhishek@chelsio.com, vipul@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Santosh Rastapur <santosh@chelsio.com>

Signed-off-by: Santosh Rastapur <santosh@chelsio.com>
Signed-off-by: Vipul Pandya <vipul@chelsio.com>
---
v2: Replaced #ifdef with portable interface wmb in ring_tx_db

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index eceee44..c502e36 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -68,8 +68,8 @@
 #include "t4fw_api.h"
 #include "l2t.h"
 
-#define DRV_VERSION "1.3.0-ko"
-#define DRV_DESC "Chelsio T4 Network Driver"
+#define DRV_VERSION "2.0.0-ko"
+#define DRV_DESC "Chelsio T4/T5 Network Driver"
 
 /*
  * Max interrupt hold-off timer value in us.  Queues fall back to this value
-- 
1.7.1
