From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v2 3/9] ufs: sysfs: geometry descriptor
Date: Wed, 27 Dec 2017 17:13:41 +0200
Message-ID: <1514387627-27817-4-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS geometry descriptor
parameters. The group adds "geometry_descriptor" folder under the UFS
driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The parameters
are shown as hexadecimal numbers. The full information about the parameters
could be found at UFS specifications 2.1.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 175 ++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-sysfs.c               |  84 ++++++++++++++
 drivers/scsi/ufs/ufs.h                     |  36 ++++++
 3 files changed, 294 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 35a8731..db68bf6 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -239,4 +239,177 @@ Description:	This file shows the MIPI M-PHY version number in BCD format.
 		This is one of the UFS interconnect descriptor parameters.
 		The full information about the descriptor could be found at
 		UFS specifications 2.1.
-		The file is read only.
\ No newline at end of file
+		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/raw_device_capacity
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the total memory quantity available to
+		the user to configure the device logical units. This is one
+		of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_number_of_luns
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of logical units
+		supported by the UFS device. This is one of the UFS
+		geometry descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/segment_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the segment size. This is one of the UFS
+		geometry descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/allocation_unit_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the allocation unit size. This is one of
+		the UFS geometry descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/min_addressable_block_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the minimum addressable block size. This
+		is one of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at UFS
+		specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/optimal_read_block_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the optimal read block size. This is one
+		of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at UFS
+		specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/optimal_write_block_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the optimal write block size. This is one
+		of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at UFS
+		specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_in_buffer_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum data-in buffer size. This
+		is one of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at UFS
+		specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_out_buffer_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum data-out buffer size. This
+		is one of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at UFS
+		specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/rpmb_rw_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of RPMB frames allowed
+		in Security Protocol In/Out. This is one of the UFS geometry
+		descriptor parameters. The full information about the
+		descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/dyn_capacity_resource_policy
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the dynamic capacity resource policy. This
+		is one of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/data_ordering
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows support for out-of-order data transfer.
+		This is one of the UFS geometry descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_number_of_contexts
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows maximum available number of contexts which
+		are supported by the device. This is one of the UFS geometry
+		descriptor parameters. The full information about the
+		descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sys_data_tag_unit_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows system data tag unit size. This is one of
+		the UFS geometry descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sys_data_tag_resource_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows maximum storage area size allocated by
+		the device to handle system data by the tagging mechanism.
+		This is one of the UFS geometry descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/secure_removal_types
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows supported secure removal types. This is
+		one of the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/memory_types
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows supported memory types. This is one of
+		the UFS geometry descriptor parameters. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_memory_max_alloc_units
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of allocation units for
+		different memory types (system code, non persistent,
+		enhanced type 1-4). This is one of the UFS geometry
+		descriptor parameters. The full information about the
+		descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_memory_capacity_adjustment_factor
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the memory capacity adjustment factor for
+		different memory types (system code, non persistent,
+		enhanced type 1-4). This is one of the UFS geometry
+		descriptor parameters. The full information about the
+		descriptor could be found at UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index b8e29f2..82ba7b1 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -149,9 +149,93 @@ static const struct attribute_group ufs_sysfs_interconnect_descriptor_group = {
 	.attrs = ufs_sysfs_interconnect_descriptor,
 };
 
+#define UFS_GEOMETRY_DESC_PARAM(_name, _uname, _size)                         \
+	UFS_DESC_PARAM(_name, _uname, GEOMETRY, _size)
+
+UFS_GEOMETRY_DESC_PARAM(raw_device_capacity, DEV_CAP, QWORD);
+UFS_GEOMETRY_DESC_PARAM(max_number_of_luns, MAX_NUM_LUN, BYTE);
+UFS_GEOMETRY_DESC_PARAM(segment_size, SEG_SIZE, DWORD);
+UFS_GEOMETRY_DESC_PARAM(allocation_unit_size, ALLOC_UNIT_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(min_addressable_block_size, MIN_BLK_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(optimal_read_block_size, OPT_RD_BLK_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(optimal_write_block_size, OPT_RD_BLK_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(max_in_buffer_size, MAX_IN_BUF_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(max_out_buffer_size, MAX_OUT_BUF_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(rpmb_rw_size, RPMB_RW_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(dyn_capacity_resource_policy, DYN_CAP_RSRC_PLC, BYTE);
+UFS_GEOMETRY_DESC_PARAM(data_ordering, DATA_ORDER, BYTE);
+UFS_GEOMETRY_DESC_PARAM(max_number_of_contexts, MAX_NUM_CTX, BYTE);
+UFS_GEOMETRY_DESC_PARAM(sys_data_tag_unit_size, TAG_UNIT_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(sys_data_tag_resource_size, TAG_RSRC_SIZE, BYTE);
+UFS_GEOMETRY_DESC_PARAM(secure_removal_types, SEC_RM_TYPES, BYTE);
+UFS_GEOMETRY_DESC_PARAM(memory_types, MEM_TYPES, WORD);
+UFS_GEOMETRY_DESC_PARAM(sys_code_memory_max_alloc_units,
+	SCM_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(sys_code_memory_capacity_adjustment_factor,
+	SCM_CAP_ADJ_FCTR, WORD);
+UFS_GEOMETRY_DESC_PARAM(non_persist_memory_max_alloc_units,
+	NPM_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(non_persist_memory_capacity_adjustment_factor,
+	NPM_CAP_ADJ_FCTR, WORD);
+UFS_GEOMETRY_DESC_PARAM(enh1_memory_max_alloc_units,
+	ENM1_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(enh1_memory_capacity_adjustment_factor,
+	ENM1_CAP_ADJ_FCTR, WORD);
+UFS_GEOMETRY_DESC_PARAM(enh2_memory_max_alloc_units,
+	ENM2_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(enh2_memory_capacity_adjustment_factor,
+	ENM2_CAP_ADJ_FCTR, WORD);
+UFS_GEOMETRY_DESC_PARAM(enh3_memory_max_alloc_units,
+	ENM3_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(enh3_memory_capacity_adjustment_factor,
+	ENM3_CAP_ADJ_FCTR, WORD);
+UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
+	ENM4_MAX_NUM_UNITS, DWORD);
+UFS_GEOMETRY_DESC_PARAM(enh4_memory_capacity_adjustment_factor,
+	ENM4_CAP_ADJ_FCTR, WORD);
+
+static struct attribute *ufs_sysfs_geometry_descriptor[] = {
+	&dev_attr_raw_device_capacity.attr,
+	&dev_attr_max_number_of_luns.attr,
+	&dev_attr_segment_size.attr,
+	&dev_attr_allocation_unit_size.attr,
+	&dev_attr_min_addressable_block_size.attr,
+	&dev_attr_optimal_read_block_size.attr,
+	&dev_attr_optimal_write_block_size.attr,
+	&dev_attr_max_in_buffer_size.attr,
+	&dev_attr_max_out_buffer_size.attr,
+	&dev_attr_rpmb_rw_size.attr,
+	&dev_attr_dyn_capacity_resource_policy.attr,
+	&dev_attr_data_ordering.attr,
+	&dev_attr_max_number_of_contexts.attr,
+	&dev_attr_sys_data_tag_unit_size.attr,
+	&dev_attr_sys_data_tag_resource_size.attr,
+	&dev_attr_secure_removal_types.attr,
+	&dev_attr_memory_types.attr,
+	&dev_attr_sys_code_memory_max_alloc_units.attr,
+	&dev_attr_sys_code_memory_capacity_adjustment_factor.attr,
+	&dev_attr_non_persist_memory_max_alloc_units.attr,
+	&dev_attr_non_persist_memory_capacity_adjustment_factor.attr,
+	&dev_attr_enh1_memory_max_alloc_units.attr,
+	&dev_attr_enh1_memory_capacity_adjustment_factor.attr,
+	&dev_attr_enh2_memory_max_alloc_units.attr,
+	&dev_attr_enh2_memory_capacity_adjustment_factor.attr,
+	&dev_attr_enh3_memory_max_alloc_units.attr,
+	&dev_attr_enh3_memory_capacity_adjustment_factor.attr,
+	&dev_attr_enh4_memory_max_alloc_units.attr,
+	&dev_attr_enh4_memory_capacity_adjustment_factor.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_geometry_descriptor_group = {
+	.name = "geometry_descriptor",
+	.attrs = ufs_sysfs_geometry_descriptor,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
+	&ufs_sysfs_geometry_descriptor_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 773c049..04d41c8 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -238,6 +238,42 @@ enum interconnect_desc_param {
 	INTERCONNECT_DESC_PARAM_MPHY_VER	= 0x4,
 };
 
+/* Geometry descriptor parameters offsets in bytes*/
+enum geometry_desc_param {
+	GEOMETRY_DESC_PARAM_LEN			= 0x0,
+	GEOMETRY_DESC_PARAM_TYPE		= 0x1,
+	GEOMETRY_DESC_PARAM_DEV_CAP		= 0x4,
+	GEOMETRY_DESC_PARAM_MAX_NUM_LUN		= 0xC,
+	GEOMETRY_DESC_PARAM_SEG_SIZE		= 0xD,
+	GEOMETRY_DESC_PARAM_ALLOC_UNIT_SIZE	= 0x11,
+	GEOMETRY_DESC_PARAM_MIN_BLK_SIZE	= 0x12,
+	GEOMETRY_DESC_PARAM_OPT_RD_BLK_SIZE	= 0x13,
+	GEOMETRY_DESC_PARAM_OPT_WR_BLK_SIZE	= 0x14,
+	GEOMETRY_DESC_PARAM_MAX_IN_BUF_SIZE	= 0x15,
+	GEOMETRY_DESC_PARAM_MAX_OUT_BUF_SIZE	= 0x16,
+	GEOMETRY_DESC_PARAM_RPMB_RW_SIZE	= 0x17,
+	GEOMETRY_DESC_PARAM_DYN_CAP_RSRC_PLC	= 0x18,
+	GEOMETRY_DESC_PARAM_DATA_ORDER		= 0x19,
+	GEOMETRY_DESC_PARAM_MAX_NUM_CTX		= 0x1A,
+	GEOMETRY_DESC_PARAM_TAG_UNIT_SIZE	= 0x1B,
+	GEOMETRY_DESC_PARAM_TAG_RSRC_SIZE	= 0x1C,
+	GEOMETRY_DESC_PARAM_SEC_RM_TYPES	= 0x1D,
+	GEOMETRY_DESC_PARAM_MEM_TYPES		= 0x1E,
+	GEOMETRY_DESC_PARAM_SCM_MAX_NUM_UNITS	= 0x20,
+	GEOMETRY_DESC_PARAM_SCM_CAP_ADJ_FCTR	= 0x24,
+	GEOMETRY_DESC_PARAM_NPM_MAX_NUM_UNITS	= 0x26,
+	GEOMETRY_DESC_PARAM_NPM_CAP_ADJ_FCTR	= 0x2A,
+	GEOMETRY_DESC_PARAM_ENM1_MAX_NUM_UNITS	= 0x2C,
+	GEOMETRY_DESC_PARAM_ENM1_CAP_ADJ_FCTR	= 0x30,
+	GEOMETRY_DESC_PARAM_ENM2_MAX_NUM_UNITS	= 0x32,
+	GEOMETRY_DESC_PARAM_ENM2_CAP_ADJ_FCTR	= 0x36,
+	GEOMETRY_DESC_PARAM_ENM3_MAX_NUM_UNITS	= 0x38,
+	GEOMETRY_DESC_PARAM_ENM3_CAP_ADJ_FCTR	= 0x3C,
+	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
+	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
+	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+};
+
 /*
  * Logical Unit Write Protect
  * 00h: LU not write protected
-- 
2.7.4
