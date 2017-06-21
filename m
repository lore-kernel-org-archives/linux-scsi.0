From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH] scsi: fix typos and grammar in comments of scsi_transport_fc.c
Date: Wed, 21 Jun 2017 16:24:39 -0400
Message-ID: <1498076679-8892-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751144AbdFUUYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 16:24:46 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5LKNh43121287
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 16:24:46 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b7p1kq547-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 16:24:45 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 14:24:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jsmart2021@gmail.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index d4cf32d..6dd0922 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1692,7 +1692,7 @@ static FC_DEVICE_ATTR(host, dev_loss_tmo, S_IRUGO | S_IWUSR,
  * Host Statistics Management
  */
 
-/* Show a given an attribute in the statistics group */
+/* Show a given attribute in the statistics group */
 static ssize_t
 fc_stat_show(const struct device *dev, char *buf, unsigned long offset)
 {
@@ -2923,7 +2923,7 @@ struct fc_rport *
  *   attached to it. However, we want to semi-persist the target id assigned
  *   to that port if it eventually does exist. The port structure will
  *   remain (although with minimal information) so that the target id
- *   bindings remails.
+ *   bindings also remain.
  *
  * If the remote port is not an FCP Target, it will be fully torn down
  * and deallocated, including the fc_remote_port class device.
@@ -2937,7 +2937,7 @@ struct fc_rport *
  *   If the remote port does not return (signaled by a LLDD call to
  *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
  *   scsi target is removed - killing all outstanding i/o and removing the
- *   scsi devices attached ot it. The port structure will be marked Not
+ *   scsi devices attached to it. The port structure will be marked Not
  *   Present and be partially cleared, leaving only enough information to
  *   recognize the remote port relative to the scsi target id binding if
  *   it later appears.  The port will remain as long as there is a valid
@@ -3056,7 +3056,7 @@ struct fc_rport *
 		 * There may have been a delete timer running on the
 		 * port. Ensure that it is cancelled as we now know
 		 * the port is an FCP Target.
-		 * Note: we know the rport is exists and in an online
+		 * Note: we know the rport exists and is in an online
 		 *  state as the LLDD would not have had an rport
 		 *  reference to pass us.
 		 *
@@ -3317,7 +3317,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
  * @ret_vport:	The pointer to the created vport.
  *
  * Allocates and creates the vport structure, calls the parent host
- * to instantiate the vport, the completes w/ class and sysfs creation.
+ * to instantiate the vport, this completes w/ class and sysfs creation.
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
@@ -3397,7 +3397,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 
 	/*
 	 * if the parent isn't the physical adapter's Scsi_Host, ensure
-	 * the Scsi_Host at least contains ia symlink to the vport.
+	 * the Scsi_Host at least contains a symlink to the vport.
 	 */
 	if (pdev != &shost->shost_gendev) {
 		error = sysfs_create_link(&shost->shost_gendev.kobj,
-- 
1.8.3.1
