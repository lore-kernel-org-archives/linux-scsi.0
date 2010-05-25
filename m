From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fusion: fix kernel-doc warnings
Date: Mon, 24 May 2010 22:22:14 -0700
Message-ID: <20100524222214.202b743a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:17447 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0EYFWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2010 01:22:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix (delete) empty kernel-doc lines/warnings:
Warning(drivers/message/fusion/mptbase.c:6916): bad line: 
Warning(drivers/message/fusion/mptbase.c:7060): bad line: 

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
---
 drivers/message/fusion/mptbase.c |    2 --
 1 file changed, 2 deletions(-)

--- lnx-2634-g8-kerndoc.orig/drivers/message/fusion/mptbase.c
+++ lnx-2634-g8-kerndoc/drivers/message/fusion/mptbase.c
@@ -6913,7 +6913,6 @@ EXPORT_SYMBOL(mpt_halt_firmware);
  *	mpt_SoftResetHandler - Issues a less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@sleepFlag: Indicates if sleep or schedule must be called.
-
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *
@@ -7057,7 +7056,6 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, i
  *	mpt_Soft_Hard_ResetHandler - Try less expensive reset
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@sleepFlag: Indicates if sleep or schedule must be called.
-
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  *	Try for softreset first, only if it fails go for expensive
