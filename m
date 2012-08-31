From: dongsu.park@profitbricks.com
Subject: [PATCH 2/5] ib_srp: removed superfluous warning in send timeout case
Date: Fri, 31 Aug 2012 22:00:38 +0200
Message-ID: <1346443241-24844-3-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, JBottomley@parallels.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-scsi@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Signed-off-By: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a0d0ca2..1b274484 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -534,7 +534,6 @@ static void srp_wait_last_send_wqe(struct srp_target_port *target)
 		msleep(20);
 	}
 
-	WARN_ON(!target->last_send_wqe);
 }
 
 static void srp_disconnect_target(struct srp_target_port *target)
-- 
1.7.11.1
