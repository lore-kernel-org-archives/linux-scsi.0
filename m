From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 5/5] target: Remove never-used TMR_FABRIC_TMR enum value
Date: Wed,  2 Jan 2013 12:48:01 -0800
Message-ID: <1357159681-24477-6-git-send-email-roland@kernel.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1357159681-24477-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 include/target/target_core_base.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7cae236..02ed017 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -210,7 +210,6 @@ enum tcm_tmreq_table {
 	TMR_LUN_RESET		= 5,
 	TMR_TARGET_WARM_RESET	= 6,
 	TMR_TARGET_COLD_RESET	= 7,
-	TMR_FABRIC_TMR		= 255,
 };
 
 /* fabric independent task management response values */
-- 
1.8.0
