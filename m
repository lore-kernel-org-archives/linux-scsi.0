From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Add TRY_VPD_PAGES to HITACHI OPEN-V blacklist entry
Date: Tue, 17 Oct 2017 09:10:33 +0200
Message-ID: <1508224233-129972-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60349 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933760AbdJQHKh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:10:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

HITACHI is always supporting VPD pages, even though it's claiming
to support SCSI Revision 3 only.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index ae2ad84..a998585 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -174,7 +174,7 @@ struct scsi_dev_info_list_table {
 	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "HUS1530", "*", BLIST_NO_DIF},
-	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
 	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-- 
1.8.5.6
