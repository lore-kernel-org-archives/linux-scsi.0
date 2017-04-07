From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 2/6] sg: remove 'save_scat_len'
Date: Fri,  7 Apr 2017 09:34:13 +0200
Message-ID: <1491550457-78302-3-git-send-email-hare@suse.de>
References: <1491550457-78302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54203 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbdDGHeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 03:34:23 -0400
In-Reply-To: <1491550457-78302-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <"james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, DougGilberdgilbert"@interlog.com>, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 11ca00d..92cc658 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -145,7 +145,6 @@
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	unsigned save_scat_len;	/* original length of trunc. scat. element */
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
@@ -2014,7 +2013,6 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	req_schp->pages = NULL;
 	req_schp->page_order = 0;
 	req_schp->sglist_len = 0;
-	sfp->save_scat_len = 0;
 	srp->res_used = 0;
 }
 
-- 
1.8.5.6
