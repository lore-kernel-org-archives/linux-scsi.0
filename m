From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 2/4] cciss 2.4: adds BLKSSZGET ioctl for Oracle
Date: Mon, 15 Aug 2005 16:20:14 -0500
Message-ID: <20050815212014.GC12760@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:44772 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S964968AbVHOVUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:20:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 2/4
This patch adds the BLKSSZGET ioctl for Oracle. Please consider this for 
inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    1 +
 1 files changed, 1 insertion(+)
--------------------------------------------------------------------------------
diff -burNp lx2431-p001/drivers/block/cciss.c lx2431/drivers/block/cciss.c
--- lx2431-p001/drivers/block/cciss.c	2005-08-15 14:43:50.375342000 -0500
+++ lx2431/drivers/block/cciss.c	2005-08-15 15:13:15.484004696 -0500
@@ -747,6 +747,7 @@ static int cciss_ioctl(struct inode *ino
 	case BLKPG:
 	case BLKELVGET:
 	case BLKELVSET:
+	case BLKSSZGET:
 		return blk_ioctl(inode->i_rdev, cmd, arg);
 	case CCISS_GETPCIINFO:
 	{
