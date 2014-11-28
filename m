From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 08/16] target: Add EXPORT_SYMBOL for existing se_dev_set_*
Date: Fri, 28 Nov 2014 09:06:34 +0000
Message-ID: <1417165602-32359-9-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63088 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaK1Jhn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:43 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so4816755obc.18
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:42 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that target_core_backend_configfs.h macros will be using these
se_dev_set attribute functions externally to allow backend drivers
to populate different attributes, go ahead and add EXPORT_SYMBOL()
for the existing default set of 30 device attributes.

Also update target_core_backend.h with proper function prototypes.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c   | 26 ++++++++++++++++++++++++++
 drivers/target/target_core_iblock.c   |  1 +
 drivers/target/target_core_internal.h | 28 ----------------------------
 include/target/target_core_backend.h  | 29 +++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c45f9e9..953fff7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -659,6 +659,7 @@ int se_dev_set_max_unmap_lba_count(
 			dev, dev->dev_attrib.max_unmap_lba_count);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_max_unmap_lba_count);
 
 int se_dev_set_max_unmap_block_desc_count(
 	struct se_device *dev,
@@ -670,6 +671,7 @@ int se_dev_set_max_unmap_block_desc_count(
 			dev, dev->dev_attrib.max_unmap_block_desc_count);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_max_unmap_block_desc_count);
 
 int se_dev_set_unmap_granularity(
 	struct se_device *dev,
@@ -680,6 +682,7 @@ int se_dev_set_unmap_granularity(
 			dev, dev->dev_attrib.unmap_granularity);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_unmap_granularity);
 
 int se_dev_set_unmap_granularity_alignment(
 	struct se_device *dev,
@@ -690,6 +693,7 @@ int se_dev_set_unmap_granularity_alignment(
 			dev, dev->dev_attrib.unmap_granularity_alignment);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_unmap_granularity_alignment);
 
 int se_dev_set_max_write_same_len(
 	struct se_device *dev,
@@ -700,6 +704,7 @@ int se_dev_set_max_write_same_len(
 			dev, dev->dev_attrib.max_write_same_len);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_max_write_same_len);
 
 static void dev_set_t10_wwn_model_alias(struct se_device *dev)
 {
@@ -738,6 +743,7 @@ int se_dev_set_emulate_model_alias(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_model_alias);
 
 int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 {
@@ -753,6 +759,7 @@ int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_dpo);
 
 int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 {
@@ -771,6 +778,7 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 			dev, dev->dev_attrib.emulate_fua_write);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_fua_write);
 
 int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 {
@@ -786,6 +794,7 @@ int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_fua_read);
 
 int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 {
@@ -809,6 +818,7 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 			dev, dev->dev_attrib.emulate_write_cache);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_write_cache);
 
 int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 {
@@ -829,6 +839,7 @@ int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_ua_intlck_ctrl);
 
 int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 {
@@ -849,6 +860,7 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_tas);
 
 int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 {
@@ -870,6 +882,7 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 				dev, flag);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_tpu);
 
 int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 {
@@ -891,6 +904,7 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 				dev, flag);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_tpws);
 
 int se_dev_set_emulate_caw(struct se_device *dev, int flag)
 {
@@ -904,6 +918,7 @@ int se_dev_set_emulate_caw(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_caw);
 
 int se_dev_set_emulate_3pc(struct se_device *dev, int flag)
 {
@@ -917,6 +932,7 @@ int se_dev_set_emulate_3pc(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_3pc);
 
 int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
 {
@@ -970,6 +986,7 @@ int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_pi_prot_type);
 
 int se_dev_set_pi_prot_format(struct se_device *dev, int flag)
 {
@@ -1005,6 +1022,7 @@ int se_dev_set_pi_prot_format(struct se_device *dev, int flag)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_pi_prot_format);
 
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
@@ -1017,6 +1035,7 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 		(dev->dev_attrib.enforce_pr_isids) ? "Enabled" : "Disabled");
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_enforce_pr_isids);
 
 int se_dev_set_force_pr_aptpl(struct se_device *dev, int flag)
 {
@@ -1034,6 +1053,7 @@ int se_dev_set_force_pr_aptpl(struct se_device *dev, int flag)
 	pr_debug("dev[%p]: SE Device force_pr_aptpl: %d\n", dev, flag);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_force_pr_aptpl);
 
 int se_dev_set_is_nonrot(struct se_device *dev, int flag)
 {
@@ -1046,6 +1066,7 @@ int se_dev_set_is_nonrot(struct se_device *dev, int flag)
 	       dev, flag);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_is_nonrot);
 
 int se_dev_set_emulate_rest_reord(struct se_device *dev, int flag)
 {
@@ -1058,6 +1079,7 @@ int se_dev_set_emulate_rest_reord(struct se_device *dev, int flag)
 	pr_debug("dev[%p]: SE Device emulate_rest_reord: %d\n", dev, flag);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_emulate_rest_reord);
 
 /*
  * Note, this can only be called on unexported SE Device Object.
@@ -1101,6 +1123,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 			dev, queue_depth);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_queue_depth);
 
 int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 {
@@ -1155,6 +1178,7 @@ int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
 			dev, fabric_max_sectors);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_fabric_max_sectors);
 
 int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 {
@@ -1181,6 +1205,7 @@ int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 			dev, optimal_sectors);
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_optimal_sectors);
 
 int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 {
@@ -1218,6 +1243,7 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 
 	return 0;
 }
+EXPORT_SYMBOL(se_dev_set_block_size);
 
 struct se_lun *core_dev_add_lun(
 	struct se_portal_group *tpg,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7e6b857..5e69d36 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -858,6 +858,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 	return q->flush_flags & REQ_FLUSH;
 }
 
+
 static struct se_subsystem_api iblock_template = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e31f42f..60381db 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -18,34 +18,6 @@ int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
 void	core_dev_unexport(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
-int	se_dev_set_task_timeout(struct se_device *, u32);
-int	se_dev_set_max_unmap_lba_count(struct se_device *, u32);
-int	se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
-int	se_dev_set_unmap_granularity(struct se_device *, u32);
-int	se_dev_set_unmap_granularity_alignment(struct se_device *, u32);
-int	se_dev_set_max_write_same_len(struct se_device *, u32);
-int	se_dev_set_emulate_model_alias(struct se_device *, int);
-int	se_dev_set_emulate_dpo(struct se_device *, int);
-int	se_dev_set_emulate_fua_write(struct se_device *, int);
-int	se_dev_set_emulate_fua_read(struct se_device *, int);
-int	se_dev_set_emulate_write_cache(struct se_device *, int);
-int	se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
-int	se_dev_set_emulate_tas(struct se_device *, int);
-int	se_dev_set_emulate_tpu(struct se_device *, int);
-int	se_dev_set_emulate_tpws(struct se_device *, int);
-int	se_dev_set_emulate_caw(struct se_device *, int);
-int	se_dev_set_emulate_3pc(struct se_device *, int);
-int	se_dev_set_pi_prot_type(struct se_device *, int);
-int	se_dev_set_pi_prot_format(struct se_device *, int);
-int	se_dev_set_enforce_pr_isids(struct se_device *, int);
-int	se_dev_set_force_pr_aptpl(struct se_device *, int);
-int	se_dev_set_is_nonrot(struct se_device *, int);
-int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
-int	se_dev_set_queue_depth(struct se_device *, u32);
-int	se_dev_set_max_sectors(struct se_device *, u32);
-int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
-int	se_dev_set_optimal_sectors(struct se_device *, u32);
-int	se_dev_set_block_size(struct se_device *, u32);
 struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 83a3726..430cfaf 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -110,4 +110,33 @@ void	array_free(void *array, int n);
 /* From target_core_configfs.c to setup default backend config_item_types */
 void	target_core_setup_sub_cits(struct se_subsystem_api *);
 
+/* attribute helpers from target_core_device.c for backend drivers */
+int	se_dev_set_max_unmap_lba_count(struct se_device *, u32);
+int	se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
+int	se_dev_set_unmap_granularity(struct se_device *, u32);
+int	se_dev_set_unmap_granularity_alignment(struct se_device *, u32);
+int	se_dev_set_max_write_same_len(struct se_device *, u32);
+int	se_dev_set_emulate_model_alias(struct se_device *, int);
+int	se_dev_set_emulate_dpo(struct se_device *, int);
+int	se_dev_set_emulate_fua_write(struct se_device *, int);
+int	se_dev_set_emulate_fua_read(struct se_device *, int);
+int	se_dev_set_emulate_write_cache(struct se_device *, int);
+int	se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
+int	se_dev_set_emulate_tas(struct se_device *, int);
+int	se_dev_set_emulate_tpu(struct se_device *, int);
+int	se_dev_set_emulate_tpws(struct se_device *, int);
+int	se_dev_set_emulate_caw(struct se_device *, int);
+int	se_dev_set_emulate_3pc(struct se_device *, int);
+int	se_dev_set_pi_prot_type(struct se_device *, int);
+int	se_dev_set_pi_prot_format(struct se_device *, int);
+int	se_dev_set_enforce_pr_isids(struct se_device *, int);
+int	se_dev_set_force_pr_aptpl(struct se_device *, int);
+int	se_dev_set_is_nonrot(struct se_device *, int);
+int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
+int	se_dev_set_queue_depth(struct se_device *, u32);
+int	se_dev_set_max_sectors(struct se_device *, u32);
+int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
+int	se_dev_set_optimal_sectors(struct se_device *, u32);
+int	se_dev_set_block_size(struct se_device *, u32);
+
 #endif /* TARGET_CORE_BACKEND_H */
-- 
1.9.1

