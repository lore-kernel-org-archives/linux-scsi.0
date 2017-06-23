From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/35] bnx2fc: remove obsolete bnx2fc_eh_host_reset() definition
Date: Fri, 23 Jun 2017 15:02:49 +0200
Message-ID: <1498222975-71858-30-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32839 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751620AbdFWND3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:29 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Never used anywhere.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 1f424e4..9c5adee 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -538,7 +538,6 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
-int bnx2fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
-- 
1.8.5.6
