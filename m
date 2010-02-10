From: michaelc@cs.wisc.edu
Subject: [PATCH 4/6] bnx2i: set change_queue_depth function
Date: Wed, 10 Feb 2010 16:51:46 -0600
Message-ID: <1265842308-2051-5-git-send-email-michaelc@cs.wisc.edu>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab0BJWuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:50:11 -0500
In-Reply-To: <1265842308-2051-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

No reason that we cannot set the change_queue_depth
function for bnx2i. We just forgot to when the
driver was created.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 51709cb..1c4d121 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1990,6 +1990,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= 1024,
 	.max_sectors		= 127,
 	.cmd_per_lun		= 32,
-- 
1.6.6

