From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 04/11] qla4xxx: Code Clean up - remove "marker_needed"
Date: Fri, 29 Jan 2010 22:28:41 -0800
Message-ID: <20100130062840.GE10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9003 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0A3G0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:26:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2923e8e..9ad0b43 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -341,8 +341,7 @@ struct scsi_qla_host {
 #define MIN_IOBASE_LEN		0x100
 
 	uint16_t req_q_count;
-	uint8_t marker_needed;
-	uint8_t rsvd1;
+	uint8_t rsvd1[2];
 
 	unsigned long host_no;
 
-- 
1.6.0.2

