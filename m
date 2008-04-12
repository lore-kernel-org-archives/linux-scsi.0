From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] MPT: remove unused struct -- mpt_proc_entry_t
Date: Sun, 13 Apr 2008 01:07:28 +0400
Message-ID: <20080412210728.GF9151@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:19112 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYDLVL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Apr 2008 17:11:58 -0400
Received: by fk-out-0910.google.com with SMTP id 19so1132122fkr.5
        for <linux-scsi@vger.kernel.org>; Sat, 12 Apr 2008 14:11:54 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsi.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/message/fusion/mptbase.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
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
-- 
1.5.3.7


