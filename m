From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fusion: fix non-kernel-doc comment block
Date: Sat, 14 Aug 2010 13:05:50 -0700
Message-ID: <20100814130550.bc3cc5e6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29065 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0HNUHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 16:07:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix comment begin notation not to look like kernel-doc
since it's not.  Removes kernel-doc warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git15.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.35-git15/drivers/message/fusion/mptbase.c
@@ -6560,7 +6560,7 @@ procmpt_destroy(void)
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
+/*
  *	Handles read request from /proc/mpt/summary or /proc/mpt/iocN/summary.
  */
 static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int showlan);
