From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] Documentation: fix documentation of scsi_add_device()
Date: Wed,  7 Jul 2010 10:35:49 -0300
Message-ID: <1278509749-449-1-git-send-email-klebers@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:50454 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0GGNgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 09:36:43 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp04.br.ibm.com (8.14.4/8.13.1) with ESMTP id o67DYtIb007638
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jul 2010 10:34:55 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o67Dae9T2715752
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jul 2010 10:36:40 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o67DaRRw012576
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jul 2010 10:36:27 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

This patch fixes the documentation of the parameters and return value of
scsi_add_device().


Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 Documentation/scsi/scsi_mid_low_api.txt |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index de67229..e53fbf2 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -416,12 +416,10 @@ void scsi_activate_tcq(struct scsi_device *sdev, int depth)
  * scsi_add_device - creates new scsi device (lu) instance
  * @shost:   pointer to scsi host instance
  * @channel: channel number (rarely other than 0)
- * @id:      target id number
+ * @target:  target number
  * @lun:     logical unit number
  *
- *      Returns pointer to new struct scsi_device instance or 
- *      ERR_PTR(-ENODEV) (or some other bent pointer) if something is
- *      wrong (e.g. no lu responds at given address)
+ *      Returns 0 on success, negative errno on failure (e.g. -ENODEV)
  *
  *      Might block: yes
  *
@@ -434,9 +432,8 @@ void scsi_activate_tcq(struct scsi_device *sdev, int depth)
  *
  *      Defined in: drivers/scsi/scsi_scan.c
  **/
-struct scsi_device * scsi_add_device(struct Scsi_Host *shost, 
-                                     unsigned int channel,
-                                     unsigned int id, unsigned int lun)
+int scsi_add_device(struct Scsi_Host *host, uint channel,
+                    uint target, uint lun)
 
 
 /**
-- 
1.7.0.4

