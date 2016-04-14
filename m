From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_dh_alua: Declare local functions static
Date: Thu, 14 Apr 2016 10:27:14 -0700
Message-ID: <570FD2F2.90506@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:63840
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755670AbcDNR1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 13:27:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch avoids that building with W=1 causes gcc to report the
following type of warning:

    no previous prototype for ... [-Wmissing-prototypes]

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ewan Milne <emilne@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8eaed05..e034f12 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -190,8 +190,8 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
-struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
-					 int group_id)
+static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
+						int group_id)
 {
 	struct alua_port_group *pg;
 
@@ -219,8 +219,8 @@ struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
  * Allocate a new port_group structure for a given
  * device.
  */
-struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
-				      int group_id, int tpgs)
+static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
+					     int group_id, int tpgs)
 {
 	struct alua_port_group *pg, *tmp_pg;
 
-- 
2.8.1

