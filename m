Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9284C5ACAE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 20:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9506C20838
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfIKUiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 16:38:52 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60512 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbfIKUiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 16:38:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id AD7D728D854
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, kernel@collabora.com, krisman@collabora.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
Subject: [PATCH 2/3] scsi: core: remove trailing whitespaces
Date:   Wed, 11 Sep 2019 17:37:34 -0300
Message-Id: <20190911203735.1332398-2-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190911203735.1332398-1-andrealmeid@collabora.com>
References: <20190911203735.1332398-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove all trailing whitespaces from scsi_lib.c

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/scsi/scsi_lib.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 11e64b50497f..8565bee31922 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -401,7 +401,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
@@ -995,7 +995,7 @@ static blk_status_t scsi_init_sgtable(struct request *req,
 			SCSI_INLINE_SG_CNT)))
 		return BLK_STS_RESOURCE;
 
-	/* 
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
@@ -2019,7 +2019,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[1] = data->medium_type;
 		real_buffer[2] = data->device_specific;
 		real_buffer[3] = data->block_descriptor_length;
-		
+
 
 		cmd[0] = MODE_SELECT;
 		cmd[4] = len;
@@ -2103,7 +2103,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
-				/* 
+				/*
 				 * Invalid command operation code
 				 */
 				sdev->use_10_for_ms = 0;
@@ -2205,7 +2205,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			goto illegal;
 		}
 		break;
-			
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2488,7 +2488,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
  *	(which must be a legal transition).  When the device is in this
  *	state, only special requests will be accepted, all others will
  *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be 
+ *	a successful return doesn't guarantee the device will be
  *	totally quiescent.
  *
  *	Must be called with user context, may sleep.
@@ -2614,10 +2614,10 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 			return err;
 	}
 
-	/* 
+	/*
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
 	 * block layer from calling the midlayer with this device's
-	 * request queue. 
+	 * request queue.
 	 */
 	blk_mq_quiesce_queue_nowait(q);
 	return 0;
@@ -2652,7 +2652,7 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 
 	return err;
 }
- 
+
 void scsi_start_queue(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue;
-- 
2.23.0

