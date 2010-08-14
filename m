From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] fusion: add function parameter names to kernel-doc
Date: Sat, 14 Aug 2010 13:05:57 -0700
Message-ID: <20100814130557.100acad5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29099 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab0HNUIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 16:08:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Eric Moore <Eric.Moore@lsi.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fusion missing kernel-doc:

Warning(drivers/message/fusion/mptbase.c:649): No description found for parameter 'func_name'
Warning(drivers/message/fusion/mptbase.c:8010): No description found for parameter 'cb_idx'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptbase.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.35-git8.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6.35-git8/drivers/message/fusion/mptbase.c
@@ -629,6 +629,7 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAM
  *	mpt_register - Register protocol-specific main callback handler.
  *	@cbfunc: callback function pointer
  *	@dclass: Protocol driver's class (%MPT_DRIVER_CLASS enum value)
+ *	@func_name: call function's name
  *
  *	This routine is called by a protocol-specific driver (SCSI host,
  *	LAN, SCSI target) to register its reply callback routine.  Each
@@ -8004,6 +8005,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
  *	mpt_sas_log_info - Log information returned from SAS IOC.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@log_info: U32 LogInfo reply word from the IOC
+ *	@cb_idx: callback function's handle
  *
  *	Refer to lsi/mpi_log_sas.h.
  **/
