From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] megaraid_sas: megasas_complete_outstanding_ioctls() can be static
Date: Sat, 10 Jan 2015 18:11:14 +0100
Message-ID: <1420909883-19479-2-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbbAJRMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:21 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kbuild test robot <fengguang.wu@intel.com>

From: kbuild test robot <fengguang.wu@intel.com>

drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..2eb5233 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1698,7 +1698,7 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 * @instance:				Adapter soft state
 *
 */
-void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
+static void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
 {
 	int i;
 	struct megasas_cmd *cmd_mfi;
-- 
1.9.1

