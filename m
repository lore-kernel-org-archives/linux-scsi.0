From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 4/4] cciss 2.4: fixes a warning from cciss_scsi.c during compile
Date: Mon, 15 Aug 2005 16:24:25 -0500
Message-ID: <20050815212425.GE12760@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:16016 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S964978AbVHOVYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:24:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 4/4
This patch fixes a warning during compile.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss_scsi.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)
--------------------------------------------------------------------------------
diff -burNp lx2431-p003/drivers/block/cciss_scsi.c lx2431/drivers/block/cciss_scsi.c
--- lx2431-p003/drivers/block/cciss_scsi.c	2004-08-07 18:26:04.000000000 -0500
+++ lx2431/drivers/block/cciss_scsi.c	2005-08-15 16:03:10.022765608 -0500
@@ -220,8 +220,7 @@ scsi_cmd_stack_free(int ctlr)
 		printk( "cciss: %d scsi commands are still outstanding.\n",
 			CMD_STACK_SIZE - stk->top);
 		// BUG();
-		printk("WE HAVE A BUG HERE!!! stk=0x%08x\n",
-			(unsigned int) stk);
+		printk("WE HAVE A BUG HERE!!! stk=0x%p\n", stk);
 	}
 	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
 
