From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/3] IB/srp: Constify a function argument
Date: Fri, 31 Jul 2015 14:12:48 -0700
Message-ID: <55BBE4D0.4040405@sandisk.com>
References: <55BBE4A2.5090505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0063.outbound.protection.outlook.com ([65.55.169.63]:3174
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752984AbbGaVMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 17:12:54 -0400
In-Reply-To: <55BBE4A2.5090505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31a20b4..61dadac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2171,7 +2171,7 @@ static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int attr_mask)
 }
 
 static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
-			       struct srp_login_rsp *lrsp,
+			       const struct srp_login_rsp *lrsp,
 			       struct srp_rdma_ch *ch)
 {
 	struct srp_target_port *target = ch->target;
-- 
2.1.4

