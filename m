From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] scsi: Remove unnecesary label
Date: Fri, 24 Oct 2014 11:23:28 +0900
Message-ID: <002a01cfef31$7f5b2770$7e117650$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:15383 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXCXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 22:23:17 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NDX005P4FYRUM00@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 24 Oct 2014 11:23:15 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jens Axboe' <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, 'Jan Kara' <jack@suse.cz>, 'Jingoo Han' <jg1.han@samsung.com>

Since commit "scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND",
the 'out' label is not used anymore. Thus, remove the unnecesary
label.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 block/scsi_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index cc7927a..1e053d9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -517,7 +517,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
1.7.9.5


