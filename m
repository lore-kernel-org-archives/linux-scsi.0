From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] target: remove some iscsi leftovers in core code
Date: Thu, 25 Nov 2010 03:00:09 -0500
Message-ID: <20101125080009.GA6469@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KYIAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2010 03:00:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-25 08:52:56.000000000 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-25 08:53:17.774272876 +0100
@@ -38,7 +38,6 @@
 #define SPC_SENSE_KEY_OFFSET			2
 #define SPC_ASC_KEY_OFFSET			12
 #define SPC_ASCQ_KEY_OFFSET			13
-/* Currently same as ISCSI_IQN_LEN */
 #define TRANSPORT_IQN_LEN			224
 /* Used by target_core_store_alua_lu_gp() and target_core_alua_lu_gp_show_attr_members() */
 #define LU_GROUP_NAME_BUF			256
@@ -825,7 +824,6 @@ struct se_device {
 
 #define SE_DEV(cmd)		((struct se_device *)(cmd)->se_lun->lun_se_dev)
 #define SU_DEV(dev)		((struct se_subsystem_dev *)(dev)->se_sub_dev)
-#define ISCSI_DEV(cmd)		SE_DEV(cmd)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
 
@@ -854,8 +852,6 @@ struct se_hba {
 	struct se_subsystem_api *transport;
 }  ____cacheline_aligned;
 
-#define ISCSI_HBA(d)		((struct se_hba *)(d)->se_hba)
-/* Using SE_HBA() for new code */
 #define SE_HBA(d)		((struct se_hba *)(d)->se_hba)
 
 struct se_lun {
@@ -877,7 +873,6 @@ struct se_lun {
 } ____cacheline_aligned;
 
 #define SE_LUN(c)		((struct se_lun *)(c)->se_lun)
-#define ISCSI_LUN(c)		SE_LUN(c)
 
 struct se_port {
 	/* RELATIVE TARGET PORT IDENTIFER */
