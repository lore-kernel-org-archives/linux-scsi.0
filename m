From: akpm@linux-foundation.org
Subject: [patch 25/26] mptscsih: fix first line of kernel-doc for a few functions
Date: Thu, 11 Mar 2010 14:09:58 -0800
Message-ID: <201003112209.o2BM9wgJ013693@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758440Ab0CKWKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:10:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ben@decadent.org.uk

From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a short
description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/drivers/message/fusion/mptscsih.c
@@ -2560,9 +2560,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTE
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2725,7 +2723,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 
 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
_
