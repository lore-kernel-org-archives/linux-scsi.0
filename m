From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch]  [SCSI] osst: indent for loop body
Date: Tue, 29 Apr 2014 15:39:53 +0300
Message-ID: <20140429123953.GA18437@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48786 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248AbaD2MkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2014 08:40:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The for body loop isn't indented at all so it's confusing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 21883a2..3074f6b 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5430,7 +5430,7 @@ static int append_to_buffer(const char __user *ubp, struct osst_buffer *st_bp, i
 
 	for (i=0, offset=st_bp->buffer_bytes;
 	     i < st_bp->sg_segs && offset >= st_bp->sg[i].length; i++)
-	offset -= st_bp->sg[i].length;
+		offset -= st_bp->sg[i].length;
 	if (i == st_bp->sg_segs) {  /* Should never happen */
 		printk(KERN_WARNING "osst :A: Append_to_buffer offset overflow.\n");
 		return (-EIO);
