From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH v2] target: remove unused lun_flags field from se_lun
Date: Thu, 13 Aug 2015 22:43:26 -0700
Message-ID: <1439531007-2250-1-git-send-email-sbaugh@catern.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Chris Zankel <czankel@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Chris Zankel <czankel@purestorage.com>

The lun_flags field is not used, so drop it.

Signed-off-by: Chris Zankel <czankel@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 include/target/target_core_base.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 17ae2d6..0a7c44e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -685,7 +685,6 @@ struct se_lun {
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
 	u32			lun_access;
-	u32			lun_flags;
 	u32			lun_index;
 
 	/* RELATIVE TARGET PORT IDENTIFER */
-- 
2.5.0.rc3
