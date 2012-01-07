From: Roland Dreier <roland@kernel.org>
Subject: [PATCH/TRIVIAL] [SCSI] Fix typo "neuxs" -> "nexus"
Date: Fri,  6 Jan 2012 16:08:43 -0800
Message-ID: <1325894923-26703-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:38912 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758725Ab2AGAIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 19:08:50 -0500
Received: by iapp10 with SMTP id p10so4459192iap.21
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 16:08:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/scsi_tgt_lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 84a1fdf..d7bec3e 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -575,7 +575,7 @@ int scsi_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
 	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no, itn_id, 0,
 						    initiator);
 	if (err < 0)
-		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+		eprintk("The i_t_nexus request lost, %d %llx!\n",
 			shost->host_no, (unsigned long long)itn_id);
 	return err;
 }
@@ -589,7 +589,7 @@ int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
 	err = scsi_tgt_uspace_send_it_nexus_request(shost->host_no,
 						    itn_id, 1, NULL);
 	if (err < 0)
-		eprintk("The i_t_neuxs request lost, %d %llx!\n",
+		eprintk("The i_t_nexus request lost, %d %llx!\n",
 			shost->host_no, (unsigned long long)itn_id);
 	return err;
 }
-- 
1.7.7.3

