From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 7/7] scsi: ufs: Update config descriptor documentation
Date: Tue, 29 May 2018 11:17:40 -0700
Message-ID: <20180529181740.195362-8-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change updates the sysfs documentation for the UFS config
descriptor, now that config descriptor fields are writable.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index da154a0d4b4f..d11b0a91f4b2 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -244,7 +244,6 @@ Description:	This file shows whether or not the UFS boot feature is enabled.
 		This is one of the UFS configuration descriptor parameters.
 		More information about the descriptor can be found in the UFS
 		2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_descriptor_access_enable
 Date:		May 2018
@@ -254,7 +253,6 @@ Description:	This file shows whether or not access will be permitted to the
 		boot sequence. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_high_priority_lun
 Date:		May 2018
@@ -263,7 +261,6 @@ Description:	This file shows the identifier of the high priority logical
 		unit. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_init_active_icc_level
 Date:		May 2018
@@ -272,7 +269,6 @@ Description:	This file shows the ICC level in active mode after device
 		initialization or hardware reset. This is one of the UFS
 		configuration descriptor parameters. More information about the
 		descriptor can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_initial_power_mode
 Date:		May 2018
@@ -281,7 +277,6 @@ Description:	This file shows the power mode after device initialization or
 		hardware reset. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_number_of_luns
 Date:		May 2018
@@ -290,7 +285,6 @@ Description:	This file shows the number of logical units that the device will
 		support. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_periodic_rtc_update
 Date:		May 2018
@@ -299,7 +293,6 @@ Description:	This file shows the frequency and method of real time clock
 		updates. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_secure_removal_type
 Date:		May 2018
@@ -308,7 +301,6 @@ Description:	This file shows the secure removal type of the UFS device. This
 		is one of the UFS configuration descriptor parameters. More
 		information about the descriptor can be found in the UFS 2.1
 		specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/cfg_unit
 Date:		May 2018
@@ -327,7 +319,6 @@ Description:	This file shows the number of allocation units assigned to the
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_boot_lun_id
 Date:		May 2018
@@ -338,7 +329,6 @@ Description:	This file shows the boot LUN ID for this logical unit,
 		This is one of the UFS configuration unit descriptor parameters.
 		More information about the descriptor can be found in the UFS
 		2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_context_capabilities
 Date:		May 2018
@@ -348,7 +338,6 @@ Description:	This file shows the context capabilities for the logical unit.
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_data_reliability
 Date:		May 2018
@@ -358,7 +347,6 @@ Description:	This file shows the data reliability for the logical unit.
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_logical_block_size
 Date:		May 2018
@@ -368,7 +356,6 @@ Description:	This file shows the logical block size for the logical unit as
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_lu_enable
 Date:		May 2018
@@ -378,7 +365,6 @@ Description:	This file shows whether or not the logical unit is enabled.
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_lu_write_protect
 Date:		May 2018
@@ -388,7 +374,6 @@ Description:	This file shows the write protect status for the logical unit.
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_memory_type
 Date:		May 2018
@@ -398,7 +383,6 @@ Description:	This file shows the memory type for the logical unit.
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit_provisioning_type
 Date:		May 2018
@@ -408,7 +392,6 @@ Description:	This file shows the provisioning type information for the
 		being displayed. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 
 What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
-- 
2.13.5
