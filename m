From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 07/13] be2iscsi: Remove redundant receive buffers posting
Date: Tue, 13 Dec 2016 15:56:00 +0530
Message-ID: <1481624766-13846-8-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33707 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbcLMK1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:27:02 -0500
Received: by mail-qk0-f181.google.com with SMTP id x190so111548018qkb.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:27:02 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
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
index 1b5a07f..c6af6e5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3859,14 +3859,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
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
2.7.4

