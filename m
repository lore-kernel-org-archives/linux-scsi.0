From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 9/10] fusion: fix kernel-doc notation
Date: Mon, 17 May 2010 16:21:11 -0700
Message-ID: <1274138471175@xenotime.net>
References: <12741384711166@xenotime.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:38459 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756273Ab0EQX3K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 May 2010 19:29:10 -0400
Received: from localhost ([71.245.98.113]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 17 May 2010 16:29:03 -0700
In-Reply-To: <12741384711166@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: Eric Moore <Eric.Moore@lsi.com>, Ben Hutchings <ben@decadent.org.uk>

From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
---
 drivers/message/fusion/mptscsih.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- lnx-2634-docs.orig/drivers/message/fusion/mptscsih.c
+++ lnx-2634-docs/drivers/message/fusion/mptscsih.c
@@ -2561,9 +2561,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTE
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2726,7 +2724,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 
 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)


-- 

