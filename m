From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/3] IB/srp: Bump driver version and release date
Date: Fri, 31 Jul 2015 14:13:52 -0700
Message-ID: <55BBE510.4010003@sandisk.com>
References: <55BBE4A2.5090505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:29014
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508AbbGaVN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 17:13:58 -0400
In-Reply-To: <55BBE4A2.5090505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Since version 1.0 e.g. scsi-mq has been added. Since this is
a significant change, bump the driver version and release date.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ab18665..e67e6039 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -55,8 +55,8 @@
 
 #define DRV_NAME	"ib_srp"
 #define PFX		DRV_NAME ": "
-#define DRV_VERSION	"1.0"
-#define DRV_RELDATE	"July 1, 2013"
+#define DRV_VERSION	"2.0"
+#define DRV_RELDATE	"July 26, 2015"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator");
-- 
2.1.4

