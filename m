From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v1 9/9] ufs: sysfs: attributes
Date: Wed, 27 Dec 2017 15:49:36 +0200
Message-ID: <1514382576-20542-10-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514382576-20542-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514382576-20542-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 141 ++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-sysfs.c               |  90 ++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.h               |   1 +
 drivers/scsi/ufs/ufs.h                     |  27 +++++-
 drivers/scsi/ufs/ufshcd.c                  |   6 +-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 6 files changed, 260 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 832da97..804e952 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -662,4 +662,143 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows whether the device FW update is permanently
 		disabled. The full information about the flag could be found
 		at UFS specifications 2.1.
-		The file is read only.
\ No newline at end of file
+		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/boot_lun_enabled
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the boot lun enabled UFS device attribute.
+		The full information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/current_power_mode
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the current power mode UFS device attribute.
+		The full information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_level
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the active icc level UFS device attribute.
+		The full information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_enabled
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the out of order data transfer enabled UFS
+		device attribute. The full information about the attribute
+		could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/bkops_status
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the background operations status UFS device
+		attribute. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/purge_status
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the purge operation status UFS device
+		attribute. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum data size in a DATA IN
+		UPIU. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_out_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of bytes that can be
+		requested with a READY TO TRANSFER UPIU. The full information
+		about the attribute could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/reference_clock_frequency
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the reference clock frequency UFS device
+		attribute. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/configuration_descriptor_lock
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the configuration descriptor is locked.
+		The full information about the attribute could be found at
+		UFS specifications 2.1. The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_number_of_rtt
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the maximum current number of
+		outstanding RTTs in device that is allowed. The full
+		information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_control
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the exception event control UFS device
+		attribute. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_status
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the exception event status UFS device
+		attribute. The full information about the attribute could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file provides the ffu status UFS device attribute.
+		The full information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_state
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file show the PSA feature status. The full information
+		about the attribute could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_data_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the amount of data that the host plans to
+		load to all logical units in pre-soldering state.
+		The full information about the attribute could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+
+What:		/sys/class/scsi_device/*/device/dyn_cap_needed
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the The amount of physical memory needed
+		to be removed from the physical memory resources pool of
+		the particular logical unit. The full information about
+		the attribute could be found at UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index de80c20..637a907 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -469,6 +469,64 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 	.attrs = ufs_sysfs_device_flags,
 };
 
+#define ufs_sysfs_attribute_show_function(_name, _uname)                      \
+static ssize_t _name##_show(struct device *dev,                               \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	u32 value;                                                            \
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,               \
+		QUERY_ATTR_IDN_##_uname, 0, 0, &value))                       \
+		return -EINVAL;                                               \
+	return sprintf(buf, "0x%08X\n", value);                               \
+}
+
+#define UFS_ATTRIBUTE(_name, _uname)                                          \
+	ufs_sysfs_attribute_show_function(_name, _uname)                      \
+	static DEVICE_ATTR_RO(_name)
+
+UFS_ATTRIBUTE(boot_lun_enabled, BOOT_LU_EN);
+UFS_ATTRIBUTE(current_power_mode, POWER_MODE);
+UFS_ATTRIBUTE(active_icc_level, ACTIVE_ICC_LVL);
+UFS_ATTRIBUTE(ooo_data_enabled, OOO_DATA_EN);
+UFS_ATTRIBUTE(bkops_status, BKOPS_STATUS);
+UFS_ATTRIBUTE(purge_status, PURGE_STATUS);
+UFS_ATTRIBUTE(max_data_in_size, MAX_DATA_IN);
+UFS_ATTRIBUTE(max_data_out_size, MAX_DATA_OUT);
+UFS_ATTRIBUTE(reference_clock_frequency, REF_CLK_FREQ);
+UFS_ATTRIBUTE(configuration_descriptor_lock, CONF_DESC_LOCK);
+UFS_ATTRIBUTE(max_number_of_rtt, MAX_NUM_OF_RTT);
+UFS_ATTRIBUTE(exception_event_control, EE_CONTROL);
+UFS_ATTRIBUTE(exception_event_status, EE_STATUS);
+UFS_ATTRIBUTE(ffu_status, FFU_STATUS);
+UFS_ATTRIBUTE(psa_state, PSA_STATE);
+UFS_ATTRIBUTE(psa_data_size, PSA_DATA_SIZE);
+
+static struct attribute *ufs_sysfs_attributes[] = {
+	&dev_attr_boot_lun_enabled.attr,
+	&dev_attr_current_power_mode.attr,
+	&dev_attr_active_icc_level.attr,
+	&dev_attr_ooo_data_enabled.attr,
+	&dev_attr_bkops_status.attr,
+	&dev_attr_purge_status.attr,
+	&dev_attr_max_data_in_size.attr,
+	&dev_attr_max_data_out_size.attr,
+	&dev_attr_reference_clock_frequency.attr,
+	&dev_attr_configuration_descriptor_lock.attr,
+	&dev_attr_max_number_of_rtt.attr,
+	&dev_attr_exception_event_control.attr,
+	&dev_attr_exception_event_status.attr,
+	&dev_attr_ffu_status.attr,
+	&dev_attr_psa_state.attr,
+	&dev_attr_psa_data_size.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_attributes_group = {
+	.name = "attributes",
+	.attrs = ufs_sysfs_attributes,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
@@ -477,6 +535,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_power_descriptor_group,
 	&ufs_sysfs_string_descriptors_group,
 	&ufs_sysfs_flags_group,
+	&ufs_sysfs_attributes_group,
 	NULL,
 };
 
@@ -538,6 +597,37 @@ struct attribute_group ufs_sysfs_unit_descriptor_group = {
 };
 EXPORT_SYMBOL(ufs_sysfs_unit_descriptor_group);
 
+#define ufs_sysfs_lun_attribute_show_function(_name, _uname)                  \
+static ssize_t _name##_attribute_show(struct device *dev,                     \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	u32 value;                                                            \
+	struct scsi_device *sdev = to_scsi_device(dev);                       \
+	struct ufs_hba *hba = shost_priv(sdev->host);                         \
+	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);                          \
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,               \
+		QUERY_ATTR_IDN_##_uname, lun, 0, &value))                     \
+		return -EINVAL;                                               \
+	return sprintf(buf, "0x%08X\n", value);                               \
+}
+
+#define UFS_LUN_ATTRIBUTE(_name, _uname)                                      \
+	ufs_sysfs_lun_attribute_show_function(_name, _uname)                  \
+	static DEVICE_ATTR_RO(_name##_attribute)
+
+
+UFS_LUN_ATTRIBUTE(dyn_cap_needed, DYN_CAP_NEEDED);
+
+static struct attribute *ufs_sysfs_lun_attributes[] = {
+	&dev_attr_dyn_cap_needed_attribute.attr,
+	NULL,
+};
+
+struct attribute_group ufs_sysfs_lun_attributes_group = {
+	.attrs = ufs_sysfs_lun_attributes,
+};
+EXPORT_SYMBOL(ufs_sysfs_lun_attributes_group);
+
 void ufs_sysfs_add_device_management(struct ufs_hba *hba)
 {
 	int ret;
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index 2d4d7c6..10692de 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -10,4 +10,5 @@ void ufs_sysfs_add_device_management(struct ufs_hba *hba);
 void ufs_sysfs_remove_device_management(struct ufs_hba *hba);
 
 extern struct attribute_group ufs_sysfs_unit_descriptor_group;
+extern struct attribute_group ufs_sysfs_lun_attributes_group;
 #endif
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index df5e73e..14e5bf7 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -145,10 +145,29 @@ enum flag_idn {
 
 /* Attribute idn for Query requests */
 enum attr_idn {
-	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
-	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
-	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
-	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
+	QUERY_ATTR_IDN_BOOT_LU_EN		= 0x00,
+	QUERY_ATTR_IDN_RESERVED			= 0x01,
+	QUERY_ATTR_IDN_POWER_MODE		= 0x02,
+	QUERY_ATTR_IDN_ACTIVE_ICC_LVL		= 0x03,
+	QUERY_ATTR_IDN_OOO_DATA_EN		= 0x04,
+	QUERY_ATTR_IDN_BKOPS_STATUS		= 0x05,
+	QUERY_ATTR_IDN_PURGE_STATUS		= 0x06,
+	QUERY_ATTR_IDN_MAX_DATA_IN		= 0x07,
+	QUERY_ATTR_IDN_MAX_DATA_OUT		= 0x08,
+	QUERY_ATTR_IDN_DYN_CAP_NEEDED		= 0x09,
+	QUERY_ATTR_IDN_REF_CLK_FREQ		= 0x0A,
+	QUERY_ATTR_IDN_CONF_DESC_LOCK		= 0x0B,
+	QUERY_ATTR_IDN_MAX_NUM_OF_RTT		= 0x0C,
+	QUERY_ATTR_IDN_EE_CONTROL		= 0x0D,
+	QUERY_ATTR_IDN_EE_STATUS		= 0x0E,
+	QUERY_ATTR_IDN_SECONDS_PASSED		= 0x0F,
+	QUERY_ATTR_IDN_CNTX_CONF		= 0x10,
+	QUERY_ATTR_IDN_CORR_PRG_BLK_NUM		= 0x11,
+	QUERY_ATTR_IDN_RESERVED2		= 0x12,
+	QUERY_ATTR_IDN_RESERVED3		= 0x13,
+	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
+	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
+	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
 };
 
 /* Descriptor idn for Query requests */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 72e5b9a..24c56df 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2712,8 +2712,8 @@ EXPORT_SYMBOL(ufshcd_query_flag);
  *
  * Returns 0 for success, non-zero in case of failure
 */
-static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
-			enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
+int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
 	struct ufs_query_req *request = NULL;
 	struct ufs_query_res *response = NULL;
@@ -2764,6 +2764,7 @@ static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	ufshcd_release(hba);
 	return err;
 }
+EXPORT_SYMBOL(ufshcd_query_attr);
 
 /**
  * ufshcd_query_attr_retry() - API function for sending query
@@ -6492,6 +6493,7 @@ static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 
 static struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
+	&ufs_sysfs_lun_attributes_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 209c563..5a1b21b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -846,6 +846,8 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
 				  enum desc_idn idn, u8 index, u8 selector,
 				  u8 *desc_buf, int *buf_len);
+int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
-- 
2.7.4
