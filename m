From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/12] IB/srp: Rearrange module description
Date: Thu, 30 Apr 2015 11:00:41 +0200
Message-ID: <5541EF39.6040301@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:8464
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbbD3JAu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 05:00:50 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Move the module version and release date into separate fields.
This makes the modinfo output easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8b6f166..3727b90 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -59,9 +59,10 @@
 #define DRV_RELDATE	"July 1, 2013"
 
 MODULE_AUTHOR("Roland Dreier");
-MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
-		   "v" DRV_VERSION " (" DRV_RELDATE ")");
+MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator");
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_INFO(release_date, DRV_RELDATE);
 
 static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
-- 
2.1.4

