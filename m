From: michaelc@cs.wisc.edu
Subject: [PATCH 14/14] cxgb3i - fixed function descriptions
Date: Thu,  5 Mar 2009 14:46:08 -0600
Message-ID: <12362859792566-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
 <12362859763502-git-send-email-michaelc@cs.wisc.edu>
 <12362859771656-git-send-email-michaelc@cs.wisc.edu>
 <12362859771239-git-send-email-michaelc@cs.wisc.edu>
 <12362859782406-git-send-email-michaelc@cs.wisc.edu>
 <12362859782510-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbZCEUq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:28 -0500
In-Reply-To: <12362859782510-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Xie <kxie@chelsio.com>

[PATCH 1/5 2.6.30] cxgb3i - fixed function descriptions

From: Karen Xie <kxie@chelsio.com>

Limit function descriptions to be one line.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |    5 ++---
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    8 +++-----
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |   17 +++++++----------
 drivers/scsi/cxgb3i/cxgb3i_offload.c |    3 +--
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    1 +
 5 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index a83d36e..4eb6f55 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -196,7 +196,7 @@ static inline int ddp_alloc_gl_skb(struct cxgb3i_ddp_info *ddp, int idx,
 }
 
 /**
- * cxgb3i_ddp_find_page_index - return ddp page index for a given page size.
+ * cxgb3i_ddp_find_page_index - return ddp page index for a given page size
  * @pgsz: page size
  * return the ddp page index, if no match is found return DDP_PGIDX_MAX.
  */
@@ -355,8 +355,7 @@ EXPORT_SYMBOL_GPL(cxgb3i_ddp_release_gl);
  * @tdev: t3cdev adapter
  * @tid: connection id
  * @tformat: tag format
- * @tagp: the s/w tag, if ddp setup is successful, it will be updated with
- *	  ddp/hw tag
+ * @tagp: contains s/w tag initially, will be updated with ddp/hw tag
  * @gl: the page momory list
  * @gfp: allocation mode
  *
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 3faae78..75a63a8 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -185,12 +185,11 @@ static inline int cxgb3i_is_ddp_tag(struct cxgb3i_tag_format *tformat, u32 tag)
 }
 
 /**
- * cxgb3i_sw_tag_usable - check if a given s/w tag has enough bits left for
- *			  the reserved/hw bits
+ * cxgb3i_sw_tag_usable - check if s/w tag has enough bits left for hw bits
  * @tformat: tag format information
  * @sw_tag: s/w tag to be checked
  *
- * return true if the tag is a ddp tag, false otherwise.
+ * return true if the tag can be used for hw ddp tag, false otherwise.
  */
 static inline int cxgb3i_sw_tag_usable(struct cxgb3i_tag_format *tformat,
 					u32 sw_tag)
@@ -222,8 +221,7 @@ static inline u32 cxgb3i_set_non_ddp_tag(struct cxgb3i_tag_format *tformat,
 }
 
 /**
- * cxgb3i_ddp_tag_base - shift the s/w tag bits so that reserved bits are not
- *			 used.
+ * cxgb3i_ddp_tag_base - shift s/w tag bits so that reserved bits are not used
  * @tformat: tag format information
  * @sw_tag: s/w tag to be checked
  */
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index ae4a930..e185ded 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -101,8 +101,7 @@ free_snic:
 }
 
 /**
- * cxgb3i_adapter_remove - release all the resources held and cleanup any
- *	h/w settings
+ * cxgb3i_adapter_remove - release the resources held and cleanup h/w settings
  * @t3dev: t3cdev adapter
  */
 void cxgb3i_adapter_remove(struct t3cdev *t3dev)
@@ -135,8 +134,7 @@ void cxgb3i_adapter_remove(struct t3cdev *t3dev)
 }
 
 /**
- * cxgb3i_hba_find_by_netdev - find the cxgb3i_hba structure with a given
- *	net_device
+ * cxgb3i_hba_find_by_netdev - find the cxgb3i_hba structure via net_device
  * @t3dev: t3cdev adapter
  */
 struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
@@ -390,9 +388,9 @@ static void cxgb3i_session_destroy(struct iscsi_cls_session *cls_session)
 }
 
 /**
- * cxgb3i_conn_max_xmit_dlength -- check the max. xmit pdu segment size,
- * reduce it to be within the hardware limit if needed
+ * cxgb3i_conn_max_xmit_dlength -- calc the max. xmit pdu segment size
  * @conn: iscsi connection
+ * check the max. xmit pdu payload, reduce it if needed
  */
 static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
 
@@ -413,8 +411,7 @@ static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
 }
 
 /**
- * cxgb3i_conn_max_recv_dlength -- check the max. recv pdu segment size against
- * the hardware limit
+ * cxgb3i_conn_max_recv_dlength -- check the max. recv pdu segment size
  * @conn: iscsi connection
  * return 0 if the value is valid, < 0 otherwise.
  */
@@ -755,9 +752,9 @@ static void cxgb3i_parse_itt(struct iscsi_conn *conn, itt_t itt,
 
 /**
  * cxgb3i_reserve_itt - generate tag for a give task
- * Try to set up ddp for a scsi read task.
  * @task: iscsi task
  * @hdr_itt: tag, filled in by this function
+ * Set up ddp for scsi read tasks if possible.
  */
 int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 {
@@ -805,9 +802,9 @@ int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
 
 /**
  * cxgb3i_release_itt - release the tag for a given task
- * if the tag is a ddp tag, release the ddp setup
  * @task:	iscsi task
  * @hdr_itt:	tag
+ * If the tag is a ddp tag, release the ddp setup
  */
 void cxgb3i_release_itt(struct iscsi_task *task, itt_t hdr_itt)
 {
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index de3b3b6..c2e434e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1417,8 +1417,7 @@ static void c3cn_active_close(struct s3_conn *c3cn)
 }
 
 /**
- * cxgb3i_c3cn_release - close and release an iscsi tcp connection and any
- * 	resource held
+ * cxgb3i_c3cn_release - close and release an iscsi tcp connection
  * @c3cn: the iscsi tcp connection
  */
 void cxgb3i_c3cn_release(struct s3_conn *c3cn)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 6344b9e..275f23f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -139,6 +139,7 @@ enum c3cn_flags {
 
 /**
  * cxgb3i_sdev_data - Per adapter data.
+ *
  * Linked off of each Ethernet device port on the adapter.
  * Also available via the t3cdev structure since we have pointers to our port
  * net_device's there ...
-- 
1.6.0.6

