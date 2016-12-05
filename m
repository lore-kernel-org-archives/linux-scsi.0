From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 07/12] be2iscsi: Remove redundant receive buffers posting
Date: Mon,  5 Dec 2016 13:36:46 +0530
Message-ID: <1480925211-13223-8-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34012 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:21 -0500
Received: by mail-qt0-f180.google.com with SMTP id n6so307003918qtd.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:21 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This duplicate code got added during manual merging.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0fa24a3..9b8b79f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3855,14 +3855,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 					phwi_ctrlr->wrb_context[cri].cid] =
 					async_arr_idx++;
 			}
-			/**
-			 * Now that the default PDU rings have been created,
-			 * let EP know about it.
-			 */
-			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_HDR,
-						 ulp_num);
-			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_DATA,
-						 ulp_num);
 		}
 	}
 
-- 
1.8.3.1

