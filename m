From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] SCSI: remove old comment from block/unblock functions (v2)
Date: Fri,  4 May 2012 05:23:23 -0500
Message-ID: <1336127004-2358-4-git-send-email-michaelc@cs.wisc.edu>
References: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2EDKXh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:23:37 -0400
In-Reply-To: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not hold the host lock when calling these functions,
so remove comment.

v2:
- Forgot to remove "This".

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8e52cf7..c61ab0c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2404,7 +2404,6 @@ EXPORT_SYMBOL(scsi_target_resume);
  *	(which must be a legal transition).  When the device is in this
  *	state, all commands are deferred until the scsi lld reenables
  *	the device with scsi_device_unblock or device_block_tmo fires.
- *	This routine assumes the host_lock is held on entry.
  */
 int
 scsi_internal_device_block(struct scsi_device *sdev)
@@ -2448,8 +2447,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block);
  * Notes:       
  *	This routine transitions the device to the SDEV_RUNNING state
  *	or to one of the offline states (which must be a legal transition)
- *	allowing the midlayer to goose the queue for this device. This
- *	routine assumes the host_lock is held upon entry.
+ *	allowing the midlayer to goose the queue for this device.
  */
 int
 scsi_internal_device_unblock(struct scsi_device *sdev,
-- 
1.7.7.6

