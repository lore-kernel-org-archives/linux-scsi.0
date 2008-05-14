From: akpm@linux-foundation.org
Subject: [patch 5/9] MPT: remove unused struct -- mpt_proc_entry_t
Date: Wed, 14 May 2008 16:23:32 -0700
Message-ID: <200805142323.m4ENNW1X026859@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbYENXYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 19:24:09 -0400
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
@@ -400,17 +400,6 @@ typedef struct _VirtDevice {
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
