From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 02/13] target: fix comment typos
Date: Thu, 19 Jan 2012 13:39:12 -0800
Message-ID: <1327009163-10177-3-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 include/target/target_core_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 120c414..6149b2a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -592,12 +592,12 @@ struct se_cmd {
 };
 
 struct se_tmr_req {
-	/* Task Management function to be preformed */
+	/* Task Management function to be performed */
 	u8			function;
 	/* Task Management response to send */
 	u8			response;
 	int			call_transport;
-	/* Reference to ITT that Task Mgmt should be preformed */
+	/* Reference to ITT that Task Mgmt should be performed */
 	u32			ref_task_tag;
 	/* 64-bit encoded SAM LUN from $FABRIC_MOD TMR header */
 	u64			ref_task_lun;
-- 
1.7.1
