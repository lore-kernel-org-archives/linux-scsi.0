From: Spencer Baugh <spencer.baugh@purestorage.com>
Subject: [PATCH 1/2] target: remove unused lun_flags field from se_lun
Date: Mon, 20 Jul 2015 16:29:49 -0700
Message-ID: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34377 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbbGTXaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2015 19:30:01 -0400
Received: by pdbbh15 with SMTP id bh15so63180164pdb.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2015 16:30:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Spencer Baugh <sbaugh@catern.com>, Chris Zankel <czankel@purestorage.com>

From: Spencer Baugh <sbaugh@catern.com>

From: Chris Zankel <czankel@purestorage.com>

The lun_flags field is not used, so drop it.

Signed-off-by: Chris Zankel <czankel@purestorage.com>
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
2.4.3

