From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/9] iscsi update: use gfp_t
Date: Wed, 01 Feb 2006 21:07:11 -0600
Message-ID: <1138849631.3456.41.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33716 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423076AbWBBDHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Use gfp_t. I accidentally removed this in our last update.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7fb6918..55860d2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -489,7 +489,7 @@ static inline struct list_head *skb_to_l
 }
 
 static void*
-mempool_zone_alloc_skb(unsigned int gfp_mask, void *pool_data)
+mempool_zone_alloc_skb(gfp_t gfp_mask, void *pool_data)
 {
 	struct mempool_zone *zone = pool_data;
 


