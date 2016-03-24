From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 1/3] scsi-trace: remove service action definitions
Date: Thu, 24 Mar 2016 15:21:18 +0100
Message-ID: <1458829280-12518-2-git-send-email-hare@suse.de>
References: <1458829280-12518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbcCXOVc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2016 10:21:32 -0400
In-Reply-To: <1458829280-12518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

scsi_opcode_name() is displaying the opcode, not the service
action.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/trace/events/scsi.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 079bd10..5c0d91f 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -95,10 +95,6 @@
 		scsi_opcode_name(VERIFY_16),			\
 		scsi_opcode_name(WRITE_SAME_16),		\
 		scsi_opcode_name(SERVICE_ACTION_IN_16),		\
-		scsi_opcode_name(SAI_READ_CAPACITY_16),		\
-		scsi_opcode_name(SAI_GET_LBA_STATUS),		\
-		scsi_opcode_name(MI_REPORT_TARGET_PGS),		\
-		scsi_opcode_name(MO_SET_TARGET_PGS),		\
 		scsi_opcode_name(READ_32),			\
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
-- 
1.8.5.6

