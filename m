From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/message/fusion/mptctl.c: make struct async_queue static
Date: Fri, 10 Feb 2006 01:41:01 +0100
Message-ID: <20060210004101.GI3524@stusta.de>
References: <20060207220627.345107c3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53509 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1750886AbWBJAlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 19:41:02 -0500
Content-Disposition: inline
In-Reply-To: <20060207220627.345107c3.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Eric Moore <Eric.Moore@lsil.com>
Cc: linux-kernel@vger.kernel.org, mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Tue, Feb 07, 2006 at 10:06:27PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.16-rc1-mm5:
>...
>  git-scsi-rc-fixes.patch
>...
>  Git trees
>...


There is no good reason for struct async_queue being global.

Additional, this patch adds some missing whitespace.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc2-mm1-full/drivers/message/fusion/mptctl.c.old	2006-02-10 00:43:43.000000000 +0100
+++ linux-2.6.16-rc2-mm1-full/drivers/message/fusion/mptctl.c	2006-02-10 00:43:59.000000000 +0100
@@ -140,7 +140,7 @@
  * Event Handler function
  */
 static int mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
-struct fasync_struct *async_queue=NULL;
+static struct fasync_struct *async_queue = NULL;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
