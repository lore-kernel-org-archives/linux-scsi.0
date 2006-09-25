From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] aacraid: fix warning caused by missing include
Date: Mon, 25 Sep 2006 23:45:04 +0100
Message-ID: <1159224304.11049.166.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34793 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751531AbWIYWUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 18:20:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-mm1/drivers/scsi/aacraid/commsup.c linux-2.6.18-mm1/drivers/scsi/aacraid/commsup.c
--- linux.vanilla-2.6.18-mm1/drivers/scsi/aacraid/commsup.c	2006-09-25 12:10:16.000000000 +0100
+++ linux-2.6.18-mm1/drivers/scsi/aacraid/commsup.c	2006-09-25 12:24:03.000000000 +0100
@@ -40,6 +40,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/interrupt.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>

