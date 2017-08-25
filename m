From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 11/17] libiscsi: Fix indentation
Date: Fri, 25 Aug 2017 13:46:37 -0700
Message-ID: <20170825204643.25043-12-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24575 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932929AbdHYUsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:48:10 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that smatch reports the following:

drivers/scsi/libiscsi.c:1081: iscsi_handle_reject() warn: inconsistent indenting

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 42381adf0769..bd4605a34f54 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1078,7 +1078,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (opcode != ISCSI_OP_NOOP_OUT)
 			return 0;
 
-		 if (rejected_pdu.itt == cpu_to_be32(ISCSI_RESERVED_TAG)) {
+		if (rejected_pdu.itt == cpu_to_be32(ISCSI_RESERVED_TAG)) {
 			/*
 			 * nop-out in response to target's nop-out rejected.
 			 * Just resend.
-- 
2.14.1
