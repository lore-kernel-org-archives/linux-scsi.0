From: mike.miller@hp.com
Subject: cciss typo fix fix 2.4.28-pre3
Date: Wed, 29 Sep 2004 11:06:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929160612.GA22308@beardog.cca.cpqcorp.net>
Reply-To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail04.zma.compaq.com ([161.114.64.104]:51725 "EHLO
	zmamail04.zma.compaq.com") by vger.kernel.org with ESMTP
	id S268682AbUI2QGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:06:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, marcelo.tosatti@cyclades.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch fixes a typo of a varaible name in the 32-bit to 64-bit
conversions. Please consider this for inclusion.

Thanks,
mikem
-------------------------------------------------------------------------------

diff -burNp lx2428-pre3/drivers/block/cciss.c lx2428-pre3-p001/drivers/block/cciss.c
--- lx2428-pre3/drivers/block/cciss.c	2004-09-21 14:29:46.000000000 -0500
+++ lx2428-pre3-p001/drivers/block/cciss.c	2004-09-29 10:56:40.234721928 -0500
@@ -535,7 +535,7 @@ static int cciss_ioctl32_passthru(unsign
 static int cciss_ioctl32_big_passthru(unsigned int fd, unsigned cmd, unsigned long arg, 
 	struct file *file);
 
-typedef long (*handler type) (unsigned int, unsigned int, unsigned long,
+typedef long (*handler_type) (unsigned int, unsigned int, unsigned long,
 				struct file *);
 
 static struct ioctl32_map {
