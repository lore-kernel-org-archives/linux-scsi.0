From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] qla2xxx: Remove an unused structure member
Date: Mon, 22 May 2017 13:10:53 -0700
Message-ID: <20170522201053.7093-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25536 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753170AbdEVULI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 16:11:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, David Disseldorp <ddiss@suse.de>

qla_tgt_cmd.free_work is not used by the qla2xxx driver. Hence
remove that member of struct qla_tgt_cmd.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: David Disseldorp <ddiss@suse.de>
---
 drivers/scsi/qla2xxx/qla_target.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index d64420251194..dae278859554 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -862,7 +862,6 @@ struct qla_tgt_cmd {
 	struct se_cmd se_cmd;
 	struct fc_port *sess;
 	int state;
-	struct work_struct free_work;
 	struct work_struct work;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
-- 
2.12.2
