From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 2/7] scsi: ufs: Add config descriptor documentation
Date: Tue, 29 May 2018 11:17:35 -0700
Message-ID: <20180529181740.195362-3-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change adds the documentation for the new sysfs files plumbed out
for the UFS configuration descriptor.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 174 +++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 016724ec26d5..a1336194628f 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -237,6 +237,180 @@ Description:	This file shows the command maximum timeout for a change
 		The file is read only.
 
 
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_boot_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not the UFS boot feature is enabled.
+		This is one of the UFS configuration descriptor parameters.
+		More information about the descriptor can be found in the UFS
+		2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_descriptor_access_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not access will be permitted to the
+		Device Descriptor after the partial initialization phase of the
+		boot sequence. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_high_priority_lun
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the identifier of the high priority logical
+		unit. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_init_active_icc_level
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the ICC level in active mode after device
+		initialization or hardware reset. This is one of the UFS
+		configuration descriptor parameters. More information about the
+		descriptor can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_initial_power_mode
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the power mode after device initialization or
+		hardware reset. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_number_of_luns
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the number of logical units that the device will
+		support. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_periodic_rtc_update
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the frequency and method of real time clock
+		updates. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_secure_removal_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the secure removal type of the UFS device. This
+		is one of the UFS configuration descriptor parameters. More
+		information about the descriptor can be found in the UFS 2.1
+		specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_unit
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file identifies the logical unit number whose parameters
+		are being displayed by the unit_* files in this directory. This
+		file can be set to different numerical values in order to
+		interact with configuration unit descriptors from additional
+		LUNs.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_allocation_units
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the number of allocation units assigned to the
+		logical unit. The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_boot_lun_id
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the boot LUN ID for this logical unit,
+		indicating whether it is Boot A, Boot B, or not special. The
+		cfg_unit file controls which logical unit is being displayed.
+		This is one of the UFS configuration unit descriptor parameters.
+		More information about the descriptor can be found in the UFS
+		2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_context_capabilities
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the context capabilities for the logical unit.
+		The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_data_reliability
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the data reliability for the logical unit.
+		The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_logical_block_size
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the logical block size for the logical unit as
+		a power of two. The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_lu_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not the logical unit is enabled.
+		The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_lu_write_protect
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the write protect status for the logical unit.
+		The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_memory_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the memory type for the logical unit.
+		The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_provisioning_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the provisioning type information for the
+		logical unit. The cfg_unit file controls which logical unit is
+		being displayed. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+
 What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
-- 
2.13.5
