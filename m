From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] [SCSI] be2iscsi: Remove unused OFFSET_IN_PAGE() macro
Date: Wed, 29 Feb 2012 22:41:49 -0800
Message-ID: <1330584109-4001-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:41271 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755416Ab2CAGl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 01:41:59 -0500
Received: by mail-pz0-f47.google.com with SMTP id o14so153848dad.34
        for <linux-scsi@vger.kernel.org>; Wed, 29 Feb 2012 22:41:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/be2iscsi/be.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 1d7b976..a50b6a9 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -132,10 +132,6 @@ struct be_ctrl_info {
 		((u32)((((size_t)(_address) & (PAGE_SIZE_4K - 1)) +	\
 			(size) + (PAGE_SIZE_4K - 1)) >> PAGE_SHIFT_4K))
 
-/* Byte offset into the page corresponding to given address */
-#define OFFSET_IN_PAGE(addr)						\
-		((size_t)(addr) & (PAGE_SIZE_4K-1))
-
 /* Returns bit offset within a DWORD of a bitfield */
 #define AMAP_BIT_OFFSET(_struct, field)					\
 		(((size_t)&(((_struct *)0)->field))%32)
-- 
1.7.9

