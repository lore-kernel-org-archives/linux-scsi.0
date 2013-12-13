From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 01/32] target: Remove unused ua_dev_list member in struct se_ua
Date: Fri, 13 Dec 2013 15:58:49 -0800
Message-ID: <1386979160-6928-2-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3LMX71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:27 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Initialized but not used.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_ua.c   |    1 -
 include/target/target_core_base.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index b04467e..505519b 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -98,7 +98,6 @@ int core_scsi3_ua_allocate(
 		pr_err("Unable to allocate struct se_ua\n");
 		return -ENOMEM;
 	}
-	INIT_LIST_HEAD(&ua->ua_dev_list);
 	INIT_LIST_HEAD(&ua->ua_nacl_list);
 
 	ua->ua_nacl = nacl;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 45412a6..d6f96c7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -504,7 +504,6 @@ struct se_ua {
 	u8			ua_asc;
 	u8			ua_ascq;
 	struct se_node_acl	*ua_nacl;
-	struct list_head	ua_dev_list;
 	struct list_head	ua_nacl_list;
 };
 
-- 
1.7.1

