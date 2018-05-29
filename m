From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 4/7] scsi: ufs: sysfs: Document attribute writability
Date: Tue, 29 May 2018 11:17:37 -0700
Message-ID: <20180529181740.195362-5-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change removes the read-only clauses from the documentation
for UFS attributes, which are now writable.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index a1336194628f..da154a0d4b4f 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -859,7 +859,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the boot lun enabled UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/current_power_mode
 Date:		February 2018
@@ -867,7 +866,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the current power mode UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_level
 Date:		February 2018
@@ -875,7 +873,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the active icc level UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_enabled
 Date:		February 2018
@@ -883,7 +880,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the out of order data transfer enabled UFS
 		device attribute. The full information about the attribute
 		could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/bkops_status
 Date:		February 2018
@@ -891,7 +887,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the background operations status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/purge_status
 Date:		February 2018
@@ -899,7 +894,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the purge operation status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in_size
 Date:		February 2018
@@ -907,7 +901,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum data size in a DATA IN
 		UPIU. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_out_size
 Date:		February 2018
@@ -915,7 +908,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum number of bytes that can be
 		requested with a READY TO TRANSFER UPIU. The full information
 		about the attribute could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/reference_clock_frequency
 Date:		February 2018
@@ -923,14 +915,13 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the reference clock frequency UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/configuration_descriptor_lock
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows whether the configuration descriptor is locked.
 		The full information about the attribute could be found at
-		UFS specifications 2.1. The file is read only.
+		UFS specifications 2.1.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_number_of_rtt
 Date:		February 2018
@@ -939,7 +930,6 @@ Description:	This file provides the maximum current number of
 		outstanding RTTs in device that is allowed. The full
 		information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_control
 Date:		February 2018
@@ -947,7 +937,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event control UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_status
 Date:		February 2018
@@ -955,7 +944,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
 Date:		February 2018
@@ -963,14 +951,12 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the ffu status UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_state
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file show the PSA feature status. The full information
 		about the attribute could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_data_size
 Date:		February 2018
@@ -979,7 +965,6 @@ Description:	This file shows the amount of data that the host plans to
 		load to all logical units in pre-soldering state.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 
 What:		/sys/class/scsi_device/*/device/dyn_cap_needed
-- 
2.13.5
