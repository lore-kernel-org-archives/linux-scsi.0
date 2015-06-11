From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] target: Remove 'ua_nacl' pointer from se_ua structure
Date: Thu, 11 Jun 2015 10:01:25 +0200
Message-ID: <1434009689-112909-3-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_ua.c   | 1 -
 include/target/target_core_base.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index e53d4ee..e506224 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -107,7 +107,6 @@ int core_scsi3_ua_allocate(
 	}
 	INIT_LIST_HEAD(&ua->ua_nacl_list);
 
-	ua->ua_nacl = nacl;
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d30271e..4055cbd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -549,7 +549,6 @@ struct se_cmd {
 struct se_ua {
 	u8			ua_asc;
 	u8			ua_ascq;
-	struct se_node_acl	*ua_nacl;
 	struct list_head	ua_nacl_list;
 };
 
-- 
1.8.5.2
