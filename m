From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/24] libfc: removes unused disc_work and ex_list
Date: Fri, 18 Sep 2009 15:49:55 -0700
Message-ID: <20090918224955.5928.61156.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12795 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbZIRWtw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:52 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Reported-by: Alex Lyakas <alexl@mellanox.co.il>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    1 -
 include/scsi/libfc.h         |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d157976..6e4adb8 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -90,7 +90,6 @@ struct fc_exch_mgr {
 	struct kref	kref;
 	u16		min_xid;
 	u16		max_xid;
-	struct list_head	ex_list;
 	mempool_t	*ep_pool;
 	u16		pool_max_index;
 	struct fc_exch_pool *pool;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b375dd5..0889c0e 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -821,7 +821,6 @@ struct fc_lport {
 	struct mutex                   lp_mutex;
 	struct list_head               list;
 	struct delayed_work	       retry_work;
-	struct delayed_work	       disc_work;
 };
 
 /*

