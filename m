From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 04/15] qla4xxx: correct data type of sense_len in
 qla4xxx_status_cont_entry
Date: Wed, 6 Oct 2010 22:48:53 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406787@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37507 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0JGFsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:48:55 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

change data type of sense_len from uint8_t to uint16_t

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 2a1ab63..1076fbf 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -72,7 +72,7 @@ qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
 {
 	struct srb *srb = ha->status_srb;
 	struct scsi_cmnd *cmd;
-	uint8_t sense_len;
+	uint16_t sense_len;
 
 	if (srb == NULL)
 		return;
-- 
1.6.6

