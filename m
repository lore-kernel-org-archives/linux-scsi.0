From: akpm@osdl.org
Subject: [patch 12/24] dc395x: fix printk format warning
Date: Mon, 14 Aug 2006 23:09:26 -0700
Message-ID: <200608150609.k7F69QSY013235@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53141 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965180AbWHOGJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:09:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net

From: Randy Dunlap <rdunlap@xenotime.net>

drivers/scsi/dc395x.c:1224: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dc395x.c~dc395x-fix-printk-format-warning drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~dc395x-fix-printk-format-warning
+++ a/drivers/scsi/dc395x.c
@@ -1219,7 +1219,7 @@ static void dump_register_info(struct Ad
 			    	srb, srb->cmd, srb->cmd->pid,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
 			       	srb->cmd->device->lun);
-		printk("  sglist=%p cnt=%i idx=%i len=%i\n",
+		printk("  sglist=%p cnt=%i idx=%i len=%Zd\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
 		printk("  state=0x%04x status=0x%02x phase=0x%02x (%sconn.)\n",
_
