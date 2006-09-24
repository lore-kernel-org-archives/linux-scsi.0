From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] missing include (free_irq() use)
Date: Sun, 24 Sep 2006 23:45:29 +0100
Message-ID: <20060924224529.GA29920@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:46536 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751669AbWIXWp3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 18:45:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/aacraid/commsup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

[... and that finishes with build/sparse regressions from up to yesterday
scsi merge]

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 8734a04..19e42ac 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -40,6 +40,7 @@ #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/interrupt.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
-- 
1.4.2.GIT
