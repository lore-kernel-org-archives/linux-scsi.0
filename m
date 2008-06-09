From: akpm@linux-foundation.org
Subject: [patch 6/9] MPT: remove unused struct -- mpt_proc_entry_t
Date: Mon, 09 Jun 2008 16:36:22 -0700
Message-ID: <200806092336.m59NaMMY014828@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575AbYFIXga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 19:36:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, Eric.Moore@lsi.com

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/message/fusion/mptbase.h~mpt-remove-unused-struct-mpt_proc_entry_t drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~mpt-remove-unused-struct-mpt_proc_entry_t
+++ a/drivers/message/fusion/mptbase.h
@@ -402,17 +402,6 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
 #define MPT_TARGET_FLAGS_LED_ON		0x80
 
-/*
- *	/proc/mpt interface
- */
-typedef struct {
-	const char	*name;
-	mode_t		 mode;
-	int		 pad;
-	read_proc_t	*read_proc;
-	write_proc_t	*write_proc;
-} mpt_proc_entry_t;
-
 #define MPT_PROC_READ_RETURN(buf,start,offset,request,eof,len) \
 do { \
 	len -= offset;			\
_
