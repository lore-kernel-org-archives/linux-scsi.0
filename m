From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH 20/29] scsi_transport_iscsi gfp_t annotations
Date: Wed, 08 Feb 2006 03:19:32 +0000
Message-ID: <E1F6frg-0006DY-4T@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:1153 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1030477AbWBHDTc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 22:19:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Date: 1138793445 -0500

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

---

 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

e5fb81bd895041230dfaeb8f8f498b85b4705988
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 59a1c9d..723f7ac 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -463,7 +463,7 @@ static inline struct list_head *skb_to_l
 }
 
 static void*
-mempool_zone_alloc_skb(unsigned int gfp_mask, void *pool_data)
+mempool_zone_alloc_skb(gfp_t gfp_mask, void *pool_data)
 {
 	struct mempool_zone *zone = pool_data;
 
-- 
0.99.9.GIT

