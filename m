From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 03/13] target: Remove unused struct se_queue_req
Date: Thu, 19 Jan 2012 13:39:13 -0800
Message-ID: <1327009163-10177-4-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 include/target/target_core_base.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6149b2a..bb739f9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -473,12 +473,6 @@ struct t10_reservation {
 	struct t10_reservation_ops pr_ops;
 };
 
-struct se_queue_req {
-	int			state;
-	struct se_cmd		*cmd;
-	struct list_head	qr_list;
-};
-
 struct se_queue_obj {
 	atomic_t		queue_cnt;
 	spinlock_t		cmd_queue_lock;
-- 
1.7.1
