From: Jianjun Kong <jianjun@zeuux.org>
Subject: [PATCH] scsi: fix kernel-doc warning
Date: Thu, 1 Jan 2009 12:51:42 +0800
Message-ID: <20090101045142.GA14894@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.zeuux.org ([210.51.160.52]:53998 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZAAE5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2008 23:57:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org


scsi: fix kernel-doc warning

Fix kernel-doc parameter warning:
Warning(/media/sda1/Project/linux-2.6//drivers/scsi/scsi_sysfs.c:1049): Excess function parameter 'dev'
description in 'scsi_sysfs_add_host'

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 drivers/scsi/scsi_sysfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 93c28f3..eda8f1a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1043,7 +1043,6 @@ EXPORT_SYMBOL(scsi_register_interface);
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
- * @dev:       parent struct device pointer
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
-- 
1.5.6.3

