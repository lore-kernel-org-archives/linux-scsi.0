From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/35] scsi: fix comment in scsi_device_set_state()
Date: Fri, 23 Jun 2017 15:02:21 +0200
Message-ID: <1498222975-71858-2-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751231AbdFWNDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:24 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The function returns '0' if successful; with the original comment
the function doesn't have a way to indicate success ...

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41c19c7..1ff7d72 100644
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
