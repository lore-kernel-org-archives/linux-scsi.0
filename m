From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] IB/mlx5: Fix signature rule constants according to FW specifications
Date: Sun, 19 Jan 2014 12:37:38 +0200
Message-ID: <1390127858-9806-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use DIF CRC INC with apptag escape (0x8) and update IP-CSUM entries.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7981620..58c4735 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1952,9 +1952,9 @@ static int format_selector(struct ib_sig_attrs *attr,
 {
 
 #define FORMAT_DIF_NONE		0
-#define FORMAT_DIF_CRC_INC	4
-#define FORMAT_DIF_CSUM_INC	12
-#define FORMAT_DIF_CRC_NO_INC	13
+#define FORMAT_DIF_CRC_INC	8
+#define FORMAT_DIF_CRC_NO_INC	12
+#define FORMAT_DIF_CSUM_INC	13
 #define FORMAT_DIF_CSUM_NO_INC	14
 
 	switch (domain->sig.dif.type) {
-- 
1.7.8.2
