From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH] scsi_dh: remove unused declaration dm_pg_init_complete()
Date: Wed, 17 Apr 2013 12:29:09 +0800
Message-ID: <1366172949-14958-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, James Bottomley <jbottomley@parallels.com>, Chandra Seetharaman <sekharan@us.ibm.com>, DM-DEV <dm-devel@redhat.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch removes dm_pg_init_complete()'s declaration as it is
not needed anymore since 2651f5d7d3bc5120a439e498f131e4d731f99b3e.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/md/dm-mpath.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index e230f71..9c36d0f 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -16,7 +16,4 @@ struct dm_path {
 	void *pscontext;	/* For path-selector use */
 };
 
-/* Callback for hwh_pg_init_fn to use when complete */
-void dm_pg_init_complete(struct dm_path *path, unsigned err_flags);
-
 #endif
-- 
1.7.1
