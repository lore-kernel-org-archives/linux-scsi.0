From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 23/26] bnx2fc: remove obsolete bnx2fc_eh_host_reset() definition
Date: Fri, 25 Aug 2017 13:57:18 +0200
Message-ID: <1503662241-127788-24-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49613 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756522AbdHYL6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:05 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Never used anywhere.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 7e007e1..901a316 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -539,7 +539,6 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
-int bnx2fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
-- 
1.8.5.6
