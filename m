From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 10/18] megaraid_sas :
 megasas_complete_outstanding_ioctls() can be static
Date: Thu, 23 Apr 2015 16:33:23 +0530
Message-ID: <201504231105.t3NB5d0e030678@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:6800
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932361AbbDWLDc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:03:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index efb908c..aafbfb0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1689,7 +1689,7 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 * @instance:				Adapter soft state
 *
 */
-void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
+static void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
 {
 	int i;
 	struct megasas_cmd *cmd_mfi;
-- 
1.7.1

