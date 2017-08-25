From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 01/26] scsi: fix comment in scsi_device_set_state()
Date: Fri, 25 Aug 2017 13:56:56 +0200
Message-ID: <1503662241-127788-2-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756496AbdHYL57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:57:59 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The function returns '0' if successful; with the original comment
the function doesn't have a way to indicate success ...

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart van Assche <bvanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2afca92..b9c084d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2547,7 +2547,7 @@ void scsi_exit_queue(void)
  *	@sdev:	scsi device to change the state of.
  *	@state:	state to change to.
  *
- *	Returns zero if unsuccessful or an error if the requested 
+ *	Returns zero if successful or an error if the requested
  *	transition is illegal.
  */
 int
-- 
1.8.5.6
