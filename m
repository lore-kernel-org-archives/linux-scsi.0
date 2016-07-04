From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] fcoe: fcoe->realdev is always set
Date: Mon,  4 Jul 2016 10:29:20 +0200
Message-ID: <1467620963-67047-4-git-send-email-hare@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbcGDI3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:33 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

'->realdev' is always set, so this check is pointless.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9c3742d..41c67e5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -770,9 +770,6 @@ static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
 	fcoe = port->priv;
 	realdev = fcoe->realdev;
 
-	if (!realdev)
-		return;
-
 	/* No FDMI state m/c for NPIV ports */
 	if (lport->vport)
 		return;
-- 
1.8.5.6

