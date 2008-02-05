From: akpm@linux-foundation.org
Subject: [patch 04/13] kill warnings in mptbase.h on parisc64
Date: Mon, 04 Feb 2008 23:53:13 -0800
Message-ID: <200802050752.m157qs9o010697@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbYBEHxG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:53:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, kyle@mcmartin.ca, Eric.Moore@lsil.com, James.Bottomley@steeleye.com

From: Kyle McMartin <kyle@mcmartin.ca>

Verified all the arches necessary select the CONFIG_64BIT symbol.  This
also kills the warning (since it was using the 32-bit case) on parisc64 and
mips64.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptbase.h~kill-warnings-in-mptbaseh-on-parisc64 drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~kill-warnings-in-mptbaseh-on-parisc64
+++ a/drivers/message/fusion/mptbase.h
@@ -922,7 +922,7 @@ extern struct proc_dir_entry	*mpt_proc_r
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
-#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__) || defined(__powerpc__)
+#ifdef CONFIG_64BIT
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
 #else
_
