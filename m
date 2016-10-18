From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/20] scsi_transport_fc: rename 'fc_rport_create' to 'fc_remote_port_create'
Date: Tue, 18 Oct 2016 10:01:41 +0200
Message-ID: <1476777714-3543-8-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755736AbcJRIC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:27 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Required for the next patch.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0f3a386..4534085 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2592,7 +2592,7 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
 
 
 /**
- * fc_rport_create - allocates and creates a remote FC port.
+ * fc_remote_port_create - allocates and creates a remote FC port.
  * @shost:	scsi host the remote port is connected to.
  * @channel:	Channel on shost port connected to.
  * @ids:	The world wide names, fc address, and FC4 port
@@ -2605,8 +2605,8 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
  *	This routine assumes no locks are held on entry.
  */
 static struct fc_rport *
-fc_rport_create(struct Scsi_Host *shost, int channel,
-	struct fc_rport_identifiers  *ids)
+fc_remote_port_create(struct Scsi_Host *shost, int channel,
+		      struct fc_rport_identifiers  *ids)
 {
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	struct fc_internal *fci = to_fc_internal(shost->transportt);
@@ -2914,7 +2914,7 @@ struct fc_rport *
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/* No consistent binding found - create new remote port entry */
-	rport = fc_rport_create(shost, channel, ids);
+	rport = fc_remote_port_create(shost, channel, ids);
 
 	return rport;
 }
-- 
1.8.5.6

