From: michaelc@cs.wisc.edu
Subject: [RFC 3/4] SCSI: remove old comment from block/unblock functions
Date: Thu, 19 Apr 2012 20:08:55 -0500
Message-ID: <1334884136-3689-4-git-send-email-michaelc@cs.wisc.edu>
References: <1334884136-3689-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab2DTBJC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2012 21:09:02 -0400
In-Reply-To: <1334884136-3689-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not hold the host lock when calling these functions,
so remove comment.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6a6ac5b..1a67302 100644
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
@@ -2449,7 +2448,6 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block);
  *	This routine transitions the device to the SDEV_RUNNING state
  *	or to one of the offline states (which must be a legal transition)
  *	allowing the midlayer to goose the queue for this device. This
- *	routine assumes the host_lock is held upon entry.
  */
 int
 scsi_internal_device_unblock(struct scsi_device *sdev,
-- 
1.7.7.6

