From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh_alua: Remove stale variables
Date: Thu,  3 Dec 2015 07:57:35 +0100
Message-ID: <1449125855-66372-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbbLCG5h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 01:57:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@odin.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

With commit 83ea0e5e3501 these variables became obsolete,
but weren't removed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f100cbb..5a328bf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -320,8 +320,6 @@ static int alua_check_tpgs(struct scsi_device *sdev)
  */
 static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
 	int rel_port = -1, group_id;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
-- 
1.8.5.6

