From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add comment for compat_ioctl to SR
Date: 18 Jan 2005 12:09:47 +0100
Message-ID: <20050118110947.GE43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:4614 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261261AbVARLJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:09:48 -0500
Date: Tue, 18 Jan 2005 12:09:47 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, axboe@suse.de

Add comment that SR doesn't support compat_ioctl (because it doesn't
pass down any driver ioctls right now)

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/sr.c-o linux-2.6.11-rc1-bk4/drivers/scsi/sr.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/sr.c-o	2005-01-14 10:12:20.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/sr.c	2005-01-18 04:54:59.000000000 +0100
@@ -516,6 +516,10 @@
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
 	.media_changed	= sr_block_media_changed,
+	/* 
+	 * No compat_ioctl for now because sr_block_ioctl never
+	 * seems to pass arbitary ioctls down to host drivers.
+	 */
 };
 
 static int sr_open(struct cdrom_device_info *cdi, int purpose)
