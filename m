From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] bnx2fc: make bnx2fc_global_lock static
Date: Wed, 29 Apr 2015 20:21:15 +0200
Message-ID: <1430331675-26139-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

bnx2fc_global_lock is only used in bnx2fc_fcoe.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 98d06d1..66fb527 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -49,7 +49,7 @@ struct workqueue_struct *bnx2fc_wq;
  * Here the io threads are per cpu but the l2 thread is just one
  */
 struct fcoe_percpu_s bnx2fc_global;
-DEFINE_SPINLOCK(bnx2fc_global_lock);
+static DEFINE_SPINLOCK(bnx2fc_global_lock);
 
 static struct cnic_ulp_ops bnx2fc_cnic_cb;
 static struct libfc_function_template bnx2fc_libfc_fcn_templ;
-- 
1.9.1
