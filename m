From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/20] libfc: removes unused disc_work and ex_list
Date: Wed, 21 Oct 2009 16:27:39 -0700
Message-ID: <20091021232739.12986.73986.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZJUX1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:27:34 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
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
index 8ce4182..170cdf4 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -75,7 +75,6 @@ struct fc_exch_mgr {
 	struct kref	kref;		/* exchange mgr reference count */
 	u16		min_xid;	/* min exchange ID */
 	u16		max_xid;	/* max exchange ID */
-	struct list_head	ex_list;	/* allocated exchanges list */
 	mempool_t	*ep_pool;	/* reserve ep's */
 	u16		pool_max_index;	/* max exch array index in exch pool */
 	struct fc_exch_pool *pool;	/* per cpu exch pool */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 65dc9aa..4ff1485 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -742,7 +742,6 @@ struct fc_lport {
 
 	/* Miscellaneous */
 	struct delayed_work	retry_work;
-	struct delayed_work	disc_work;
 };
 
 /*

