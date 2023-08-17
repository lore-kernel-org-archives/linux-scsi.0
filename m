Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5C7C2FC24
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351237AbjHQNMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351403AbjHQNMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980C359B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277897; x=1723813897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tndc486r/yb0mEdyFztaFK0k7BrodNkx7Nm22hP37ik=;
  b=zc8OY9Pfd1b96eAHdDpg8nXDAhTYPgLzjuebWWcJ7HG2Nw4ZjcNFgMww
   pdvHUlxOAVudLS73Zkd4cZjc0+pAnlk6scygd9q/o5ht5EBOB/zIoErrx
   mhPibBt9mz/By+bjBydREKkNZ8AcHqEypL+5C7t1VYe5z6DSa4tnz6jOI
   warXDnAga9JrQPEhR6/195EEcjc1PRl+6ylVFRCFgcI9zJ8dueaeK8/i0
   obc+9D7h2ezsKwuGLBGPNcUA6uEm4NV2zQM8tQmRd4iIzmtuSLdTInGOd
   67TegJq2yJjpGhmuRThq0LIElYJIRIZg7P3aMQzwBKopOXdjcgQunWCQW
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="230328052"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:10:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:10:27 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:10:26 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/9] smartpqi: reformat to align with oob driver
Date:   Thu, 17 Aug 2023 08:12:24 -0500
Message-ID: <20230817131232.86754-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Align with our oob driver to simplify patch management.

No functional changes.

Reviewed-by: Justin Lindley <justin.lindley@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1598 +++++++++----------------
 1 file changed, 540 insertions(+), 1058 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6aaaa7ebca37..4486259f85ab 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -527,8 +527,7 @@ static inline bool pqi_is_io_high_priority(struct pqi_scsi_dev *device, struct s
 	io_high_prio = false;
 
 	if (device->ncq_prio_enable) {
-		priority_class =
-			IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
+		priority_class = IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd)));
 		if (priority_class == IOPRIO_CLASS_RT) {
 			/* Set NCQ priority for read/write commands. */
 			switch (scmd->cmnd[0]) {
@@ -558,8 +557,7 @@ static int pqi_map_single(struct pci_dev *pci_dev,
 	if (!buffer || buffer_length == 0 || data_direction == DMA_NONE)
 		return 0;
 
-	bus_address = dma_map_single(&pci_dev->dev, buffer, buffer_length,
-		data_direction);
+	bus_address = dma_map_single(&pci_dev->dev, buffer, buffer_length, data_direction);
 	if (dma_mapping_error(&pci_dev->dev, bus_address))
 		return -ENOMEM;
 
@@ -939,8 +937,7 @@ static int pqi_flush_cache(struct pqi_ctrl_info *ctrl_info,
 
 	flush_cache->shutdown_event = shutdown_event;
 
-	rc = pqi_send_ctrl_raid_request(ctrl_info, SA_FLUSH_CACHE, flush_cache,
-		sizeof(*flush_cache));
+	rc = pqi_send_ctrl_raid_request(ctrl_info, SA_FLUSH_CACHE, flush_cache, sizeof(*flush_cache));
 
 	kfree(flush_cache);
 
@@ -1197,7 +1194,7 @@ static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
 	return rc;
 }
 
-static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
+static int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
 {
 	int rc;
 	unsigned int i;
@@ -1292,20 +1289,16 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
 	logdev_data = *logdev_list;
 
 	if (logdev_data) {
-		logdev_list_length =
-			get_unaligned_be32(&logdev_data->header.list_length);
+		logdev_list_length = get_unaligned_be32(&logdev_data->header.list_length);
 	} else {
 		memset(&report_lun_header, 0, sizeof(report_lun_header));
-		logdev_data =
-			(struct report_log_lun_list *)&report_lun_header;
+		logdev_data = (struct report_log_lun_list *)&report_lun_header;
 		logdev_list_length = 0;
 	}
 
-	logdev_data_length = sizeof(struct report_lun_header) +
-		logdev_list_length;
+	logdev_data_length = sizeof(struct report_lun_header) + logdev_list_length;
 
-	internal_logdev_list = kmalloc(logdev_data_length +
-		sizeof(struct report_log_lun), GFP_KERNEL);
+	internal_logdev_list = kmalloc(logdev_data_length + sizeof(struct report_log_lun), GFP_KERNEL);
 	if (!internal_logdev_list) {
 		kfree(*logdev_list);
 		*logdev_list = NULL;
@@ -1313,10 +1306,8 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
 	}
 
 	memcpy(internal_logdev_list, logdev_data, logdev_data_length);
-	memset((u8 *)internal_logdev_list + logdev_data_length, 0,
-		sizeof(struct report_log_lun));
-	put_unaligned_be32(logdev_list_length +
-		sizeof(struct report_log_lun),
+	memset((u8 *)internal_logdev_list + logdev_data_length, 0, sizeof(struct report_log_lun));
+	put_unaligned_be32(logdev_list_length + sizeof(struct report_log_lun),
 		&internal_logdev_list->header.list_length);
 
 	kfree(*logdev_list);
@@ -1445,8 +1436,7 @@ static int pqi_validate_raid_map(struct pqi_ctrl_info *ctrl_info,
 	return -EINVAL;
 }
 
-static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
 	int rc;
 	u32 raid_map_size;
@@ -1624,8 +1614,7 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 
 	memset(id_phys, 0, sizeof(*id_phys));
 
-	rc = pqi_identify_physical_device(ctrl_info, device,
-		id_phys, sizeof(*id_phys));
+	rc = pqi_identify_physical_device(ctrl_info, device, id_phys, sizeof(*id_phys));
 	if (rc) {
 		device->queue_depth = PQI_PHYSICAL_DISK_DEFAULT_MAX_QUEUE_DEPTH;
 		return rc;
@@ -1640,8 +1629,7 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 	device->box_index = id_phys->box_index;
 	device->phys_box_on_bus = id_phys->phys_box_on_bus;
 	device->phy_connected_dev_type = id_phys->phy_connected_dev_type[0];
-	device->queue_depth =
-		get_unaligned_le16(&id_phys->current_queue_depth_limit);
+	device->queue_depth = get_unaligned_le16(&id_phys->current_queue_depth_limit);
 	device->active_path_index = id_phys->active_path_number;
 	device->path_map = id_phys->redundant_path_present_map;
 	memcpy(&device->box,
@@ -1652,10 +1640,8 @@ static int pqi_get_physical_device_info(struct pqi_ctrl_info *ctrl_info,
 		sizeof(device->phys_connector));
 	device->bay = id_phys->phys_bay_in_box;
 	device->lun_count = id_phys->multi_lun_device_lun_count;
-	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) &&
-		id_phys->phy_count)
-		device->phy_id =
-			id_phys->phy_to_phy_map[device->active_path_index];
+	if ((id_phys->even_more_flags & PQI_DEVICE_PHY_MAP_SUPPORTED) && id_phys->phy_count)
+		device->phy_id = id_phys->phy_to_phy_map[device->active_path_index];
 	else
 		device->phy_id = 0xFF;
 
@@ -1758,8 +1744,7 @@ static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
 	char *status;
-	static const char unknown_state_str[] =
-		"Volume is in an unknown state (%u)";
+	static const char unknown_state_str[] = "Volume is in an unknown state (%u)";
 	char unknown_state_buffer[sizeof(unknown_state_str) + 10];
 
 	switch (device->volume_status) {
@@ -2281,7 +2266,6 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	}
 
 	ctrl_info->logical_volume_rescan_needed = false;
-
 }
 
 static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
@@ -2394,15 +2378,12 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		}
 	}
 
-	if (num_logicals &&
-		(logdev_list->header.flags & CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX))
+	if (num_logicals && (logdev_list->header.flags & CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX))
 		ctrl_info->lv_drive_type_mix_valid = true;
 
 	num_new_devices = num_physicals + num_logicals;
 
-	new_device_list = kmalloc_array(num_new_devices,
-					sizeof(*new_device_list),
-					GFP_KERNEL);
+	new_device_list = kmalloc_array(num_new_devices, sizeof(*new_device_list), GFP_KERNEL);
 	if (!new_device_list) {
 		dev_warn(&ctrl_info->pci_dev->dev, "%s\n", out_of_memory_msg);
 		rc = -ENOMEM;
@@ -2412,13 +2393,11 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	for (i = 0; i < num_new_devices; i++) {
 		device = kzalloc(sizeof(*device), GFP_KERNEL);
 		if (!device) {
-			dev_warn(&ctrl_info->pci_dev->dev, "%s\n",
-				out_of_memory_msg);
+			dev_warn(&ctrl_info->pci_dev->dev, "%s\n", out_of_memory_msg);
 			rc = -ENOMEM;
 			goto out;
 		}
-		list_add_tail(&device->new_device_list_entry,
-			&new_device_list_head);
+		list_add_tail(&device->new_device_list_entry, &new_device_list_head);
 	}
 
 	device = NULL;
@@ -2457,8 +2436,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			if (device->device_type == SA_DEVICE_TYPE_EXPANDER_SMP)
 				device->is_expander_smp_device = true;
 		} else {
-			device->is_external_raid_device =
-				pqi_is_external_raid_addr(scsi3addr);
+			device->is_external_raid_device = pqi_is_external_raid_addr(scsi3addr);
 		}
 
 		if (!pqi_is_supported_device(device))
@@ -2467,8 +2445,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 		/* Gather information about the device. */
 		rc = pqi_get_device_info(ctrl_info, device, id_phys);
 		if (rc == -ENOMEM) {
-			dev_warn(&ctrl_info->pci_dev->dev, "%s\n",
-				out_of_memory_msg);
+			dev_warn(&ctrl_info->pci_dev->dev, "%s\n", out_of_memory_msg);
 			goto out;
 		}
 		if (rc) {
@@ -2494,16 +2471,12 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 		if (device->is_physical_device) {
 			memcpy(device->wwid, phys_lun->wwid, sizeof(device->wwid));
-			if ((phys_lun->device_flags &
-				CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) &&
-				phys_lun->aio_handle) {
-					device->aio_enabled = true;
-					device->aio_handle =
-						phys_lun->aio_handle;
+			if ((phys_lun->device_flags & CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) && phys_lun->aio_handle) {
+				device->aio_enabled = true;
+				device->aio_handle = phys_lun->aio_handle;
 			}
 		} else {
-			memcpy(device->volume_id, log_lun->volume_id,
-				sizeof(device->volume_id));
+			memcpy(device->volume_id, log_lun->volume_id, sizeof(device->volume_id));
 		}
 
 		device->sas_address = get_unaligned_be64(&device->wwid[0]);
@@ -2514,8 +2487,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	pqi_update_device_list(ctrl_info, new_device_list, num_valid_devices);
 
 out:
-	list_for_each_entry_safe(device, next, &new_device_list_head,
-		new_device_list_entry) {
+	list_for_each_entry_safe(device, next, &new_device_list_head, new_device_list_entry) {
 		if (device->keep_device)
 			continue;
 		list_del(&device->new_device_list_entry);
@@ -2591,8 +2563,7 @@ static inline void pqi_set_encryption_info(struct pqi_encryption_info *encryptio
 	if (volume_blk_size != 512)
 		first_block = (first_block * volume_blk_size) / 512;
 
-	encryption_info->data_encryption_key_index =
-		get_unaligned_le16(&raid_map->data_encryption_key_index);
+	encryption_info->data_encryption_key_index = get_unaligned_le16(&raid_map->data_encryption_key_index);
 	encryption_info->encrypt_tweak_lower = lower_32_bits(first_block);
 	encryption_info->encrypt_tweak_upper = upper_32_bits(first_block);
 }
@@ -2695,13 +2666,11 @@ static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
 	rmd->last_block = rmd->first_block + rmd->block_cnt - 1;
 
 	/* Check for invalid block or wraparound. */
-	if (rmd->last_block >=
-		get_unaligned_le64(&raid_map->volume_blk_cnt) ||
+	if (rmd->last_block >= get_unaligned_le64(&raid_map->volume_blk_cnt) ||
 		rmd->last_block < rmd->first_block)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
-	rmd->data_disks_per_row =
-		get_unaligned_le16(&raid_map->data_disks_per_row);
+	rmd->data_disks_per_row = get_unaligned_le16(&raid_map->data_disks_per_row);
 	rmd->strip_size = get_unaligned_le16(&raid_map->strip_size);
 	rmd->layout_map_count = get_unaligned_le16(&raid_map->layout_map_count);
 
@@ -2727,27 +2696,22 @@ static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info *ctrl_info,
 #else
 	rmd->first_row = rmd->first_block / rmd->blocks_per_row;
 	rmd->last_row = rmd->last_block / rmd->blocks_per_row;
-	rmd->first_row_offset = (u32)(rmd->first_block -
-		(rmd->first_row * rmd->blocks_per_row));
-	rmd->last_row_offset = (u32)(rmd->last_block - (rmd->last_row *
-		rmd->blocks_per_row));
+	rmd->first_row_offset = (u32)(rmd->first_block - (rmd->first_row * rmd->blocks_per_row));
+	rmd->last_row_offset = (u32)(rmd->last_block - (rmd->last_row * rmd->blocks_per_row));
 	rmd->first_column = rmd->first_row_offset / rmd->strip_size;
 	rmd->last_column = rmd->last_row_offset / rmd->strip_size;
 #endif
 
 	/* If this isn't a single row/column then give to the controller. */
-	if (rmd->first_row != rmd->last_row ||
-		rmd->first_column != rmd->last_column)
+	if (rmd->first_row != rmd->last_row || rmd->first_column != rmd->last_column)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	/* Proceeding with driver mapping. */
 	rmd->total_disks_per_row = rmd->data_disks_per_row +
 		get_unaligned_le16(&raid_map->metadata_disks_per_row);
-	rmd->map_row = ((u32)(rmd->first_row >>
-		raid_map->parity_rotation_shift)) %
+	rmd->map_row = ((u32)(rmd->first_row >> raid_map->parity_rotation_shift)) %
 		get_unaligned_le16(&raid_map->row_cnt);
-	rmd->map_index = (rmd->map_row * rmd->total_disks_per_row) +
-		rmd->first_column;
+	rmd->map_index = (rmd->map_row * rmd->total_disks_per_row) + rmd->first_column;
 
 	return 0;
 }
@@ -2819,15 +2783,12 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 	rmd->r5or6_last_column = tmpdiv;
 #else
 	rmd->first_row_offset = rmd->r5or6_first_row_offset =
-		(u32)((rmd->first_block % rmd->stripesize) %
-		rmd->blocks_per_row);
+		(u32)((rmd->first_block % rmd->stripesize) % rmd->blocks_per_row);
 
 	rmd->r5or6_last_row_offset =
-		(u32)((rmd->last_block % rmd->stripesize) %
-		rmd->blocks_per_row);
+		(u32)((rmd->last_block % rmd->stripesize) % rmd->blocks_per_row);
 
-	rmd->first_column =
-		rmd->r5or6_first_row_offset / rmd->strip_size;
+	rmd->first_column = rmd->r5or6_first_row_offset / rmd->strip_size;
 	rmd->r5or6_first_column = rmd->first_column;
 	rmd->r5or6_last_column = rmd->r5or6_last_row_offset / rmd->strip_size;
 #endif
@@ -2835,13 +2796,10 @@ static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data *rmd,
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
 	/* Request is eligible. */
-	rmd->map_row =
-		((u32)(rmd->first_row >> raid_map->parity_rotation_shift)) %
+	rmd->map_row = ((u32)(rmd->first_row >> raid_map->parity_rotation_shift)) %
 		get_unaligned_le16(&raid_map->row_cnt);
 
-	rmd->map_index = (rmd->first_group *
-		(get_unaligned_le16(&raid_map->row_cnt) *
-		rmd->total_disks_per_row)) +
+	rmd->map_index = (rmd->first_group * (get_unaligned_le16(&raid_map->row_cnt) * rmd->total_disks_per_row)) +
 		(rmd->map_row * rmd->total_disks_per_row) + rmd->first_column;
 
 	if (rmd->is_write) {
@@ -2949,8 +2907,7 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 	if (rc)
 		return PQI_RAID_BYPASS_INELIGIBLE;
 
-	if (device->raid_level == SA_RAID_1 ||
-		device->raid_level == SA_RAID_TRIPLE) {
+	if (device->raid_level == SA_RAID_1 || device->raid_level == SA_RAID_TRIPLE) {
 		if (rmd.is_write) {
 			pqi_calc_aio_r1_nexus(raid_map, &rmd);
 		} else {
@@ -2961,8 +2918,7 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 			device->next_bypass_group[rmd.map_index] = next_bypass_group;
 			rmd.map_index += group * rmd.data_disks_per_row;
 		}
-	} else if ((device->raid_level == SA_RAID_5 ||
-		device->raid_level == SA_RAID_6) &&
+	} else if ((device->raid_level == SA_RAID_5 || device->raid_level == SA_RAID_6) &&
 		(rmd.layout_map_count > 1 || rmd.is_write)) {
 		rc = pqi_calc_aio_r5_or_r6(&rmd, raid_map);
 		if (rc)
@@ -3129,8 +3085,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 	case PQI_DATA_IN_OUT_GOOD:
 		break;
 	case PQI_DATA_IN_OUT_UNDERFLOW:
-		xfer_count =
-			get_unaligned_le32(&error_info->data_out_transferred);
+		xfer_count = get_unaligned_le32(&error_info->data_out_transferred);
 		residual_count = scsi_bufflen(scmd) - xfer_count;
 		scsi_set_resid(scmd, residual_count);
 		if (xfer_count < scmd->underflow)
@@ -3166,8 +3121,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 
 	sense_data_length = get_unaligned_le16(&error_info->sense_data_length);
 	if (sense_data_length == 0)
-		sense_data_length =
-			get_unaligned_le16(&error_info->response_data_length);
+		sense_data_length = get_unaligned_le16(&error_info->response_data_length);
 	if (sense_data_length) {
 		if (sense_data_length > sizeof(error_info->data))
 			sense_data_length = sizeof(error_info->data);
@@ -3199,8 +3153,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 
 		if (sense_data_length > SCSI_SENSE_BUFFERSIZE)
 			sense_data_length = SCSI_SENSE_BUFFERSIZE;
-		memcpy(scmd->sense_buffer, error_info->data,
-			sense_data_length);
+		memcpy(scmd->sense_buffer, error_info->data, sense_data_length);
 	}
 
 	scmd->result = scsi_status;
@@ -3237,8 +3190,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 			break;
 		case PQI_AIO_STATUS_UNDERRUN:
 			scsi_status = SAM_STAT_GOOD;
-			residual_count = get_unaligned_le32(
-						&error_info->residual_count);
+			residual_count = get_unaligned_le32(&error_info->residual_count);
 			scsi_set_resid(scmd, residual_count);
 			xfer_count = scsi_bufflen(scmd) - residual_count;
 			if (xfer_count < scmd->underflow)
@@ -3285,15 +3237,13 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	}
 
 	if (error_info->data_present) {
-		sense_data_length =
-			get_unaligned_le16(&error_info->data_length);
+		sense_data_length = get_unaligned_le16(&error_info->data_length);
 		if (sense_data_length) {
 			if (sense_data_length > sizeof(error_info->data))
 				sense_data_length = sizeof(error_info->data);
 			if (sense_data_length > SCSI_SENSE_BUFFERSIZE)
 				sense_data_length = SCSI_SENSE_BUFFERSIZE;
-			memcpy(scmd->sense_buffer, error_info->data,
-				sense_data_length);
+			memcpy(scmd->sense_buffer, error_info->data, sense_data_length);
 		}
 	}
 
@@ -3376,8 +3326,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 			break;
 
 		num_responses++;
-		response = queue_group->oq_element_array +
-			(oq_ci * PQI_OPERATIONAL_OQ_ELEMENT_LENGTH);
+		response = queue_group->oq_element_array + (oq_ci * PQI_OPERATIONAL_OQ_ELEMENT_LENGTH);
 
 		request_id = get_unaligned_le16(&response->request_id);
 		if (request_id >= ctrl_info->max_io_slots) {
@@ -3406,13 +3355,10 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 		case PQI_RESPONSE_IU_GENERAL_MANAGEMENT:
 			break;
 		case PQI_RESPONSE_IU_VENDOR_GENERAL:
-			io_request->status =
-				get_unaligned_le16(
-				&((struct pqi_vendor_general_response *)response)->status);
+			io_request->status = get_unaligned_le16(&((struct pqi_vendor_general_response *)response)->status);
 			break;
 		case PQI_RESPONSE_IU_TASK_MANAGEMENT:
-			io_request->status = pqi_interpret_task_management_response(ctrl_info,
-				(void *)response);
+			io_request->status = pqi_interpret_task_management_response(ctrl_info, (void *)response);
 			break;
 		case PQI_RESPONSE_IU_AIO_PATH_DISABLED:
 			pqi_aio_path_disabled(io_request);
@@ -3421,8 +3367,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 		case PQI_RESPONSE_IU_RAID_PATH_IO_ERROR:
 		case PQI_RESPONSE_IU_AIO_PATH_IO_ERROR:
 			io_request->error_info = ctrl_info->error_buffer +
-				(get_unaligned_le16(&response->error_index) *
-				PQI_ERROR_BUFFER_ELEMENT_LENGTH);
+				(get_unaligned_le16(&response->error_index) * PQI_ERROR_BUFFER_ELEMENT_LENGTH);
 			pqi_process_io_error(response->header.iu_type, io_request);
 			break;
 		default:
@@ -3481,12 +3426,10 @@ static void pqi_send_event_ack(struct pqi_ctrl_info *ctrl_info,
 		iq_pi = queue_group->iq_pi_copy[RAID_PATH];
 		iq_ci = readl(queue_group->iq_ci[RAID_PATH]);
 
-		if (pqi_num_elements_free(iq_pi, iq_ci,
-			ctrl_info->num_elements_per_iq))
+		if (pqi_num_elements_free(iq_pi, iq_ci, ctrl_info->num_elements_per_iq))
 			break;
 
-		spin_unlock_irqrestore(
-			&queue_group->submit_lock[RAID_PATH], flags);
+		spin_unlock_irqrestore(&queue_group->submit_lock[RAID_PATH], flags);
 
 		if (pqi_ctrl_offline(ctrl_info))
 			return;
@@ -3517,8 +3460,7 @@ static void pqi_acknowledge_event(struct pqi_ctrl_info *ctrl_info,
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_ACKNOWLEDGE_VENDOR_EVENT;
-	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH, &request.header.iu_length);
 	request.event_type = event->event_type;
 	put_unaligned_le16(event->event_id, &request.event_id);
 	put_unaligned_le32(event->additional_event_id, &request.additional_event_id);
@@ -3577,7 +3519,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		fallthrough;
 	case RESET_INITIATE_DRIVER:
 		dev_info(&ctrl_info->pci_dev->dev,
-				"Online Firmware Activation: resetting controller\n");
+			"Online Firmware Activation: resetting controller\n");
 		sis_soft_reset(ctrl_info);
 		fallthrough;
 	case RESET_INITIATE_FIRMWARE:
@@ -3587,12 +3529,12 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		dev_info(&ctrl_info->pci_dev->dev,
-				"Online Firmware Activation: %s\n",
-				rc == 0 ? "SUCCESS" : "FAILED");
+			"Online Firmware Activation: %s\n",
+			rc == 0 ? "SUCCESS" : "FAILED");
 		break;
 	case RESET_ABORT:
 		dev_info(&ctrl_info->pci_dev->dev,
-				"Online Firmware Activation ABORTED\n");
+			"Online Firmware Activation ABORTED\n");
 		if (ctrl_info->soft_reset_handshake_supported)
 			pqi_clear_soft_reset_status(ctrl_info);
 		pqi_ofa_free_host_buffer(ctrl_info);
@@ -3762,8 +3704,7 @@ static void pqi_heartbeat_timer_handler(struct timer_list *t)
 	}
 
 	ctrl_info->previous_heartbeat_count = heartbeat_count;
-	mod_timer(&ctrl_info->heartbeat_timer,
-		jiffies + PQI_HEARTBEAT_TIMER_INTERVAL);
+	mod_timer(&ctrl_info->heartbeat_timer, jiffies + PQI_HEARTBEAT_TIMER_INTERVAL);
 }
 
 static void pqi_start_heartbeat_timer(struct pqi_ctrl_info *ctrl_info)
@@ -3771,13 +3712,10 @@ static void pqi_start_heartbeat_timer(struct pqi_ctrl_info *ctrl_info)
 	if (!ctrl_info->heartbeat_counter)
 		return;
 
-	ctrl_info->previous_num_interrupts =
-		atomic_read(&ctrl_info->num_interrupts);
-	ctrl_info->previous_heartbeat_count =
-		pqi_read_heartbeat_counter(ctrl_info);
+	ctrl_info->previous_num_interrupts = atomic_read(&ctrl_info->num_interrupts);
+	ctrl_info->previous_heartbeat_count = pqi_read_heartbeat_counter(ctrl_info);
 
-	ctrl_info->heartbeat_timer.expires =
-		jiffies + PQI_HEARTBEAT_TIMER_INTERVAL;
+	ctrl_info->heartbeat_timer.expires = jiffies + PQI_HEARTBEAT_TIMER_INTERVAL;
 	add_timer(&ctrl_info->heartbeat_timer);
 }
 
@@ -3791,12 +3729,10 @@ static void pqi_ofa_capture_event_payload(struct pqi_ctrl_info *ctrl_info,
 {
 	switch (event->event_id) {
 	case PQI_EVENT_OFA_MEMORY_ALLOCATION:
-		ctrl_info->ofa_bytes_requested =
-			get_unaligned_le32(&response->data.ofa_memory_allocation.bytes_requested);
+		ctrl_info->ofa_bytes_requested = get_unaligned_le32(&response->data.ofa_memory_allocation.bytes_requested);
 		break;
 	case PQI_EVENT_OFA_CANCELED:
-		ctrl_info->ofa_cancel_reason =
-			get_unaligned_le16(&response->data.ofa_cancelled.reason);
+		ctrl_info->ofa_cancel_reason = get_unaligned_le16(&response->data.ofa_cancelled.reason);
 		break;
 	}
 }
@@ -3838,8 +3774,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 			event->pending = true;
 			event->event_type = response->event_type;
 			event->event_id = get_unaligned_le16(&response->event_id);
-			event->additional_event_id =
-				get_unaligned_le32(&response->additional_event_id);
+			event->additional_event_id = get_unaligned_le32(&response->additional_event_id);
 			if (event->event_type == PQI_EVENT_TYPE_OFA)
 				pqi_ofa_capture_event_payload(ctrl_info, event, response);
 		}
@@ -4030,6 +3965,7 @@ static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 	num_vectors_enabled = pci_alloc_irq_vectors(ctrl_info->pci_dev,
 			PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
 			flags);
+
 	if (num_vectors_enabled < 0) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"MSI-X init failed with error %d\n",
@@ -4039,6 +3975,7 @@ static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->num_msix_vectors_enabled = num_vectors_enabled;
 	ctrl_info->irq_mode = IRQ_MODE_MSIX;
+
 	return 0;
 }
 
@@ -4064,12 +4001,8 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 	unsigned int num_queue_indexes;
 	struct pqi_queue_group *queue_group;
 
-	element_array_length_per_iq =
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH *
-		ctrl_info->num_elements_per_iq;
-	element_array_length_per_oq =
-		PQI_OPERATIONAL_OQ_ELEMENT_LENGTH *
-		ctrl_info->num_elements_per_oq;
+	element_array_length_per_iq = PQI_OPERATIONAL_IQ_ELEMENT_LENGTH * ctrl_info->num_elements_per_iq;
+	element_array_length_per_oq = PQI_OPERATIONAL_OQ_ELEMENT_LENGTH * ctrl_info->num_elements_per_oq;
 	num_inbound_queues = ctrl_info->num_queue_groups * 2;
 	num_outbound_queues = ctrl_info->num_queue_groups;
 	num_queue_indexes = (ctrl_info->num_queue_groups * 3) + 1;
@@ -4077,30 +4010,24 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 	aligned_pointer = NULL;
 
 	for (i = 0; i < num_inbound_queues; i++) {
-		aligned_pointer = PTR_ALIGN(aligned_pointer,
-			PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+		aligned_pointer = PTR_ALIGN(aligned_pointer, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 		aligned_pointer += element_array_length_per_iq;
 	}
 
 	for (i = 0; i < num_outbound_queues; i++) {
-		aligned_pointer = PTR_ALIGN(aligned_pointer,
-			PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+		aligned_pointer = PTR_ALIGN(aligned_pointer, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 		aligned_pointer += element_array_length_per_oq;
 	}
 
-	aligned_pointer = PTR_ALIGN(aligned_pointer,
-		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
-	aligned_pointer += PQI_NUM_EVENT_QUEUE_ELEMENTS *
-		PQI_EVENT_OQ_ELEMENT_LENGTH;
+	aligned_pointer = PTR_ALIGN(aligned_pointer, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+	aligned_pointer += PQI_NUM_EVENT_QUEUE_ELEMENTS * PQI_EVENT_OQ_ELEMENT_LENGTH;
 
 	for (i = 0; i < num_queue_indexes; i++) {
-		aligned_pointer = PTR_ALIGN(aligned_pointer,
-			PQI_OPERATIONAL_INDEX_ALIGNMENT);
+		aligned_pointer = PTR_ALIGN(aligned_pointer, PQI_OPERATIONAL_INDEX_ALIGNMENT);
 		aligned_pointer += sizeof(pqi_index_t);
 	}
 
-	alloc_length = (size_t)aligned_pointer +
-		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT;
+	alloc_length = (size_t)aligned_pointer + PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT;
 
 	alloc_length += PQI_EXTRA_SGL_MEMORY;
 
@@ -4114,8 +4041,7 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->queue_memory_length = alloc_length;
 
-	element_array = PTR_ALIGN(ctrl_info->queue_memory_base,
-		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+	element_array = PTR_ALIGN(ctrl_info->queue_memory_base, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 
 	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
 		queue_group = &ctrl_info->queue_groups[i];
@@ -4124,71 +4050,52 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 			ctrl_info->queue_memory_base_dma_handle +
 				(element_array - ctrl_info->queue_memory_base);
 		element_array += element_array_length_per_iq;
-		element_array = PTR_ALIGN(element_array,
-			PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+		element_array = PTR_ALIGN(element_array, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 		queue_group->iq_element_array[AIO_PATH] = element_array;
-		queue_group->iq_element_array_bus_addr[AIO_PATH] =
-			ctrl_info->queue_memory_base_dma_handle +
+		queue_group->iq_element_array_bus_addr[AIO_PATH] = ctrl_info->queue_memory_base_dma_handle +
 			(element_array - ctrl_info->queue_memory_base);
 		element_array += element_array_length_per_iq;
-		element_array = PTR_ALIGN(element_array,
-			PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+		element_array = PTR_ALIGN(element_array, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 	}
 
 	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
 		queue_group = &ctrl_info->queue_groups[i];
 		queue_group->oq_element_array = element_array;
-		queue_group->oq_element_array_bus_addr =
-			ctrl_info->queue_memory_base_dma_handle +
+		queue_group->oq_element_array_bus_addr = ctrl_info->queue_memory_base_dma_handle +
 			(element_array - ctrl_info->queue_memory_base);
 		element_array += element_array_length_per_oq;
-		element_array = PTR_ALIGN(element_array,
-			PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+		element_array = PTR_ALIGN(element_array, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
 	}
 
 	ctrl_info->event_queue.oq_element_array = element_array;
-	ctrl_info->event_queue.oq_element_array_bus_addr =
-		ctrl_info->queue_memory_base_dma_handle +
+	ctrl_info->event_queue.oq_element_array_bus_addr = ctrl_info->queue_memory_base_dma_handle +
 		(element_array - ctrl_info->queue_memory_base);
-	element_array += PQI_NUM_EVENT_QUEUE_ELEMENTS *
-		PQI_EVENT_OQ_ELEMENT_LENGTH;
+	element_array += PQI_NUM_EVENT_QUEUE_ELEMENTS * PQI_EVENT_OQ_ELEMENT_LENGTH;
 
-	next_queue_index = (void __iomem *)PTR_ALIGN(element_array,
-		PQI_OPERATIONAL_INDEX_ALIGNMENT);
+	next_queue_index = (void __iomem *)PTR_ALIGN(element_array, PQI_OPERATIONAL_INDEX_ALIGNMENT);
 
 	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
 		queue_group = &ctrl_info->queue_groups[i];
 		queue_group->iq_ci[RAID_PATH] = next_queue_index;
-		queue_group->iq_ci_bus_addr[RAID_PATH] =
-			ctrl_info->queue_memory_base_dma_handle +
-			(next_queue_index -
-			(void __iomem *)ctrl_info->queue_memory_base);
+		queue_group->iq_ci_bus_addr[RAID_PATH] = ctrl_info->queue_memory_base_dma_handle +
+			(next_queue_index - (void __iomem *)ctrl_info->queue_memory_base);
 		next_queue_index += sizeof(pqi_index_t);
-		next_queue_index = PTR_ALIGN(next_queue_index,
-			PQI_OPERATIONAL_INDEX_ALIGNMENT);
+		next_queue_index = PTR_ALIGN(next_queue_index, PQI_OPERATIONAL_INDEX_ALIGNMENT);
 		queue_group->iq_ci[AIO_PATH] = next_queue_index;
-		queue_group->iq_ci_bus_addr[AIO_PATH] =
-			ctrl_info->queue_memory_base_dma_handle +
-			(next_queue_index -
-			(void __iomem *)ctrl_info->queue_memory_base);
+		queue_group->iq_ci_bus_addr[AIO_PATH] = ctrl_info->queue_memory_base_dma_handle +
+			(next_queue_index - (void __iomem *)ctrl_info->queue_memory_base);
 		next_queue_index += sizeof(pqi_index_t);
-		next_queue_index = PTR_ALIGN(next_queue_index,
-			PQI_OPERATIONAL_INDEX_ALIGNMENT);
+		next_queue_index = PTR_ALIGN(next_queue_index, PQI_OPERATIONAL_INDEX_ALIGNMENT);
 		queue_group->oq_pi = next_queue_index;
-		queue_group->oq_pi_bus_addr =
-			ctrl_info->queue_memory_base_dma_handle +
-			(next_queue_index -
-			(void __iomem *)ctrl_info->queue_memory_base);
+		queue_group->oq_pi_bus_addr = ctrl_info->queue_memory_base_dma_handle +
+			(next_queue_index - (void __iomem *)ctrl_info->queue_memory_base);
 		next_queue_index += sizeof(pqi_index_t);
-		next_queue_index = PTR_ALIGN(next_queue_index,
-			PQI_OPERATIONAL_INDEX_ALIGNMENT);
+		next_queue_index = PTR_ALIGN(next_queue_index, PQI_OPERATIONAL_INDEX_ALIGNMENT);
 	}
 
 	ctrl_info->event_queue.oq_pi = next_queue_index;
-	ctrl_info->event_queue.oq_pi_bus_addr =
-		ctrl_info->queue_memory_base_dma_handle +
-		(next_queue_index -
-		(void __iomem *)ctrl_info->queue_memory_base);
+	ctrl_info->event_queue.oq_pi_bus_addr = ctrl_info->queue_memory_base_dma_handle +
+		(next_queue_index - (void __iomem *)ctrl_info->queue_memory_base);
 
 	return 0;
 }
@@ -4240,8 +4147,7 @@ static int pqi_alloc_admin_queues(struct pqi_ctrl_info *ctrl_info)
 	struct pqi_admin_queues_aligned *admin_queues_aligned;
 	struct pqi_admin_queues *admin_queues;
 
-	alloc_length = sizeof(struct pqi_admin_queues_aligned) +
-		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT;
+	alloc_length = sizeof(struct pqi_admin_queues_aligned) + PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT;
 
 	ctrl_info->admin_queue_memory_base =
 		dma_alloc_coherent(&ctrl_info->pci_dev->dev, alloc_length,
@@ -4254,33 +4160,20 @@ static int pqi_alloc_admin_queues(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->admin_queue_memory_length = alloc_length;
 
 	admin_queues = &ctrl_info->admin_queues;
-	admin_queues_aligned = PTR_ALIGN(ctrl_info->admin_queue_memory_base,
-		PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
-	admin_queues->iq_element_array =
-		&admin_queues_aligned->iq_element_array;
-	admin_queues->oq_element_array =
-		&admin_queues_aligned->oq_element_array;
-	admin_queues->iq_ci =
-		(pqi_index_t __iomem *)&admin_queues_aligned->iq_ci;
-	admin_queues->oq_pi =
-		(pqi_index_t __iomem *)&admin_queues_aligned->oq_pi;
-
-	admin_queues->iq_element_array_bus_addr =
-		ctrl_info->admin_queue_memory_base_dma_handle +
-		(admin_queues->iq_element_array -
-		ctrl_info->admin_queue_memory_base);
-	admin_queues->oq_element_array_bus_addr =
-		ctrl_info->admin_queue_memory_base_dma_handle +
-		(admin_queues->oq_element_array -
-		ctrl_info->admin_queue_memory_base);
-	admin_queues->iq_ci_bus_addr =
-		ctrl_info->admin_queue_memory_base_dma_handle +
-		((void __iomem *)admin_queues->iq_ci -
-		(void __iomem *)ctrl_info->admin_queue_memory_base);
-	admin_queues->oq_pi_bus_addr =
-		ctrl_info->admin_queue_memory_base_dma_handle +
-		((void __iomem *)admin_queues->oq_pi -
-		(void __iomem *)ctrl_info->admin_queue_memory_base);
+	admin_queues_aligned = PTR_ALIGN(ctrl_info->admin_queue_memory_base, PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT);
+	admin_queues->iq_element_array = &admin_queues_aligned->iq_element_array;
+	admin_queues->oq_element_array = &admin_queues_aligned->oq_element_array;
+	admin_queues->iq_ci = (pqi_index_t __iomem *)&admin_queues_aligned->iq_ci;
+	admin_queues->oq_pi = (pqi_index_t __iomem *)&admin_queues_aligned->oq_pi;
+
+	admin_queues->iq_element_array_bus_addr = ctrl_info->admin_queue_memory_base_dma_handle +
+		(admin_queues->iq_element_array - ctrl_info->admin_queue_memory_base);
+	admin_queues->oq_element_array_bus_addr = ctrl_info->admin_queue_memory_base_dma_handle +
+		(admin_queues->oq_element_array - ctrl_info->admin_queue_memory_base);
+	admin_queues->iq_ci_bus_addr = ctrl_info->admin_queue_memory_base_dma_handle +
+		((void __iomem *)admin_queues->iq_ci - (void __iomem *)ctrl_info->admin_queue_memory_base);
+	admin_queues->oq_pi_bus_addr = ctrl_info->admin_queue_memory_base_dma_handle +
+		((void __iomem *)admin_queues->oq_pi - (void __iomem *)ctrl_info->admin_queue_memory_base);
 
 	return 0;
 }
@@ -4299,22 +4192,15 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
 	pqi_registers = ctrl_info->pqi_registers;
 	admin_queues = &ctrl_info->admin_queues;
 
-	writeq((u64)admin_queues->iq_element_array_bus_addr,
-		&pqi_registers->admin_iq_element_array_addr);
-	writeq((u64)admin_queues->oq_element_array_bus_addr,
-		&pqi_registers->admin_oq_element_array_addr);
-	writeq((u64)admin_queues->iq_ci_bus_addr,
-		&pqi_registers->admin_iq_ci_addr);
-	writeq((u64)admin_queues->oq_pi_bus_addr,
-		&pqi_registers->admin_oq_pi_addr);
-
-	reg = PQI_ADMIN_IQ_NUM_ELEMENTS |
-		(PQI_ADMIN_OQ_NUM_ELEMENTS << 8) |
-		(admin_queues->int_msg_num << 16);
+	writeq((u64)admin_queues->iq_element_array_bus_addr, &pqi_registers->admin_iq_element_array_addr);
+	writeq((u64)admin_queues->oq_element_array_bus_addr, &pqi_registers->admin_oq_element_array_addr);
+	writeq((u64)admin_queues->iq_ci_bus_addr, &pqi_registers->admin_iq_ci_addr);
+	writeq((u64)admin_queues->oq_pi_bus_addr, &pqi_registers->admin_oq_pi_addr);
+
+	reg = PQI_ADMIN_IQ_NUM_ELEMENTS | (PQI_ADMIN_OQ_NUM_ELEMENTS << 8) | (admin_queues->int_msg_num << 16);
 	writel(reg, &pqi_registers->admin_iq_num_elements);
 
-	writel(PQI_CREATE_ADMIN_QUEUE_PAIR,
-		&pqi_registers->function_and_status_code);
+	writel(PQI_CREATE_ADMIN_QUEUE_PAIR, &pqi_registers->function_and_status_code);
 
 	timeout = PQI_ADMIN_QUEUE_CREATE_TIMEOUT_JIFFIES + jiffies;
 	while (1) {
@@ -4331,11 +4217,9 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
 	 * offsets until *after* the create admin queue pair command
 	 * completes successfully.
 	 */
-	admin_queues->iq_pi = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
+	admin_queues->iq_pi = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
 		readq(&pqi_registers->admin_iq_pi_offset);
-	admin_queues->oq_ci = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
+	admin_queues->oq_ci = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
 		readq(&pqi_registers->admin_oq_ci_offset);
 
 	return 0;
@@ -4366,7 +4250,7 @@ static void pqi_submit_admin_request(struct pqi_ctrl_info *ctrl_info,
 	writel(iq_pi, admin_queues->iq_pi);
 }
 
-#define PQI_ADMIN_REQUEST_TIMEOUT_SECS	60
+#define PQI_ADMIN_REQUEST_TIMEOUT_SECS		60
 
 static int pqi_poll_for_admin_response(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_general_admin_response *response)
@@ -4430,45 +4314,35 @@ static void pqi_start_io(struct pqi_ctrl_info *ctrl_info,
 
 	iq_pi = queue_group->iq_pi_copy[path];
 
-	list_for_each_entry_safe(io_request, next,
-		&queue_group->request_list[path], request_list_entry) {
-
+	list_for_each_entry_safe(io_request, next, &queue_group->request_list[path], request_list_entry) {
 		request = io_request->iu;
 
-		iu_length = get_unaligned_le16(&request->iu_length) +
-			PQI_REQUEST_HEADER_LENGTH;
-		num_elements_needed =
-			DIV_ROUND_UP(iu_length,
-				PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
+		iu_length = get_unaligned_le16(&request->iu_length) + PQI_REQUEST_HEADER_LENGTH;
+		num_elements_needed = DIV_ROUND_UP(iu_length, PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
 
 		iq_ci = readl(queue_group->iq_ci[path]);
 
-		if (num_elements_needed > pqi_num_elements_free(iq_pi, iq_ci,
-			ctrl_info->num_elements_per_iq))
+		if (num_elements_needed > pqi_num_elements_free(iq_pi, iq_ci, ctrl_info->num_elements_per_iq))
 			break;
 
-		put_unaligned_le16(queue_group->oq_id,
-			&request->response_queue_id);
+		put_unaligned_le16(queue_group->oq_id, &request->response_queue_id);
 
 		next_element = queue_group->iq_element_array[path] +
 			(iq_pi * PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
 
-		num_elements_to_end_of_queue =
-			ctrl_info->num_elements_per_iq - iq_pi;
+		num_elements_to_end_of_queue = ctrl_info->num_elements_per_iq - iq_pi;
 
 		if (num_elements_needed <= num_elements_to_end_of_queue) {
 			memcpy(next_element, request, iu_length);
 		} else {
-			copy_count = num_elements_to_end_of_queue *
-				PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
+			copy_count = num_elements_to_end_of_queue * PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
 			memcpy(next_element, request, copy_count);
 			memcpy(queue_group->iq_element_array[path],
 				(u8 *)request + copy_count,
 				iu_length - copy_count);
 		}
 
-		iq_pi = (iq_pi + num_elements_needed) %
-			ctrl_info->num_elements_per_iq;
+		iq_pi = (iq_pi + num_elements_needed) % ctrl_info->num_elements_per_iq;
 
 		list_del(&io_request->request_list_entry);
 	}
@@ -4528,8 +4402,7 @@ static int pqi_process_raid_io_error_synchronous(
 			rc = 0;
 		break;
 	case PQI_DATA_IN_OUT_UNDERFLOW:
-		if (error_info->status == SAM_STAT_GOOD ||
-			error_info->status == SAM_STAT_CHECK_CONDITION)
+		if (error_info->status == SAM_STAT_GOOD || error_info->status == SAM_STAT_CHECK_CONDITION)
 			rc = 0;
 		break;
 	case PQI_DATA_IN_OUT_ABORTED:
@@ -4562,9 +4435,10 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	}
 
 	pqi_ctrl_busy(ctrl_info);
+
 	/*
-	 * Wait for other admin queue updates such as;
-	 * config table changes, OFA memory updates, ...
+	 * Wait for other admin queue updates such as
+	 * config table changes, OFA memory updates, etc.
 	 */
 	if (pqi_is_blockable_request(request))
 		pqi_wait_if_ctrl_blocked(ctrl_info);
@@ -4576,22 +4450,19 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 
-	put_unaligned_le16(io_request->index,
-		&(((struct pqi_raid_path_request *)request)->request_id));
+	put_unaligned_le16(io_request->index, &(((struct pqi_raid_path_request *)request)->request_id));
 
 	if (request->iu_type == PQI_REQUEST_IU_RAID_PATH_IO)
 		((struct pqi_raid_path_request *)request)->error_index =
 			((struct pqi_raid_path_request *)request)->request_id;
 
-	iu_length = get_unaligned_le16(&request->iu_length) +
-		PQI_REQUEST_HEADER_LENGTH;
+	iu_length = get_unaligned_le16(&request->iu_length) + PQI_REQUEST_HEADER_LENGTH;
 	memcpy(io_request->iu, request, iu_length);
 
 	io_request->io_complete_callback = pqi_raid_synchronous_complete;
 	io_request->context = &wait;
 
-	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
-		io_request);
+	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH, io_request);
 
 	pqi_wait_for_completion_io(ctrl_info, &wait);
 
@@ -4613,14 +4484,13 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-static int pqi_validate_admin_response(
-	struct pqi_general_admin_response *response, u8 expected_function_code)
+static int pqi_validate_admin_response(struct pqi_general_admin_response *response,
+	u8 expected_function_code)
 {
 	if (response->header.iu_type != PQI_RESPONSE_IU_GENERAL_ADMIN)
 		return -EINVAL;
 
-	if (get_unaligned_le16(&response->header.iu_length) !=
-		PQI_GENERAL_ADMIN_IU_LENGTH)
+	if (get_unaligned_le16(&response->header.iu_length) != PQI_GENERAL_ADMIN_IU_LENGTH)
 		return -EINVAL;
 
 	if (response->function_code != expected_function_code)
@@ -4632,10 +4502,8 @@ static int pqi_validate_admin_response(
 	return 0;
 }
 
-static int pqi_submit_admin_request_synchronous(
-	struct pqi_ctrl_info *ctrl_info,
-	struct pqi_general_admin_request *request,
-	struct pqi_general_admin_response *response)
+static int pqi_submit_admin_request_synchronous(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_general_admin_request *request, struct pqi_general_admin_response *response)
 {
 	int rc;
 
@@ -4664,17 +4532,13 @@ static int pqi_report_device_capability(struct pqi_ctrl_info *ctrl_info)
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
-	request.function_code =
-		PQI_GENERAL_ADMIN_FUNCTION_REPORT_DEVICE_CAPABILITY;
-	put_unaligned_le32(sizeof(*capability),
-		&request.data.report_device_capability.buffer_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
+	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_REPORT_DEVICE_CAPABILITY;
+	put_unaligned_le32(sizeof(*capability), &request.data.report_device_capability.buffer_length);
 
 	rc = pqi_map_single(ctrl_info->pci_dev,
 		&request.data.report_device_capability.sg_descriptor,
-		capability, sizeof(*capability),
-		DMA_FROM_DEVICE);
+		capability, sizeof(*capability), DMA_FROM_DEVICE);
 	if (rc)
 		goto out;
 
@@ -4692,31 +4556,18 @@ static int pqi_report_device_capability(struct pqi_ctrl_info *ctrl_info)
 		goto out;
 	}
 
-	ctrl_info->max_inbound_queues =
-		get_unaligned_le16(&capability->max_inbound_queues);
-	ctrl_info->max_elements_per_iq =
-		get_unaligned_le16(&capability->max_elements_per_iq);
-	ctrl_info->max_iq_element_length =
-		get_unaligned_le16(&capability->max_iq_element_length)
-		* 16;
-	ctrl_info->max_outbound_queues =
-		get_unaligned_le16(&capability->max_outbound_queues);
-	ctrl_info->max_elements_per_oq =
-		get_unaligned_le16(&capability->max_elements_per_oq);
-	ctrl_info->max_oq_element_length =
-		get_unaligned_le16(&capability->max_oq_element_length)
-		* 16;
-
-	sop_iu_layer_descriptor =
-		&capability->iu_layer_descriptors[PQI_PROTOCOL_SOP];
-
-	ctrl_info->max_inbound_iu_length_per_firmware =
-		get_unaligned_le16(
-			&sop_iu_layer_descriptor->max_inbound_iu_length);
-	ctrl_info->inbound_spanning_supported =
-		sop_iu_layer_descriptor->inbound_spanning_supported;
-	ctrl_info->outbound_spanning_supported =
-		sop_iu_layer_descriptor->outbound_spanning_supported;
+	ctrl_info->max_inbound_queues = get_unaligned_le16(&capability->max_inbound_queues);
+	ctrl_info->max_elements_per_iq = get_unaligned_le16(&capability->max_elements_per_iq);
+	ctrl_info->max_iq_element_length = get_unaligned_le16(&capability->max_iq_element_length) * 16;
+	ctrl_info->max_outbound_queues = get_unaligned_le16(&capability->max_outbound_queues);
+	ctrl_info->max_elements_per_oq = get_unaligned_le16(&capability->max_elements_per_oq);
+	ctrl_info->max_oq_element_length = get_unaligned_le16(&capability->max_oq_element_length) * 16;
+
+	sop_iu_layer_descriptor = &capability->iu_layer_descriptors[PQI_PROTOCOL_SOP];
+
+	ctrl_info->max_inbound_iu_length_per_firmware = get_unaligned_le16(&sop_iu_layer_descriptor->max_inbound_iu_length);
+	ctrl_info->inbound_spanning_supported = sop_iu_layer_descriptor->inbound_spanning_supported;
+	ctrl_info->outbound_spanning_supported = sop_iu_layer_descriptor->outbound_spanning_supported;
 
 out:
 	kfree(capability);
@@ -4726,8 +4577,7 @@ static int pqi_report_device_capability(struct pqi_ctrl_info *ctrl_info)
 
 static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
 {
-	if (ctrl_info->max_iq_element_length <
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) {
+	if (ctrl_info->max_iq_element_length < PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"max. inbound queue element length of %d is less than the required length of %d\n",
 			ctrl_info->max_iq_element_length,
@@ -4735,8 +4585,7 @@ static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
 		return -EINVAL;
 	}
 
-	if (ctrl_info->max_oq_element_length <
-		PQI_OPERATIONAL_OQ_ELEMENT_LENGTH) {
+	if (ctrl_info->max_oq_element_length < PQI_OPERATIONAL_OQ_ELEMENT_LENGTH) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"max. outbound queue element length of %d is less than the required length of %d\n",
 			ctrl_info->max_oq_element_length,
@@ -4744,8 +4593,7 @@ static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
 		return -EINVAL;
 	}
 
-	if (ctrl_info->max_inbound_iu_length_per_firmware <
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) {
+	if (ctrl_info->max_inbound_iu_length_per_firmware < PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"max. inbound IU length of %u is less than the min. required length of %d\n",
 			ctrl_info->max_inbound_iu_length_per_firmware,
@@ -4783,32 +4631,22 @@ static int pqi_create_event_queue(struct pqi_ctrl_info *ctrl_info)
 	 */
 	memset(&request, 0, sizeof(request));
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
 	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_CREATE_OQ;
-	put_unaligned_le16(event_queue->oq_id,
-		&request.data.create_operational_oq.queue_id);
-	put_unaligned_le64((u64)event_queue->oq_element_array_bus_addr,
-		&request.data.create_operational_oq.element_array_addr);
-	put_unaligned_le64((u64)event_queue->oq_pi_bus_addr,
-		&request.data.create_operational_oq.pi_addr);
-	put_unaligned_le16(PQI_NUM_EVENT_QUEUE_ELEMENTS,
-		&request.data.create_operational_oq.num_elements);
-	put_unaligned_le16(PQI_EVENT_OQ_ELEMENT_LENGTH / 16,
-		&request.data.create_operational_oq.element_length);
+	put_unaligned_le16(event_queue->oq_id, &request.data.create_operational_oq.queue_id);
+	put_unaligned_le64((u64)event_queue->oq_element_array_bus_addr, &request.data.create_operational_oq.element_array_addr);
+	put_unaligned_le64((u64)event_queue->oq_pi_bus_addr, &request.data.create_operational_oq.pi_addr);
+	put_unaligned_le16(PQI_NUM_EVENT_QUEUE_ELEMENTS, &request.data.create_operational_oq.num_elements);
+	put_unaligned_le16(PQI_EVENT_OQ_ELEMENT_LENGTH / 16, &request.data.create_operational_oq.element_length);
 	request.data.create_operational_oq.queue_protocol = PQI_PROTOCOL_SOP;
-	put_unaligned_le16(event_queue->int_msg_num,
-		&request.data.create_operational_oq.int_msg_num);
+	put_unaligned_le16(event_queue->int_msg_num, &request.data.create_operational_oq.int_msg_num);
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 	if (rc)
 		return rc;
 
-	event_queue->oq_ci = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
-		get_unaligned_le64(
-			&response.data.create_operational_oq.oq_ci_offset);
+	event_queue->oq_ci = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
+		get_unaligned_le64(&response.data.create_operational_oq.oq_ci_offset);
 
 	return 0;
 }
@@ -4829,34 +4667,24 @@ static int pqi_create_queue_group(struct pqi_ctrl_info *ctrl_info,
 	 */
 	memset(&request, 0, sizeof(request));
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
 	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_CREATE_IQ;
-	put_unaligned_le16(queue_group->iq_id[RAID_PATH],
-		&request.data.create_operational_iq.queue_id);
-	put_unaligned_le64(
-		(u64)queue_group->iq_element_array_bus_addr[RAID_PATH],
-		&request.data.create_operational_iq.element_array_addr);
-	put_unaligned_le64((u64)queue_group->iq_ci_bus_addr[RAID_PATH],
-		&request.data.create_operational_iq.ci_addr);
-	put_unaligned_le16(ctrl_info->num_elements_per_iq,
-		&request.data.create_operational_iq.num_elements);
-	put_unaligned_le16(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH / 16,
-		&request.data.create_operational_iq.element_length);
+	put_unaligned_le16(queue_group->iq_id[RAID_PATH], &request.data.create_operational_iq.queue_id);
+	put_unaligned_le64((u64)queue_group->iq_element_array_bus_addr[RAID_PATH], &request.data.create_operational_iq.element_array_addr);
+	put_unaligned_le64((u64)queue_group->iq_ci_bus_addr[RAID_PATH], &request.data.create_operational_iq.ci_addr);
+	put_unaligned_le16(ctrl_info->num_elements_per_iq, &request.data.create_operational_iq.num_elements);
+	put_unaligned_le16(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH / 16, &request.data.create_operational_iq.element_length);
 	request.data.create_operational_iq.queue_protocol = PQI_PROTOCOL_SOP;
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"error creating inbound RAID queue\n");
 		return rc;
 	}
 
-	queue_group->iq_pi[RAID_PATH] = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
-		get_unaligned_le64(
-			&response.data.create_operational_iq.iq_pi_offset);
+	queue_group->iq_pi[RAID_PATH] = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
+		get_unaligned_le64(&response.data.create_operational_iq.iq_pi_offset);
 
 	/*
 	 * Create IQ (Inbound Queue - host to device queue) for
@@ -4864,34 +4692,24 @@ static int pqi_create_queue_group(struct pqi_ctrl_info *ctrl_info,
 	 */
 	memset(&request, 0, sizeof(request));
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
 	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_CREATE_IQ;
-	put_unaligned_le16(queue_group->iq_id[AIO_PATH],
-		&request.data.create_operational_iq.queue_id);
-	put_unaligned_le64((u64)queue_group->
-		iq_element_array_bus_addr[AIO_PATH],
-		&request.data.create_operational_iq.element_array_addr);
-	put_unaligned_le64((u64)queue_group->iq_ci_bus_addr[AIO_PATH],
-		&request.data.create_operational_iq.ci_addr);
-	put_unaligned_le16(ctrl_info->num_elements_per_iq,
-		&request.data.create_operational_iq.num_elements);
-	put_unaligned_le16(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH / 16,
-		&request.data.create_operational_iq.element_length);
+	put_unaligned_le16(queue_group->iq_id[AIO_PATH], &request.data.create_operational_iq.queue_id);
+	put_unaligned_le64((u64)queue_group->iq_element_array_bus_addr[AIO_PATH], &request.data.create_operational_iq.element_array_addr);
+	put_unaligned_le64((u64)queue_group->iq_ci_bus_addr[AIO_PATH], &request.data.create_operational_iq.ci_addr);
+	put_unaligned_le16(ctrl_info->num_elements_per_iq, &request.data.create_operational_iq.num_elements);
+	put_unaligned_le16(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH / 16, &request.data.create_operational_iq.element_length);
 	request.data.create_operational_iq.queue_protocol = PQI_PROTOCOL_SOP;
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"error creating inbound AIO queue\n");
 		return rc;
 	}
 
-	queue_group->iq_pi[AIO_PATH] = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
-		get_unaligned_le64(
-			&response.data.create_operational_iq.iq_pi_offset);
+	queue_group->iq_pi[AIO_PATH] = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
+		get_unaligned_le64(&response.data.create_operational_iq.iq_pi_offset);
 
 	/*
 	 * Designate the 2nd IQ as the AIO path.  By default, all IQs are
@@ -4900,16 +4718,12 @@ static int pqi_create_queue_group(struct pqi_ctrl_info *ctrl_info,
 	 */
 	memset(&request, 0, sizeof(request));
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
 	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_CHANGE_IQ_PROPERTY;
-	put_unaligned_le16(queue_group->iq_id[AIO_PATH],
-		&request.data.change_operational_iq_properties.queue_id);
-	put_unaligned_le32(PQI_IQ_PROPERTY_IS_AIO_QUEUE,
-		&request.data.change_operational_iq_properties.vendor_specific);
+	put_unaligned_le16(queue_group->iq_id[AIO_PATH], &request.data.change_operational_iq_properties.queue_id);
+	put_unaligned_le32(PQI_IQ_PROPERTY_IS_AIO_QUEUE, &request.data.change_operational_iq_properties.vendor_specific);
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"error changing queue property\n");
@@ -4921,35 +4735,25 @@ static int pqi_create_queue_group(struct pqi_ctrl_info *ctrl_info,
 	 */
 	memset(&request, 0, sizeof(request));
 	request.header.iu_type = PQI_REQUEST_IU_GENERAL_ADMIN;
-	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH,
-		&request.header.iu_length);
+	put_unaligned_le16(PQI_GENERAL_ADMIN_IU_LENGTH, &request.header.iu_length);
 	request.function_code = PQI_GENERAL_ADMIN_FUNCTION_CREATE_OQ;
-	put_unaligned_le16(queue_group->oq_id,
-		&request.data.create_operational_oq.queue_id);
-	put_unaligned_le64((u64)queue_group->oq_element_array_bus_addr,
-		&request.data.create_operational_oq.element_array_addr);
-	put_unaligned_le64((u64)queue_group->oq_pi_bus_addr,
-		&request.data.create_operational_oq.pi_addr);
-	put_unaligned_le16(ctrl_info->num_elements_per_oq,
-		&request.data.create_operational_oq.num_elements);
-	put_unaligned_le16(PQI_OPERATIONAL_OQ_ELEMENT_LENGTH / 16,
-		&request.data.create_operational_oq.element_length);
+	put_unaligned_le16(queue_group->oq_id, &request.data.create_operational_oq.queue_id);
+	put_unaligned_le64((u64)queue_group->oq_element_array_bus_addr, &request.data.create_operational_oq.element_array_addr);
+	put_unaligned_le64((u64)queue_group->oq_pi_bus_addr, &request.data.create_operational_oq.pi_addr);
+	put_unaligned_le16(ctrl_info->num_elements_per_oq, &request.data.create_operational_oq.num_elements);
+	put_unaligned_le16(PQI_OPERATIONAL_OQ_ELEMENT_LENGTH / 16, &request.data.create_operational_oq.element_length);
 	request.data.create_operational_oq.queue_protocol = PQI_PROTOCOL_SOP;
-	put_unaligned_le16(queue_group->int_msg_num,
-		&request.data.create_operational_oq.int_msg_num);
+	put_unaligned_le16(queue_group->int_msg_num, &request.data.create_operational_oq.int_msg_num);
 
-	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request,
-		&response);
+	rc = pqi_submit_admin_request_synchronous(ctrl_info, &request, &response);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"error creating outbound queue\n");
 		return rc;
 	}
 
-	queue_group->oq_ci = ctrl_info->iomem_base +
-		PQI_DEVICE_REGISTERS_OFFSET +
-		get_unaligned_le64(
-			&response.data.create_operational_oq.oq_ci_offset);
+	queue_group->oq_ci = ctrl_info->iomem_base + PQI_DEVICE_REGISTERS_OFFSET +
+		get_unaligned_le64(&response.data.create_operational_oq.oq_ci_offset);
 
 	return 0;
 }
@@ -4991,8 +4795,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_event_descriptor *event_descriptor;
 	struct pqi_general_management_request request;
 
-	event_config = kmalloc(PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH,
-		GFP_KERNEL);
+	event_config = kmalloc(PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH, GFP_KERNEL);
 	if (!event_config)
 		return -ENOMEM;
 
@@ -5023,10 +4826,8 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 
 	for (i = 0; i < event_config->num_event_descriptors; i++) {
 		event_descriptor = &event_config->descriptors[i];
-		if (enable_events &&
-			pqi_is_supported_event(event_descriptor->event_type))
-				put_unaligned_le16(ctrl_info->event_queue.oq_id,
-					&event_descriptor->oq_id);
+		if (enable_events && pqi_is_supported_event(event_descriptor->event_type))
+			put_unaligned_le16(ctrl_info->event_queue.oq_id, &event_descriptor->oq_id);
 		else
 			put_unaligned_le16(0, &event_descriptor->oq_id);
 	}
@@ -5037,8 +4838,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	put_unaligned_le16(offsetof(struct pqi_general_management_request,
 		data.report_event_configuration.sg_descriptors[1]) -
 		PQI_REQUEST_HEADER_LENGTH, &request.header.iu_length);
-	put_unaligned_le32(PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH,
-		&request.data.report_event_configuration.buffer_length);
+	put_unaligned_le32(PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH, &request.data.report_event_configuration.buffer_length);
 
 	rc = pqi_map_single(ctrl_info->pci_dev,
 		request.data.report_event_configuration.sg_descriptors,
@@ -5049,9 +4849,7 @@ static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 
-	pqi_pci_unmap(ctrl_info->pci_dev,
-		request.data.report_event_configuration.sg_descriptors, 1,
-		DMA_TO_DEVICE);
+	pqi_pci_unmap(ctrl_info->pci_dev, request.data.report_event_configuration.sg_descriptors, 1, DMA_TO_DEVICE);
 
 out:
 	kfree(event_config);
@@ -5169,19 +4967,15 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 	u32 max_transfer_size;
 	u32 max_sg_entries;
 
-	ctrl_info->scsi_ml_can_queue =
-		ctrl_info->max_outstanding_requests - PQI_RESERVED_IO_SLOTS;
+	ctrl_info->scsi_ml_can_queue = ctrl_info->max_outstanding_requests - PQI_RESERVED_IO_SLOTS;
 	ctrl_info->max_io_slots = ctrl_info->max_outstanding_requests;
 
-	ctrl_info->error_buffer_length =
-		ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
+	ctrl_info->error_buffer_length = ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
 
 	if (reset_devices)
-		max_transfer_size = min(ctrl_info->max_transfer_size,
-			PQI_MAX_TRANSFER_SIZE_KDUMP);
+		max_transfer_size = min(ctrl_info->max_transfer_size, PQI_MAX_TRANSFER_SIZE_KDUMP);
 	else
-		max_transfer_size = min(ctrl_info->max_transfer_size,
-			PQI_MAX_TRANSFER_SIZE);
+		max_transfer_size = min(ctrl_info->max_transfer_size, PQI_MAX_TRANSFER_SIZE);
 
 	max_sg_entries = max_transfer_size / PAGE_SIZE;
 
@@ -5192,9 +4986,7 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 
 	max_transfer_size = (max_sg_entries - 1) * PAGE_SIZE;
 
-	ctrl_info->sg_chain_buffer_length =
-		(max_sg_entries * sizeof(struct pqi_sg_descriptor)) +
-		PQI_EXTRA_SGL_MEMORY;
+	ctrl_info->sg_chain_buffer_length = (max_sg_entries * sizeof(struct pqi_sg_descriptor)) + PQI_EXTRA_SGL_MEMORY;
 	ctrl_info->sg_tablesize = max_sg_entries;
 	ctrl_info->max_sectors = max_transfer_size / 512;
 }
@@ -5211,8 +5003,7 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 		int num_cpus;
 		int max_queue_groups;
 
-		max_queue_groups = min(ctrl_info->max_inbound_queues / 2,
-			ctrl_info->max_outbound_queues - 1);
+		max_queue_groups = min(ctrl_info->max_inbound_queues / 2, ctrl_info->max_outbound_queues - 1);
 		max_queue_groups = min(max_queue_groups, PQI_MAX_QUEUE_GROUPS);
 
 		num_cpus = num_online_cpus();
@@ -5226,39 +5017,27 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	 * Make sure that the max. inbound IU length is an even multiple
 	 * of our inbound element length.
 	 */
-	ctrl_info->max_inbound_iu_length =
-		(ctrl_info->max_inbound_iu_length_per_firmware /
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) *
+	ctrl_info->max_inbound_iu_length = (ctrl_info->max_inbound_iu_length_per_firmware / PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) *
 		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
 
-	num_elements_per_iq =
-		(ctrl_info->max_inbound_iu_length /
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
+	num_elements_per_iq = (ctrl_info->max_inbound_iu_length / PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
 
 	/* Add one because one element in each queue is unusable. */
 	num_elements_per_iq++;
 
-	num_elements_per_iq = min(num_elements_per_iq,
-		ctrl_info->max_elements_per_iq);
+	num_elements_per_iq = min(num_elements_per_iq, ctrl_info->max_elements_per_iq);
 
 	num_elements_per_oq = ((num_elements_per_iq - 1) * 2) + 1;
-	num_elements_per_oq = min(num_elements_per_oq,
-		ctrl_info->max_elements_per_oq);
+	num_elements_per_oq = min(num_elements_per_oq, ctrl_info->max_elements_per_oq);
 
 	ctrl_info->num_elements_per_iq = num_elements_per_iq;
 	ctrl_info->num_elements_per_oq = num_elements_per_oq;
 
-	ctrl_info->max_sg_per_iu =
-		((ctrl_info->max_inbound_iu_length -
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
-		sizeof(struct pqi_sg_descriptor)) +
-		PQI_MAX_EMBEDDED_SG_DESCRIPTORS;
+	ctrl_info->max_sg_per_iu = ((ctrl_info->max_inbound_iu_length - PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
+		sizeof(struct pqi_sg_descriptor)) + PQI_MAX_EMBEDDED_SG_DESCRIPTORS;
 
-	ctrl_info->max_sg_per_r56_iu =
-		((ctrl_info->max_inbound_iu_length -
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
-		sizeof(struct pqi_sg_descriptor)) +
-		PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS;
+	ctrl_info->max_sg_per_r56_iu = ((ctrl_info->max_inbound_iu_length - PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) /
+		sizeof(struct pqi_sg_descriptor)) + PQI_MAX_EMBEDDED_R56_SG_DESCRIPTORS;
 }
 
 static inline void pqi_set_sg_descriptor(struct pqi_sg_descriptor *sg_descriptor,
@@ -5293,10 +5072,8 @@ static unsigned int pqi_build_sg_list(struct pqi_sg_descriptor *sg_descriptor,
 			break;
 		sg_descriptor++;
 		if (i == max_sg_per_iu) {
-			put_unaligned_le64((u64)io_request->sg_chain_buffer_dma_handle,
-				&sg_descriptor->address);
-			put_unaligned_le32((sg_count - num_sg_in_iu) * sizeof(*sg_descriptor),
-				&sg_descriptor->length);
+			put_unaligned_le64((u64)io_request->sg_chain_buffer_dma_handle, &sg_descriptor->address);
+			put_unaligned_le32((sg_count - num_sg_in_iu) * sizeof(*sg_descriptor), &sg_descriptor->length);
 			put_unaligned_le32(CISS_SG_CHAIN, &sg_descriptor->flags);
 			*chained = true;
 			num_sg_in_iu++;
@@ -5325,8 +5102,7 @@ static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count < 0)
 		return sg_count;
 
-	iu_length = offsetof(struct pqi_raid_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
+	iu_length = offsetof(struct pqi_raid_path_request, sg_descriptors) - PQI_REQUEST_HEADER_LENGTH;
 
 	if (sg_count == 0)
 		goto out;
@@ -5361,8 +5137,7 @@ static int pqi_build_aio_r1_sg_list(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count < 0)
 		return sg_count;
 
-	iu_length = offsetof(struct pqi_aio_r1_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
+	iu_length = offsetof(struct pqi_aio_r1_path_request, sg_descriptors) - PQI_REQUEST_HEADER_LENGTH;
 	num_sg_in_iu = 0;
 
 	if (sg_count == 0)
@@ -5399,8 +5174,7 @@ static int pqi_build_aio_r56_sg_list(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count < 0)
 		return sg_count;
 
-	iu_length = offsetof(struct pqi_aio_r56_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
+	iu_length = offsetof(struct pqi_aio_r56_path_request, sg_descriptors) - PQI_REQUEST_HEADER_LENGTH;
 	num_sg_in_iu = 0;
 
 	if (sg_count != 0) {
@@ -5435,8 +5209,7 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 	if (sg_count < 0)
 		return sg_count;
 
-	iu_length = offsetof(struct pqi_aio_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
+	iu_length = offsetof(struct pqi_aio_path_request, sg_descriptors) - PQI_REQUEST_HEADER_LENGTH;
 	num_sg_in_iu = 0;
 
 	if (sg_count == 0)
@@ -5911,12 +5684,10 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 		 */
 		if ((pqi_stream_data->next_lba &&
 			rmd.first_block >= pqi_stream_data->next_lba) &&
-			rmd.first_block <= pqi_stream_data->next_lba +
-				rmd.block_cnt) {
-			pqi_stream_data->next_lba = rmd.first_block +
-				rmd.block_cnt;
-			pqi_stream_data->last_accessed = jiffies;
-			return true;
+			rmd.first_block <= pqi_stream_data->next_lba + rmd.block_cnt) {
+				pqi_stream_data->next_lba = rmd.first_block + rmd.block_cnt;
+				pqi_stream_data->last_accessed = jiffies;
+				return true;
 		}
 
 		/* unused entry */
@@ -6112,13 +5883,9 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 		queue_group = &ctrl_info->queue_groups[i];
 
 		for (path = 0; path < 2; path++) {
-			spin_lock_irqsave(
-				&queue_group->submit_lock[path], flags);
-
-			list_for_each_entry_safe(io_request, next,
-				&queue_group->request_list[path],
-				request_list_entry) {
+			spin_lock_irqsave(&queue_group->submit_lock[path], flags);
 
+			list_for_each_entry_safe(io_request, next, &queue_group->request_list[path], request_list_entry) {
 				scmd = io_request->scmd;
 				if (!scmd)
 					continue;
@@ -6134,8 +5901,7 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 				pqi_scsi_done(scmd);
 			}
 
-			spin_unlock_irqrestore(
-				&queue_group->submit_lock[path], flags);
+			spin_unlock_irqrestore(&queue_group->submit_lock[path], flags);
 		}
 	}
 }
@@ -6241,19 +6007,16 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 	memset(request, 0, sizeof(*request));
 
 	request->header.iu_type = PQI_REQUEST_IU_TASK_MANAGEMENT;
-	put_unaligned_le16(sizeof(*request) - PQI_REQUEST_HEADER_LENGTH,
-		&request->header.iu_length);
+	put_unaligned_le16(sizeof(*request) - PQI_REQUEST_HEADER_LENGTH, &request->header.iu_length);
 	put_unaligned_le16(io_request->index, &request->request_id);
-	memcpy(request->lun_number, device->scsi3addr,
-		sizeof(request->lun_number));
+	memcpy(request->lun_number, device->scsi3addr, sizeof(request->lun_number));
 	if (!pqi_is_logical_device(device) && ctrl_info->multi_lun_device_supported)
 		request->ml_device_lun_number = (u8)scmd->device->lun;
 	request->task_management_function = SOP_TASK_MANAGEMENT_LUN_RESET;
 	if (ctrl_info->tmf_iu_timeout_supported)
 		put_unaligned_le16(PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS, &request->timeout);
 
-	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
-		io_request);
+	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH, io_request);
 
 	rc = pqi_wait_for_lun_reset_completion(ctrl_info, device, (u8)scmd->device->lun, &wait);
 	if (rc == 0)
@@ -6384,8 +6147,7 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 		device->sdev = sdev;
 		if (device->queue_depth) {
 			device->advertised_queue_depth = device->queue_depth;
-			scsi_change_queue_depth(sdev,
-				device->advertised_queue_depth);
+			scsi_change_queue_depth(sdev, device->advertised_queue_depth);
 		}
 		if (pqi_is_logical_device(device)) {
 			pqi_disable_write_same(sdev);
@@ -6561,11 +6323,9 @@ static void pqi_error_info_to_ciss(struct pqi_raid_error_info *pqi_error_info,
 		break;
 	}
 
-	sense_data_length =
-		get_unaligned_le16(&pqi_error_info->sense_data_length);
+	sense_data_length = get_unaligned_le16(&pqi_error_info->sense_data_length);
 	if (sense_data_length == 0)
-		sense_data_length =
-		get_unaligned_le16(&pqi_error_info->response_data_length);
+		sense_data_length = get_unaligned_le16(&pqi_error_info->response_data_length);
 	if (sense_data_length)
 		if (sense_data_length > sizeof(pqi_error_info->data))
 			sense_data_length = sizeof(pqi_error_info->data);
@@ -6632,10 +6392,8 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_RAID_PATH_IO;
-	iu_length = offsetof(struct pqi_raid_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
-	memcpy(request.lun_number, iocommand.LUN_info.LunAddrBytes,
-		sizeof(request.lun_number));
+	iu_length = offsetof(struct pqi_raid_path_request, sg_descriptors) - PQI_REQUEST_HEADER_LENGTH;
+	memcpy(request.lun_number, iocommand.LUN_info.LunAddrBytes, sizeof(request.lun_number));
 	memcpy(request.cdb, iocommand.Request.CDB, iocommand.Request.CDBLen);
 	request.additional_cdb_bytes_usage = SOP_ADDITIONAL_CDB_BYTES_0;
 
@@ -6677,24 +6435,19 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info);
 
 	if (iocommand.buf_size > 0)
-		pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1,
-			DMA_BIDIRECTIONAL);
+		pqi_pci_unmap(ctrl_info->pci_dev, request.sg_descriptors, 1, DMA_BIDIRECTIONAL);
 
 	memset(&iocommand.error_info, 0, sizeof(iocommand.error_info));
 
 	if (rc == 0) {
 		pqi_error_info_to_ciss(&pqi_error_info, &ciss_error_info);
 		iocommand.error_info.ScsiStatus = ciss_error_info.scsi_status;
-		iocommand.error_info.CommandStatus =
-			ciss_error_info.command_status;
+		iocommand.error_info.CommandStatus = ciss_error_info.command_status;
 		sense_data_length = ciss_error_info.sense_data_length;
 		if (sense_data_length) {
-			if (sense_data_length >
-				sizeof(iocommand.error_info.SenseInfo))
-				sense_data_length =
-					sizeof(iocommand.error_info.SenseInfo);
-			memcpy(iocommand.error_info.SenseInfo,
-				pqi_error_info.data, sense_data_length);
+			if (sense_data_length > sizeof(iocommand.error_info.SenseInfo))
+				sense_data_length = sizeof(iocommand.error_info.SenseInfo);
+			memcpy(iocommand.error_info.SenseInfo, pqi_error_info.data, sense_data_length);
 			iocommand.error_info.SenseLen = sense_data_length;
 		}
 	}
@@ -7085,38 +6838,30 @@ static ssize_t pqi_path_info_show(struct device *dev,
 					device->lun,
 					scsi_device_type(device->devtype));
 
-		if (device->devtype == TYPE_RAID ||
-			pqi_is_logical_device(device))
+		if (device->devtype == TYPE_RAID || pqi_is_logical_device(device))
 			goto end_buffer;
 
-		memcpy(&phys_connector, &device->phys_connector[i],
-			sizeof(phys_connector));
+		memcpy(&phys_connector, &device->phys_connector[i], sizeof(phys_connector));
 		if (phys_connector[0] < '0')
 			phys_connector[0] = '0';
 		if (phys_connector[1] < '0')
 			phys_connector[1] = '0';
 
 		output_len += scnprintf(buf + output_len,
-					PAGE_SIZE - output_len,
-					"PORT: %.2s ", phys_connector);
+			PAGE_SIZE - output_len, "PORT: %.2s ", phys_connector);
 
 		box = device->box[i];
 		if (box != 0 && box != 0xFF)
 			output_len += scnprintf(buf + output_len,
-						PAGE_SIZE - output_len,
-						"BOX: %hhu ", box);
+				PAGE_SIZE - output_len, "BOX: %hhu ", box);
 
-		if ((device->devtype == TYPE_DISK ||
-			device->devtype == TYPE_ZBC) &&
-			pqi_expose_device(device))
+		if ((device->devtype == TYPE_DISK || device->devtype == TYPE_ZBC) && pqi_expose_device(device))
 			output_len += scnprintf(buf + output_len,
-						PAGE_SIZE - output_len,
-						"BAY: %hhu ", bay);
+				PAGE_SIZE - output_len, "BAY: %hhu ", bay);
 
 end_buffer:
 		output_len += scnprintf(buf + output_len,
-					PAGE_SIZE - output_len,
-					"%s\n", active);
+			PAGE_SIZE - output_len, "%s\n", active);
 	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
@@ -7297,7 +7042,6 @@ static ssize_t pqi_sas_ncq_prio_enable_store(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
-
 	if (!device) {
 		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		return -ENODEV;
@@ -7335,7 +7079,7 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 static DEVICE_ATTR(sas_ncq_prio_enable, 0644,
-		pqi_sas_ncq_prio_enable_show, pqi_sas_ncq_prio_enable_store);
+	pqi_sas_ncq_prio_enable_show, pqi_sas_ncq_prio_enable_store);
 static DEVICE_ATTR(numa_node, 0444, pqi_numa_node_show, NULL);
 
 static struct attribute *pqi_sdev_attrs[] = {
@@ -7510,8 +7254,7 @@ static int pqi_get_ctrl_serial_number(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		goto out;
 
-	memcpy(ctrl_info->serial_number, sense_info->ctrl_serial_number,
-		sizeof(sense_info->ctrl_serial_number));
+	memcpy(ctrl_info->serial_number, sense_info->ctrl_serial_number, sizeof(sense_info->ctrl_serial_number));
 	ctrl_info->serial_number[sizeof(sense_info->ctrl_serial_number)] = '\0';
 
 out:
@@ -7542,8 +7285,7 @@ static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
 		memcpy(ctrl_info->firmware_version,
 			identify->firmware_version_short,
 			sizeof(identify->firmware_version_short));
-		ctrl_info->firmware_version
-			[sizeof(identify->firmware_version_short)] = '\0';
+		ctrl_info->firmware_version[sizeof(identify->firmware_version_short)] = '\0';
 		snprintf(ctrl_info->firmware_version +
 			strlen(ctrl_info->firmware_version),
 			sizeof(ctrl_info->firmware_version) -
@@ -7552,16 +7294,13 @@ static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
 			get_unaligned_le16(&identify->firmware_build_number));
 	}
 
-	memcpy(ctrl_info->model, identify->product_id,
-		sizeof(identify->product_id));
+	memcpy(ctrl_info->model, identify->product_id, sizeof(identify->product_id));
 	ctrl_info->model[sizeof(identify->product_id)] = '\0';
 
-	memcpy(ctrl_info->vendor, identify->vendor_id,
-		sizeof(identify->vendor_id));
+	memcpy(ctrl_info->vendor, identify->vendor_id, sizeof(identify->vendor_id));
 	ctrl_info->vendor[sizeof(identify->vendor_id)] = '\0';
 
-	dev_info(&ctrl_info->pci_dev->dev,
-		"Firmware version: %s\n", ctrl_info->firmware_version);
+	dev_info(&ctrl_info->pci_dev->dev, "Firmware version: %s\n", ctrl_info->firmware_version);
 
 out:
 	kfree(identify);
@@ -7631,14 +7370,10 @@ static int pqi_config_table_update(struct pqi_ctrl_info *ctrl_info,
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_VENDOR_GENERAL;
-	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
-		&request.header.iu_length);
-	put_unaligned_le16(PQI_VENDOR_GENERAL_CONFIG_TABLE_UPDATE,
-		&request.function_code);
-	put_unaligned_le16(first_section,
-		&request.data.config_table_update.first_section);
-	put_unaligned_le16(last_section,
-		&request.data.config_table_update.last_section);
+	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH, &request.header.iu_length);
+	put_unaligned_le16(PQI_VENDOR_GENERAL_CONFIG_TABLE_UPDATE, &request.function_code);
+	put_unaligned_le16(first_section, &request.data.config_table_update.first_section);
+	put_unaligned_le16(last_section, &request.data.config_table_update.last_section);
 
 	return pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, NULL);
 }
@@ -7858,8 +7593,7 @@ static void pqi_process_firmware_features(
 	firmware_features = section_info->section;
 	firmware_features_iomem_addr = section_info->section_iomem_addr;
 
-	for (i = 0, num_features_supported = 0;
-		i < ARRAY_SIZE(pqi_firmware_features); i++) {
+	for (i = 0, num_features_supported = 0; i < ARRAY_SIZE(pqi_firmware_features); i++) {
 		if (pqi_is_firmware_feature_supported(firmware_features,
 			pqi_firmware_features[i].feature_bit)) {
 			pqi_firmware_features[i].supported = true;
@@ -7880,16 +7614,14 @@ static void pqi_process_firmware_features(
 			pqi_firmware_features[i].feature_bit);
 	}
 
-	rc = pqi_enable_firmware_features(ctrl_info, firmware_features,
-		firmware_features_iomem_addr);
+	rc = pqi_enable_firmware_features(ctrl_info, firmware_features, firmware_features_iomem_addr);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
 			"failed to enable firmware features in PQI configuration table\n");
 		for (i = 0; i < ARRAY_SIZE(pqi_firmware_features); i++) {
 			if (!pqi_firmware_features[i].supported)
 				continue;
-			pqi_firmware_feature_update(ctrl_info,
-				&pqi_firmware_features[i]);
+			pqi_firmware_feature_update(ctrl_info, &pqi_firmware_features[i]);
 		}
 		return;
 	}
@@ -7902,8 +7634,7 @@ static void pqi_process_firmware_features(
 			pqi_firmware_features[i].feature_bit)) {
 				pqi_firmware_features[i].enabled = true;
 		}
-		pqi_firmware_feature_update(ctrl_info,
-			&pqi_firmware_features[i]);
+		pqi_firmware_feature_update(ctrl_info, &pqi_firmware_features[i]);
 	}
 }
 
@@ -7996,18 +7727,12 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 				dev_warn(&ctrl_info->pci_dev->dev,
 				"heartbeat disabled by module parameter\n");
 			else
-				ctrl_info->heartbeat_counter =
-					table_iomem_addr +
-					section_offset +
-					offsetof(struct pqi_config_table_heartbeat,
-						heartbeat_counter);
+				ctrl_info->heartbeat_counter = table_iomem_addr + section_offset +
+					offsetof(struct pqi_config_table_heartbeat, heartbeat_counter);
 			break;
 		case PQI_CONFIG_TABLE_SECTION_SOFT_RESET:
-			ctrl_info->soft_reset_status =
-				table_iomem_addr +
-				section_offset +
-				offsetof(struct pqi_config_table_soft_reset,
-					soft_reset_status);
+			ctrl_info->soft_reset_status = table_iomem_addr + section_offset +
+				offsetof(struct pqi_config_table_soft_reset, soft_reset_status);
 			break;
 		}
 
@@ -8141,15 +7866,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->product_revision = (u8)(product_id >> 8);
 
 	if (reset_devices) {
-		if (ctrl_info->max_outstanding_requests >
-			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
-				ctrl_info->max_outstanding_requests =
-					PQI_MAX_OUTSTANDING_REQUESTS_KDUMP;
+		if (ctrl_info->max_outstanding_requests > PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
+			ctrl_info->max_outstanding_requests = PQI_MAX_OUTSTANDING_REQUESTS_KDUMP;
 	} else {
-		if (ctrl_info->max_outstanding_requests >
-			PQI_MAX_OUTSTANDING_REQUESTS)
-				ctrl_info->max_outstanding_requests =
-					PQI_MAX_OUTSTANDING_REQUESTS;
+		if (ctrl_info->max_outstanding_requests > PQI_MAX_OUTSTANDING_REQUESTS)
+			ctrl_info->max_outstanding_requests = PQI_MAX_OUTSTANDING_REQUESTS;
 	}
 
 	pqi_calculate_io_resources(ctrl_info);
@@ -8217,8 +7938,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 
 	if (ctrl_info->num_msix_vectors_enabled < ctrl_info->num_queue_groups) {
-		ctrl_info->max_msix_vectors =
-			ctrl_info->num_msix_vectors_enabled;
+		ctrl_info->max_msix_vectors = ctrl_info->num_msix_vectors_enabled;
 		pqi_calculate_queue_resources(ctrl_info);
 	}
 
@@ -8260,8 +7980,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 				"error obtaining advanced RAID bypass configuration\n");
 			return rc;
 		}
-		ctrl_info->ciss_report_log_flags |=
-			CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX;
+		ctrl_info->ciss_report_log_flags |= CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX;
 	}
 
 	rc = pqi_enable_events(ctrl_info);
@@ -8428,8 +8147,7 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 				"error obtaining advanced RAID bypass configuration\n");
 			return rc;
 		}
-		ctrl_info->ciss_report_log_flags |=
-			CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX;
+		ctrl_info->ciss_report_log_flags |= CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX;
 	}
 
 	rc = pqi_enable_events(ctrl_info);
@@ -8593,10 +8311,8 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	ctrl_info->max_msix_vectors = PQI_MAX_MSIX_VECTORS;
 
 	ctrl_info->ciss_report_log_flags = CISS_REPORT_LOG_FLAG_UNIQUE_LUN_ID;
-	ctrl_info->max_transfer_encrypted_sas_sata =
-		PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_SAS_SATA;
-	ctrl_info->max_transfer_encrypted_nvme =
-		PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_NVME;
+	ctrl_info->max_transfer_encrypted_sas_sata = PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_SAS_SATA;
+	ctrl_info->max_transfer_encrypted_nvme = PQI_DEFAULT_MAX_TRANSFER_ENCRYPTED_NVME;
 	ctrl_info->max_write_raid_5_6 = PQI_DEFAULT_MAX_WRITE_RAID_5_6;
 	ctrl_info->max_write_raid_1_10_2drive = ~0;
 	ctrl_info->max_write_raid_1_10_3drive = ~0;
@@ -8756,8 +8472,7 @@ static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info)
 
 	dev = &ctrl_info->pci_dev->dev;
 
-	ofap = dma_alloc_coherent(dev, sizeof(*ofap),
-		&ctrl_info->pqi_ofa_mem_dma_handle, GFP_KERNEL);
+	ofap = dma_alloc_coherent(dev, sizeof(*ofap), &ctrl_info->pqi_ofa_mem_dma_handle, GFP_KERNEL);
 	if (!ofap)
 		return;
 
@@ -8793,8 +8508,7 @@ static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
 		goto out;
 
 	mem_descriptor = ofap->sg_descriptor;
-	num_memory_descriptors =
-		get_unaligned_le16(&ofap->num_memory_descriptors);
+	num_memory_descriptors = get_unaligned_le16(&ofap->num_memory_descriptors);
 
 	for (i = 0; i < num_memory_descriptors; i++) {
 		dma_free_coherent(dev,
@@ -8805,8 +8519,7 @@ static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info)
 	kfree(ctrl_info->pqi_ofa_chunk_virt_addr);
 
 out:
-	dma_free_coherent(dev, sizeof(*ofap), ofap,
-		ctrl_info->pqi_ofa_mem_dma_handle);
+	dma_free_coherent(dev, sizeof(*ofap), ofap, ctrl_info->pqi_ofa_mem_dma_handle);
 	ctrl_info->pqi_ofa_mem_virt_addr = NULL;
 }
 
@@ -8819,10 +8532,8 @@ static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info)
 	memset(&request, 0, sizeof(request));
 
 	request.header.iu_type = PQI_REQUEST_IU_VENDOR_GENERAL;
-	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH,
-		&request.header.iu_length);
-	put_unaligned_le16(PQI_VENDOR_GENERAL_HOST_MEMORY_UPDATE,
-		&request.function_code);
+	put_unaligned_le16(sizeof(request) - PQI_REQUEST_HEADER_LENGTH, &request.header.iu_length);
+	put_unaligned_le16(PQI_VENDOR_GENERAL_HOST_MEMORY_UPDATE, &request.function_code);
 
 	ofap = ctrl_info->pqi_ofa_mem_virt_addr;
 
@@ -8875,12 +8586,10 @@ static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
 			}
 		} else {
 			io_request->status = -ENXIO;
-			io_request->error_info =
-				&pqi_ctrl_offline_raid_error_info;
+			io_request->error_info = &pqi_ctrl_offline_raid_error_info;
 		}
 
-		io_request->io_complete_callback(io_request,
-			io_request->context);
+		io_request->io_complete_callback(io_request, io_request->context);
 	}
 }
 
@@ -9076,8 +8785,7 @@ static void pqi_process_lockup_action_param(void)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(pqi_lockup_actions); i++) {
-		if (strcmp(pqi_lockup_action_param,
-			pqi_lockup_actions[i].name) == 0) {
+		if (strcmp(pqi_lockup_action_param, pqi_lockup_actions[i].name) == 0) {
 			pqi_lockup_action = pqi_lockup_actions[i].action;
 			return;
 		}
@@ -9992,63 +9700,63 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1014, 0x0718)
+			       0x1014, 0x0718)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1e93, 0x1000)
+			       0x1e93, 0x1000)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1e93, 0x1001)
+			       0x1e93, 0x1001)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1e93, 0x1002)
+			       0x1e93, 0x1002)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1e93, 0x1005)
+			       0x1e93, 0x1005)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1001)
+			       0x1f51, 0x1001)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1002)
+			       0x1f51, 0x1002)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1003)
+			       0x1f51, 0x1003)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1004)
+			       0x1f51, 0x1004)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1005)
+			       0x1f51, 0x1005)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1006)
+			       0x1f51, 0x1006)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1007)
+			       0x1f51, 0x1007)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1008)
+			       0x1f51, 0x1008)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x1009)
+			       0x1f51, 0x1009)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-				0x1f51, 0x100a)
+			       0x1f51, 0x100a)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
@@ -10104,503 +9812,277 @@ module_exit(pqi_cleanup);
 
 static void pqi_verify_structures(void)
 {
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_host_to_ctrl_doorbell) != 0x20);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_interrupt_mask) != 0x34);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_ctrl_to_host_doorbell) != 0x9c);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_ctrl_to_host_doorbell_clear) != 0xa0);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_driver_scratch) != 0xb0);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_product_identifier) != 0xb4);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_firmware_status) != 0xbc);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_ctrl_shutdown_reason_code) != 0xcc);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		sis_mailbox) != 0x1000);
-	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
-		pqi_registers) != 0x4000);
-
-	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		iu_type) != 0x0);
-	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		iu_length) != 0x2);
-	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		response_queue_id) != 0x4);
-	BUILD_BUG_ON(offsetof(struct pqi_iu_header,
-		driver_flags) != 0x6);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_host_to_ctrl_doorbell) != 0x20);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_interrupt_mask) != 0x34);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_ctrl_to_host_doorbell) != 0x9c);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_ctrl_to_host_doorbell_clear) != 0xa0);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_driver_scratch) != 0xb0);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_product_identifier) != 0xb4);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_firmware_status) != 0xbc);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_ctrl_shutdown_reason_code) != 0xcc);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, sis_mailbox) != 0x1000);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers, pqi_registers) != 0x4000);
+
+	BUILD_BUG_ON(offsetof(struct pqi_iu_header, iu_type) != 0x0);
+	BUILD_BUG_ON(offsetof(struct pqi_iu_header, iu_length) != 0x2);
+	BUILD_BUG_ON(offsetof(struct pqi_iu_header, response_queue_id) != 0x4);
+	BUILD_BUG_ON(offsetof(struct pqi_iu_header, driver_flags) != 0x6);
 	BUILD_BUG_ON(sizeof(struct pqi_iu_header) != 0x8);
 
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		status) != 0x0);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		service_response) != 0x1);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		data_present) != 0x2);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		reserved) != 0x3);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		residual_count) != 0x4);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		data_length) != 0x8);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		reserved1) != 0xa);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info,
-		data) != 0xc);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, status) != 0x0);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, service_response) != 0x1);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, data_present) != 0x2);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, reserved) != 0x3);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, residual_count) != 0x4);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, data_length) != 0x8);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, reserved1) != 0xa);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_error_info, data) != 0xc);
 	BUILD_BUG_ON(sizeof(struct pqi_aio_error_info) != 0x10c);
 
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		data_in_result) != 0x0);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		data_out_result) != 0x1);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		reserved) != 0x2);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		status) != 0x5);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		status_qualifier) != 0x6);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		sense_data_length) != 0x8);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		response_data_length) != 0xa);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		data_in_transferred) != 0xc);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		data_out_transferred) != 0x10);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info,
-		data) != 0x14);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, data_in_result) != 0x0);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, data_out_result) != 0x1);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, reserved) != 0x2);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, status) != 0x5);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, status_qualifier) != 0x6);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, sense_data_length) != 0x8);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, response_data_length) != 0xa);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, data_in_transferred) != 0xc);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, data_out_transferred) != 0x10);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_error_info, data) != 0x14);
 	BUILD_BUG_ON(sizeof(struct pqi_raid_error_info) != 0x114);
 
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		signature) != 0x0);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		function_and_status_code) != 0x8);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		max_admin_iq_elements) != 0x10);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		max_admin_oq_elements) != 0x11);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_iq_element_length) != 0x12);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_oq_element_length) != 0x13);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		max_reset_timeout) != 0x14);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		legacy_intx_status) != 0x18);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		legacy_intx_mask_set) != 0x1c);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		legacy_intx_mask_clear) != 0x20);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		device_status) != 0x40);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_iq_pi_offset) != 0x48);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_oq_ci_offset) != 0x50);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_iq_element_array_addr) != 0x58);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_oq_element_array_addr) != 0x60);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_iq_ci_addr) != 0x68);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_oq_pi_addr) != 0x70);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_iq_num_elements) != 0x78);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_oq_num_elements) != 0x79);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		admin_queue_int_msg_num) != 0x7a);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		device_error) != 0x80);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		error_details) != 0x88);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		device_reset) != 0x90);
-	BUILD_BUG_ON(offsetof(struct pqi_device_registers,
-		power_action) != 0x94);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, signature) != 0x0);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, function_and_status_code) != 0x8);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, max_admin_iq_elements) != 0x10);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, max_admin_oq_elements) != 0x11);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_iq_element_length) != 0x12);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_oq_element_length) != 0x13);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, max_reset_timeout) != 0x14);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, legacy_intx_status) != 0x18);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, legacy_intx_mask_set) != 0x1c);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, legacy_intx_mask_clear) != 0x20);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, device_status) != 0x40);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_iq_pi_offset) != 0x48);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_oq_ci_offset) != 0x50);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_iq_element_array_addr) != 0x58);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_oq_element_array_addr) != 0x60);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_iq_ci_addr) != 0x68);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_oq_pi_addr) != 0x70);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_iq_num_elements) != 0x78);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_oq_num_elements) != 0x79);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, admin_queue_int_msg_num) != 0x7a);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, device_error) != 0x80);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, error_details) != 0x88);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, device_reset) != 0x90);
+	BUILD_BUG_ON(offsetof(struct pqi_device_registers, power_action) != 0x94);
 	BUILD_BUG_ON(sizeof(struct pqi_device_registers) != 0x100);
 
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		header.driver_flags) != 6);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		function_code) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.report_device_capability.buffer_length) != 44);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.report_device_capability.sg_descriptor) != 48);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.queue_id) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.element_array_addr) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.ci_addr) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.num_elements) != 32);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.element_length) != 34);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_iq.queue_protocol) != 36);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.queue_id) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.element_array_addr) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.pi_addr) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.num_elements) != 32);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.element_length) != 34);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.queue_protocol) != 36);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.int_msg_num) != 40);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.coalescing_count) != 42);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.min_coalescing_time) != 44);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.create_operational_oq.max_coalescing_time) != 48);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request,
-		data.delete_operational_queue.queue_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, header.driver_flags) != 6);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, function_code) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.report_device_capability.buffer_length) != 44);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.report_device_capability.sg_descriptor) != 48);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.queue_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.element_array_addr) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.ci_addr) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.num_elements) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.element_length) != 34);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_iq.queue_protocol) != 36);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.queue_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.element_array_addr) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.pi_addr) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.num_elements) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.element_length) != 34);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.queue_protocol) != 36);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.int_msg_num) != 40);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.coalescing_count) != 42);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.min_coalescing_time) != 44);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.create_operational_oq.max_coalescing_time) != 48);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_request, data.delete_operational_queue.queue_id) != 12);
 	BUILD_BUG_ON(sizeof(struct pqi_general_admin_request) != 64);
-	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request,
-		data.create_operational_iq) != 64 - 11);
-	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request,
-		data.create_operational_oq) != 64 - 11);
-	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request,
-		data.delete_operational_queue) != 64 - 11);
-
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		header.driver_flags) != 6);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		function_code) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		status) != 11);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		data.create_operational_iq.status_descriptor) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		data.create_operational_iq.iq_pi_offset) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		data.create_operational_oq.status_descriptor) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response,
-		data.create_operational_oq.oq_ci_offset) != 16);
+	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request, data.create_operational_iq) != 64 - 11);
+	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request, data.create_operational_oq) != 64 - 11);
+	BUILD_BUG_ON(sizeof_field(struct pqi_general_admin_request, data.delete_operational_queue) != 64 - 11);
+
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, header.driver_flags) != 6);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, function_code) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, status) != 11);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, data.create_operational_iq.status_descriptor) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, data.create_operational_iq.iq_pi_offset) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, data.create_operational_oq.status_descriptor) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_admin_response, data.create_operational_oq.oq_ci_offset) != 16);
 	BUILD_BUG_ON(sizeof(struct pqi_general_admin_response) != 64);
 
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.response_queue_id) != 4);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		header.driver_flags) != 6);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		nexus_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		buffer_length) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		lun_number) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		protocol_specific) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		error_index) != 27);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		cdb) != 32);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		timeout) != 60);
-	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
-		sg_descriptors) != 64);
-	BUILD_BUG_ON(sizeof(struct pqi_raid_path_request) !=
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
-
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.response_queue_id) != 4);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		header.driver_flags) != 6);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		nexus_id) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		buffer_length) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		data_encryption_key_index) != 22);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		encrypt_tweak_lower) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		encrypt_tweak_upper) != 28);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		cdb) != 32);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		error_index) != 48);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		num_sg_descriptors) != 50);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		cdb_length) != 51);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		lun_number) != 52);
-	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request,
-		sg_descriptors) != 64);
-	BUILD_BUG_ON(sizeof(struct pqi_aio_path_request) !=
-		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
-
-	BUILD_BUG_ON(offsetof(struct pqi_io_response,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_io_response,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_io_response,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_io_response,
-		error_index) != 10);
-
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		header.response_queue_id) != 4);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		data.report_event_configuration.buffer_length) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		data.report_event_configuration.sg_descriptors) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		data.set_event_configuration.global_event_oq_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		data.set_event_configuration.buffer_length) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_general_management_request,
-		data.set_event_configuration.sg_descriptors) != 16);
-
-	BUILD_BUG_ON(offsetof(struct pqi_iu_layer_descriptor,
-		max_inbound_iu_length) != 6);
-	BUILD_BUG_ON(offsetof(struct pqi_iu_layer_descriptor,
-		max_outbound_iu_length) != 14);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, header.response_queue_id) != 4);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, header.driver_flags) != 6);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, nexus_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, buffer_length) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, lun_number) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, protocol_specific) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, error_index) != 27);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, cdb) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, timeout) != 60);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request, sg_descriptors) != 64);
+	BUILD_BUG_ON(sizeof(struct pqi_raid_path_request) != PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
+
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, header.response_queue_id) != 4);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, header.driver_flags) != 6);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, nexus_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, buffer_length) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, data_encryption_key_index) != 22);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, encrypt_tweak_lower) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, encrypt_tweak_upper) != 28);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, cdb) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, error_index) != 48);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, num_sg_descriptors) != 50);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, cdb_length) != 51);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, lun_number) != 52);
+	BUILD_BUG_ON(offsetof(struct pqi_aio_path_request, sg_descriptors) != 64);
+	BUILD_BUG_ON(sizeof(struct pqi_aio_path_request) != PQI_OPERATIONAL_IQ_ELEMENT_LENGTH);
+
+	BUILD_BUG_ON(offsetof(struct pqi_io_response, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_io_response, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_io_response, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_io_response, error_index) != 10);
+
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, header.response_queue_id) != 4);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, data.report_event_configuration.buffer_length) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, data.report_event_configuration.sg_descriptors) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, data.set_event_configuration.global_event_oq_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, data.set_event_configuration.buffer_length) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_general_management_request, data.set_event_configuration.sg_descriptors) != 16);
+
+	BUILD_BUG_ON(offsetof(struct pqi_iu_layer_descriptor, max_inbound_iu_length) != 6);
+	BUILD_BUG_ON(offsetof(struct pqi_iu_layer_descriptor, max_outbound_iu_length) != 14);
 	BUILD_BUG_ON(sizeof(struct pqi_iu_layer_descriptor) != 16);
 
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		data_length) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		iq_arbitration_priority_support_bitmask) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		maximum_aw_a) != 9);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		maximum_aw_b) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		maximum_aw_c) != 11);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_inbound_queues) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_elements_per_iq) != 18);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_iq_element_length) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		min_iq_element_length) != 26);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_outbound_queues) != 30);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_elements_per_oq) != 32);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		intr_coalescing_time_granularity) != 34);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		max_oq_element_length) != 36);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		min_oq_element_length) != 38);
-	BUILD_BUG_ON(offsetof(struct pqi_device_capability,
-		iu_layer_descriptors) != 64);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, data_length) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, iq_arbitration_priority_support_bitmask) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, maximum_aw_a) != 9);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, maximum_aw_b) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, maximum_aw_c) != 11);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_inbound_queues) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_elements_per_iq) != 18);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_iq_element_length) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, min_iq_element_length) != 26);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_outbound_queues) != 30);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_elements_per_oq) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, intr_coalescing_time_granularity) != 34);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, max_oq_element_length) != 36);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, min_oq_element_length) != 38);
+	BUILD_BUG_ON(offsetof(struct pqi_device_capability, iu_layer_descriptors) != 64);
 	BUILD_BUG_ON(sizeof(struct pqi_device_capability) != 576);
 
-	BUILD_BUG_ON(offsetof(struct pqi_event_descriptor,
-		event_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_event_descriptor,
-		oq_id) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_event_descriptor, event_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_event_descriptor, oq_id) != 2);
 	BUILD_BUG_ON(sizeof(struct pqi_event_descriptor) != 4);
 
-	BUILD_BUG_ON(offsetof(struct pqi_event_config,
-		num_event_descriptors) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_event_config,
-		descriptors) != 4);
-
-	BUILD_BUG_ON(PQI_NUM_SUPPORTED_EVENTS !=
-		ARRAY_SIZE(pqi_supported_event_types));
-
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		event_type) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		event_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		additional_event_id) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_event_response,
-		data) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_event_config, num_event_descriptors) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_event_config, descriptors) != 4);
+
+	BUILD_BUG_ON(PQI_NUM_SUPPORTED_EVENTS != ARRAY_SIZE(pqi_supported_event_types));
+
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, event_type) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, event_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, additional_event_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_event_response, data) != 16);
 	BUILD_BUG_ON(sizeof(struct pqi_event_response) != 32);
 
-	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request,
-		event_type) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request,
-		event_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request,
-		additional_event_id) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request, event_type) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request, event_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_event_acknowledge_request, additional_event_id) != 12);
 	BUILD_BUG_ON(sizeof(struct pqi_event_acknowledge_request) != 16);
 
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		nexus_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		timeout) != 14);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		lun_number) != 16);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		protocol_specific) != 24);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		outbound_queue_id_to_manage) != 26);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		request_id_to_manage) != 28);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
-		task_management_function) != 30);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, nexus_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, timeout) != 14);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, lun_number) != 16);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, protocol_specific) != 24);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, outbound_queue_id_to_manage) != 26);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, request_id_to_manage) != 28);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request, task_management_function) != 30);
 	BUILD_BUG_ON(sizeof(struct pqi_task_management_request) != 32);
 
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		header.iu_type) != 0);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		header.iu_length) != 2);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		request_id) != 8);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		nexus_id) != 10);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		additional_response_info) != 12);
-	BUILD_BUG_ON(offsetof(struct pqi_task_management_response,
-		response_code) != 15);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, header.iu_type) != 0);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, header.iu_length) != 2);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, request_id) != 8);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, nexus_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, additional_response_info) != 12);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_response, response_code) != 15);
 	BUILD_BUG_ON(sizeof(struct pqi_task_management_response) != 16);
 
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		configured_logical_drive_count) != 0);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		configuration_signature) != 1);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		firmware_version_short) != 5);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		extended_logical_unit_count) != 154);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		firmware_build_number) != 190);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		vendor_id) != 200);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		product_id) != 208);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		extra_controller_flags) != 286);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		controller_mode) != 292);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		spare_part_number) != 293);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
-		firmware_version_long) != 325);
-
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		phys_bay_in_box) != 115);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		device_type) != 120);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		redundant_path_present_map) != 1736);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		active_path_number) != 1738);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		alternate_paths_phys_connector) != 1739);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		alternate_paths_phys_box_on_port) != 1755);
-	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
-		current_queue_depth_limit) != 1796);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, configured_logical_drive_count) != 0);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, configuration_signature) != 1);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, firmware_version_short) != 5);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, extended_logical_unit_count) != 154);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, firmware_build_number) != 190);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, vendor_id) != 200);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, product_id) != 208);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, extra_controller_flags) != 286);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, controller_mode) != 292);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, spare_part_number) != 293);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_controller, firmware_version_long) != 325);
+
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, phys_bay_in_box) != 115);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, device_type) != 120);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, redundant_path_present_map) != 1736);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, active_path_number) != 1738);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, alternate_paths_phys_connector) != 1739);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, alternate_paths_phys_box_on_port) != 1755);
+	BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device, current_queue_depth_limit) != 1796);
 	BUILD_BUG_ON(sizeof(struct bmic_identify_physical_device) != 2560);
 
 	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_buffer_header) != 4);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header,
-		page_code) != 0);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header,
-		subpage_code) != 1);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header,
-		buffer_length) != 2);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header, page_code) != 0);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header, subpage_code) != 1);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_buffer_header, buffer_length) != 2);
 
 	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_page_header) != 4);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header,
-		page_code) != 0);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header,
-		subpage_code) != 1);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header,
-		page_length) != 2);
-
-	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_io_page_aio_subpage)
-		!= 18);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		header) != 0);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		firmware_read_support) != 4);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		driver_read_support) != 5);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		firmware_write_support) != 6);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		driver_write_support) != 7);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		max_transfer_encrypted_sas_sata) != 8);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		max_transfer_encrypted_nvme) != 10);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		max_write_raid_5_6) != 12);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		max_write_raid_1_10_2drive) != 14);
-	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage,
-		max_write_raid_1_10_3drive) != 16);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header, page_code) != 0);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header, subpage_code) != 1);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_page_header, page_length) != 2);
+
+	BUILD_BUG_ON(sizeof(struct bmic_sense_feature_io_page_aio_subpage) != 18);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, header) != 0);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, firmware_read_support) != 4);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, driver_read_support) != 5);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, firmware_write_support) != 6);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, driver_write_support) != 7);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, max_transfer_encrypted_sas_sata) != 8);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, max_transfer_encrypted_nvme) != 10);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, max_write_raid_5_6) != 12);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, max_write_raid_1_10_2drive) != 14);
+	BUILD_BUG_ON(offsetof(struct bmic_sense_feature_io_page_aio_subpage, max_write_raid_1_10_3drive) != 16);
 
 	BUILD_BUG_ON(PQI_ADMIN_IQ_NUM_ELEMENTS > 255);
 	BUILD_BUG_ON(PQI_ADMIN_OQ_NUM_ELEMENTS > 255);
-	BUILD_BUG_ON(PQI_ADMIN_IQ_ELEMENT_LENGTH %
-		PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
-	BUILD_BUG_ON(PQI_ADMIN_OQ_ELEMENT_LENGTH %
-		PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
+	BUILD_BUG_ON(PQI_ADMIN_IQ_ELEMENT_LENGTH % PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
+	BUILD_BUG_ON(PQI_ADMIN_OQ_ELEMENT_LENGTH % PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
 	BUILD_BUG_ON(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH > 1048560);
-	BUILD_BUG_ON(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH %
-		PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
+	BUILD_BUG_ON(PQI_OPERATIONAL_IQ_ELEMENT_LENGTH % PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
 	BUILD_BUG_ON(PQI_OPERATIONAL_OQ_ELEMENT_LENGTH > 1048560);
-	BUILD_BUG_ON(PQI_OPERATIONAL_OQ_ELEMENT_LENGTH %
-		PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
+	BUILD_BUG_ON(PQI_OPERATIONAL_OQ_ELEMENT_LENGTH % PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT != 0);
 
 	BUILD_BUG_ON(PQI_RESERVED_IO_SLOTS >= PQI_MAX_OUTSTANDING_REQUESTS);
-	BUILD_BUG_ON(PQI_RESERVED_IO_SLOTS >=
-		PQI_MAX_OUTSTANDING_REQUESTS_KDUMP);
+	BUILD_BUG_ON(PQI_RESERVED_IO_SLOTS >= PQI_MAX_OUTSTANDING_REQUESTS_KDUMP);
 }
-- 
2.42.0.rc2

