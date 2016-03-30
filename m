From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/5] scsi_transport_iscsi: Declare local symbols static
Date: Wed, 30 Mar 2016 11:28:11 -0700
Message-ID: <56FC1ABB.8050501@sandisk.com>
References: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bbn0100.outbound.protection.outlook.com ([157.56.111.100]:18267
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbcC3S2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 14:28:16 -0400
In-Reply-To: <56FC1A3B.4040704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that building with W=1 causes gcc to report warnings about
symbols that have not been declared.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dff7413..c169fa1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1009,7 +1009,7 @@ static void iscsi_flashnode_sess_release(struct device *dev)
 	kfree(fnode_sess);
 }
 
-struct device_type iscsi_flashnode_sess_dev_type = {
+static struct device_type iscsi_flashnode_sess_dev_type = {
 	.name = "iscsi_flashnode_sess_dev_type",
 	.groups = iscsi_flashnode_sess_attr_groups,
 	.release = iscsi_flashnode_sess_release,
@@ -1195,13 +1195,13 @@ static void iscsi_flashnode_conn_release(struct device *dev)
 	kfree(fnode_conn);
 }
 
-struct device_type iscsi_flashnode_conn_dev_type = {
+static struct device_type iscsi_flashnode_conn_dev_type = {
 	.name = "iscsi_flashnode_conn_dev_type",
 	.groups = iscsi_flashnode_conn_attr_groups,
 	.release = iscsi_flashnode_conn_release,
 };
 
-struct bus_type iscsi_flashnode_bus;
+static struct bus_type iscsi_flashnode_bus;
 
 int iscsi_flashnode_bus_match(struct device *dev,
 				     struct device_driver *drv)
@@ -1212,7 +1212,7 @@ int iscsi_flashnode_bus_match(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(iscsi_flashnode_bus_match);
 
-struct bus_type iscsi_flashnode_bus = {
+static struct bus_type iscsi_flashnode_bus = {
 	.name = "iscsi_flashnode",
 	.match = &iscsi_flashnode_bus_match,
 };
-- 
2.7.3

