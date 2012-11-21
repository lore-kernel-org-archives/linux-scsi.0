From: Rob Evers <revers@redhat.com>
Subject: [PATCH 1/2] Change the cdb size limits in block and scsi to 32 bytes
Date: Wed, 21 Nov 2012 15:07:47 -0500
Message-ID: <1353528468-5664-2-git-send-email-revers@redhat.com>
References: <1353528468-5664-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2KUUIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 15:08:23 -0500
In-Reply-To: <1353528468-5664-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: chad.dupuis@qlogic.com, giridhar.malavali@qlogic.com, scameron@beardog.cce.hp.com, mike.miller@hp.com, dan.j.williams@intel.com, fushun@marvell.com


Signed-off-by: Rob Evers <revers@redhat.com>
---
 include/linux/blkdev.h   | 2 +-
 include/scsi/scsi_cmnd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..cafce6e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -85,7 +85,7 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
-#define BLK_MAX_CDB	16
+#define BLK_MAX_CDB	32
 
 /*
  * try to put the fields that are referenced together in the same cacheline.
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de5f5d8..9890d29 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -24,7 +24,7 @@ struct scsi_driver;
  * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
  * supports without specifying a cmd_len by ULD's
  */
-#define MAX_COMMAND_SIZE 16
+#define MAX_COMMAND_SIZE 32
 #if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
 # error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
 #endif
-- 
1.7.11.7

