From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/message/fusion/mptctl.c: make struct async_queue static
Date: Tue, 14 Feb 2006 16:22:28 +0100
Message-ID: <20060214152228.GL10701@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161084AbWBNPXR@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Moore <Eric.Moore@lsil.com>, linux-kernel@vger.kernel.org, mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org

There is no good reason for struct async_queue being global.

Additional, this patch adds some missing whitespace.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 10 Feb 2006

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
