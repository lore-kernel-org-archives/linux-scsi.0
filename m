From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: assign correct address for iscsi_cls_host
Date: Fri, 2 Mar 2012 01:55:31 -0800
Message-ID: <1330682131-28116-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:20365
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab2CBKJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2012 05:09:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 281328d..d57f6eb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -834,7 +834,7 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 static void qla4xxx_set_port_speed(struct Scsi_Host *shost)
 {
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct iscsi_cls_host *ihost = shost_priv(shost);
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	uint32_t speed = ISCSI_PORT_SPEED_UNKNOWN;
 
 	qla4xxx_get_firmware_state(ha);
@@ -859,7 +859,7 @@ static void qla4xxx_set_port_speed(struct Scsi_Host *shost)
 static void qla4xxx_set_port_state(struct Scsi_Host *shost)
 {
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct iscsi_cls_host *ihost = shost_priv(shost);
+	struct iscsi_cls_host *ihost = shost->shost_data;
 	uint32_t state = ISCSI_PORT_STATE_DOWN;
 
 	if (test_bit(AF_LINK_UP, &ha->flags))
-- 
1.7.9.1.265.gb3a76


