From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 5/6] [FCoE] remove hash tables from fc_virt_fab
Date: Thu, 07 Feb 2008 00:21:32 -0800
Message-ID: <20080207082132.28965.20656.stgit@localhost.localdomain>
References: <20080207082111.28965.67934.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbYBGIdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 03:33:35 -0500
In-Reply-To: <20080207082111.28965.67934.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove vf_rport_by_fid, vf_rport_by_wwn, vf_lport_by_fid, vf_sess_by_fids
in struct fc_virt_fab of fc_virt_fab_impl.h

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
index e19714a..51d4543 100644
--- a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
+++ b/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
@@ -23,10 +23,6 @@
 struct fc_virt_fab {
 	uint		vf_tag;		/* virtual fabric tag (or zero) */
 	struct list_head vf_remote_ports;	/* remote ports */
-	struct sa_hash	*vf_rport_by_fid;	/* remote ports by FCID */
-	struct sa_hash	*vf_rport_by_wwpn;	/* remote ports by WWPN */
-	struct sa_hash	*vf_lport_by_fid;	/* local ports by FCID */
-	struct sa_hash	*vf_sess_by_fids;	/* sessions by FCID pairs */
 	struct list_head vf_local_ports;	/* list of local ports */
 	struct fc_exch_mgr *vf_exch_mgr;	/* exchange mgr for fabric */
 	spinlock_t	vf_lock;	/* lock for all tables and lists */

