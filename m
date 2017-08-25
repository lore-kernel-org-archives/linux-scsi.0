From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 01/17] Remove an obsolete function declaration
Date: Fri, 25 Aug 2017 13:46:27 -0700
Message-ID: <20170825204643.25043-2-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15512 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932912AbdHYUr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:47:28 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of
struct request") removed the scsi_get_command() function. Hence also
remove the declaration of that function.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_cmnd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a1266d318c85..f5afcff8d76f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -158,7 +158,6 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
-- 
2.14.1
