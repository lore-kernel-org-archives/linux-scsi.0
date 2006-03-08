From: akpm@osdl.org
Subject: [patch 28/28] drivers/message/fusion/mptctl.c: make struct async_queue static
Date: Wed, 08 Mar 2006 00:14:44 -0800
Message-ID: <200603080816.k288GXVG002272@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24749 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932507AbWCHITu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:19:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, Eric.Moore@lsil.com


From: Adrian Bunk <bunk@stusta.de>

There is no good reason for struct async_queue being global.

Additional, this patch adds some missing whitespace.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/mptctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-make-struct-async_queue-static drivers/message/fusion/mptctl.c
--- devel/drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-make-struct-async_queue-static	2006-03-08 00:13:08.000000000 -0800
+++ devel-akpm/drivers/message/fusion/mptctl.c	2006-03-08 00:13:08.000000000 -0800
@@ -140,7 +140,7 @@ static int  mptctl_ioc_reset(MPT_ADAPTER
  * Event Handler function
  */
 static int mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
-struct fasync_struct *async_queue=NULL;
+static struct fasync_struct *async_queue = NULL;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
_
